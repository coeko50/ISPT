package org.zowe.dbapi.utilities;

import java.math.*; // for data types
import java.nio.file.FileSystems;
import java.nio.file.Path;
import java.sql.SQLException;
import java.util.ArrayList;
import java.util.List;

import org.apache.coyote.BadRequestException;
import org.zowe.dbapi.eafDemo.LDM54.JobStandardInfo;
import org.zowe.dbapi.ispt.mapfields.Mapfields;
import org.zowe.dbapi.ispt.record.Record;

import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;

import java.util.HashMap;
import java.util.Iterator;

import lombok.extern.slf4j.Slf4j;
import java.io.*;
import java.net.*;

 
 

@Slf4j
//
public class GenJsonSchema {
    // private static Logger log = LoggerFactory.getLogger(GenJsonSchema.class);
    static final int port = 40115;
    static final String url = "192.168.24.227";
    static final String DB_URL = "jdbc:idms://192.168.24.227:40112/APPLDICT";
    static final String USER = "ispdc";
    static final String PASS = "dirk123";
    static final String SCHEMAURL = "";
    static final String blanks = "                                                         ";
    static final String dataSource = "EAFDICT"  ;                                                
    int[] occBase=new int[2];;
    int[] occSize=new int[2];;
    int occurs = 0;
    int occLvl = 0;
    int recEleCnt=0;
  

    public static void main(String args[]) {
        GenJsonSchema sch = new GenJsonSchema();
        log.debug("hello");
        List<Record> recele = GenTestData.genTestData4();
        JsonSchema jsch = sch.buildSchema("ISPTLMOD", new Short("1"), recele);

        String currentDirectoryPath = FileSystems.getDefault().getPath("src/main/java/org/zowe/dbapi/" + "test/")
                .toAbsolutePath().toString();
        File mtpath = new File(currentDirectoryPath);
        mtpath.mkdirs();

        /*
         * mapfields
         */
        List<Mapfields> mapfields = GenTestData.genTestDataMap4();
        sch.updateSchemaWithMapInfo(jsch, mapfields);

        List<String> jsonSch = sch.genSchema(jsch);
        File schFile = new File(currentDirectoryPath + "/" + jsch.getName() + ".json");
        for (String l : jsonSch) {
            print(l);
        }
        GenJsonSchema.writeFile(jsonSch, schFile);

        jsonSch = sch.genRecEleSelectList(jsch);
        for (String l : jsonSch) {
            print(l);
        }
        GenJsonSchema.writeFile(jsonSch, new File(currentDirectoryPath + "/test_recordSelect.json"));
        jsonSch = sch.primeLoadModule(jsch);
        GenJsonSchema.writeFile(jsonSch, new File(currentDirectoryPath + "/primeloadmod.ads"));
        jsonSch = sch.genJsonLoadModule(jsch);
        for (String row :jsonSch) {
            System.out.print(row);
        }
     /*
      * send it to idms to store it in a load module
      */
      try {
        sch.postLoadMod(dataSource, jsonSch);
      } catch (Exception e) {
        e.printStackTrace();
      }
        for (String l : jsonSch) {
            print(l);
        }
    }

    public static void print(String str) {
        System.out.println(str);
    }

    /*
     * buildSchema from IDD view ISPT.RECORD_INFO extract
     */
    public JsonSchema buildSchema(String schemaName, Short mapver, List<Record> recele) {
        JsonSchema jsch = new JsonSchema(schemaName);
        JsonRecordNode rec = null;
        JsonNode prevNode = null;
        JsonNode parent = null;

        Iterator<Record> eleIter = recele.iterator();
        while (eleIter.hasNext()) {
            Record ele = eleIter.next();
            int lvl = ele.getLvl().intValue();
            int prevLvl = 0;
            if ((rec == null) || !(ele.getRec().equalsIgnoreCase(rec.getName()) && ele.getRecVer() == rec.getRecver())) {
                rec = new JsonRecordNode(ele.getRec(), ele.getRecVer());
                jsch.getRecords().add(rec);
                rec.setSchema(jsch);
                prevNode = rec;
                parent = rec;
            }
            if (!(prevNode instanceof JsonRecordNode))
                prevLvl = ((JsonDataNode) prevNode).getLvl();
            if (ele.getSeq().shortValue() == 5200)
                print("ons is hier  " + ele.getEle());
            parent = prevNode.getParent(lvl);

            log.debug("{} ele {} lvl {} prevLvl {} isgrp {} occ {} {} redef {}  type {} ", ele.getSeq().shortValue(),
                    ele.getJsonfld(), ele.getLvl(), prevLvl,
                    ele.getIsGrp(), ele.getOcc(), ele.getOccLvl(), ele.getRedefEle(), ele.getDtype());

            // insert an array node if needed

            /* the element has a occurs clause - insert it as a new node */
            if (ele.getOcc() > 1) {
                JsonArrayNode occNode = new JsonArrayNode(rec, ele, null);
                occNode.setParent(parent);
                parent.getChildren().add(occNode);
                occNode.setLvl(occNode.getLvl());
                prevNode = occNode;
                parent = occNode; // the arraynode become the parent for the datanode that occurs
            }

            /*
             * the current element redefines a previously defined element
             * -- change that field to a redef field, if not so already and add this element
             * as a child
             */

            if (ele.getRedefEle().intValue() > 0) { // this ele redefine someone.
                JsonRedefNode rnode;
                Integer redefName = ele.getRedefEle();
                 
                JsonDataNode tnode = ((JsonDataNode) prevNode).getRedefinedNode(redefName); // find the redefined ele
                if (!(tnode instanceof JsonRedefNode)) { // 1st time
                    rnode = new JsonRedefNode();
                    rnode.transfer(tnode);
                } else {
                    rnode = (JsonRedefNode) tnode;
                }
                prevNode = rnode;
                parent = rnode;
            }

            JsonDataNode node = null;
            Jtype type;

            // insert a group field else a normal datafield
            if (ele.getIsGrp().charAt(0) == 'Y') {
                node = new JsonObjectNode(rec, ele, null);
            } else {
                type = buildType(ele);
                node = new JsonFieldNode(rec, ele, type, null);
                node.setRecord(rec);
                ((JsonFieldNode) node).setPicture(ele.getPicture());

            }
            jsch.getNodes().put(ele.getEle() + ele.getSeq().intValue(), node);
            prevNode = node;

            node.setParent(parent);
            parent.getChildren().add(node);

        }

        return jsch;

    }

    /*
     * buildJson
     * 
     */
    public void buildJson(JsonSchema jsch, Iterator<Record> eleIter, JsonNode prevNode, JsonRecordNode rec) {

    }

    public String addPrefix(String name, String prefix) {
        if (prefix.equals(name.substring(0, prefix.length())))
            return name;
        return prefix + name;
    }
    /*
     * buildType
     * mode:
     * 0 DISPLAY
     * 1 COMPUTATIONAL (binary)
     * 2 COMPUTATIONAL-1 (short-precision floating point)
     * 3 COMPUTATIONAL-2 (long-precision floating point)
     * 4 COMPUTATIONAL-3 (packed decimal)
     * 5 BIT (bit string)
     * 6 POINTER (fullword address constant)
     * 7 DISPLAY-1 (Kanji/DBCS)
     * 8 SQLBINARY (SQL datatype BINARY)
     * 88 CONDITION-NAME (COBOL level-88
     */

    Jtype buildType(Record ele) {
        Jtype type = null;
        int max = 0;
        switch (ele.getDtype()) {
            case 1:
            case 0:
                type = new Jstring(ele.getLen().shortValue());
                break;
            case 5:
                max = 1 << ele.getPrec().shortValue();
                type = new Jinteger(max);
                break;
            case 2:
            case 3:
            case 128:
            case 129:
                max = ele.getPrec().shortValue() - ele.getScale().shortValue();

                if (ele.getMode().shortValue() < 2)
                    type = new Jinteger(max);
                else
                    type = new Jnumeric(max, ele.getPrec().intValue(), ele.getScale().intValue(), "");

        }
        log.debug("{}  len {} max {}  prec {}  scale {}", ele.getEle(), ele.getLen(), max, ele.getPrec().shortValue(),
                ele.getScale().shortValue());
        if (type != null)
            type.setJtype(ele);
        return type;
    }

    /*
     * genschema
     */
    public List<String> genSchema(JsonSchema jsch) {
        List<String> jsonSch = new ArrayList<String>();
        List<String> redefs = new ArrayList<String>();
        // log.setLevel(Level.DEBUG);
        int glvl = 0;
        log.debug("let the games began");
        String spaces;
        boolean cont = false;
        for (JsonRecordNode rec : jsch.getRecords()) {
            jsonSch.add("  \"" + rec.getName().toUpperCase() + "\" : {");
            jsonSch.add("   \"type\": \"object\",");
            jsonSch.add("   \"properties\": { ");
            for (JsonDataNode child : rec.getChildren()) {
                jsonSch.addAll(genJson(child, cont));

                redefs = genRefObjs(child, new HashMap<String, String>());
            }
            if (redefs.size() > 0) {
                jsonSch.add("  ,\"$defs\": {");
                jsonSch.addAll(redefs);
                jsonSch.add("}");
            }

            jsonSch.add("    }"); // record properties end
            jsonSch.add("  }"); // record end
        }
        // jsonSch.add(" }"); // properties end
        jsonSch.add("}"); // schema end
        return jsonSch;
    }

    /*
     * genJson
     */
    public List<String> genJson(JsonDataNode node, boolean cont) {
        List<String> jsonSch = new ArrayList<String>();
        String spaces = blanks.substring(0, minimum((node.getLvl() - 1) * 2, 0));

        if (node instanceof JsonFieldNode) {
            genJsonEntry(node, jsonSch, 0, cont);
        }
        // if the node is a redefined node - then gen a oneOf list
        if (node instanceof JsonRedefNode) {
            jsonSch.addAll(genOneOf((JsonRedefNode) node));
            return jsonSch;
        }
        if (node instanceof JsonArrayNode) {
            genJsonEntry(node, jsonSch, 0, cont);
            for (JsonDataNode child : node.getChildren()) {
                jsonSch.addAll(genJson(child, cont));
                spaces = blanks.substring(0, (child.getLvl() - 1) * 2);
                jsonSch.add(spaces + "   4}");
                cont = true;
            }
            jsonSch.add(spaces + "   5}");
        }

        cont = false;
        if (node instanceof JsonObjectNode) {
            for (JsonDataNode child : node.getChildren()) {
                jsonSch.addAll(genJson(child, cont));
                spaces = blanks.substring(0, (child.getLvl() - 1) * 2);
                jsonSch.add(spaces + "   6}");
                cont = true;
            }
        }
        jsonSch.add(spaces + "   1}");
        return jsonSch;
    }

    public int minimum(int v1, int v2) {
        if (v1 < v2)
            return v2;
        return v1;
    }

    /*
     * genRefObjs
     */
    public List<String> genRefObjs(JsonDataNode node, HashMap<String, String> redefObj) {
        List<String> jsonSch = new ArrayList<String>();
        String spaces = blanks.substring(0, minimum((node.getLvl() - 1) * 2, 0));
        if (node instanceof JsonObjectNode) {
            for (JsonDataNode child : node.getChildren()) {
                boolean cont = false;
                if (child instanceof JsonRedefNode) {
                    for (JsonDataNode redef : child.getChildren()) {
                        if (!redefObj.containsKey(redef.getName())) { // same redef grouping may exists
                            redefObj.put(redef.getName(), "");
                            jsonSch.addAll(genJson(redef, cont));
                            spaces = blanks.substring(0, (redef.getLvl() - 1) * 2);
                            jsonSch.add(spaces + "   }");
                            cont = true;
                        }
                    }
                }
                jsonSch.addAll(genRefObjs(child, redefObj));
            }
        }
        return jsonSch;
    }

    /*
     * genJsonEntry
     */
    void genJsonEntry(JsonDataNode node, List<String> jsonSch, int glvl, boolean cont) {

        String spaces = blanks.substring(0, minimum((node.getLvl() - 1) * 2, 0));
        /*
         * if (inode instanceof JsonSchemaNode) {
         * 
         * jsonSch.add("{ ");
         * jsonSch.add("\"$sid\": \"" + SCHEMAURL + "/" + ((JsonRootNode)
         * node).getSchema().getName() + "\",");
         * 
         * jsonSch.add("\"$schema\": \"" + SCHEMAURL + "/" + ((JsonRootNode)
         * node).getSchema().getName() + "\",");
         * jsonSch.add("\"type\": \"object\",");
         * jsonSch.add("\"record\": \"" + ((JsonRootNode) node).getSchema().getRecord()
         * + "\",");
         * jsonSch.add("\"properties\": {");
         * return;
         * }
         */
        log.debug("genJsonEntry {} {}", node.getName(), node.getClass());
        if (node instanceof JsonFieldNode) {
            JsonFieldNode fnode = (JsonFieldNode) node;
            log.debug("    type {}", fnode.getType());
            jsonSch.add(spaces + (cont ? "," : "") + "\"" + fnode.getName().toLowerCase() + "\" : {");
            jsonSch.add(spaces + "   \"description\": \"" + fnode.getDesc() + "\",");
            jsonSch.add(spaces + "   \"element\": \"" + fnode.getElement().toUpperCase()  + "\",");
            jsonSch.add(spaces + "   \"seq\": " + fnode.getSeq() + ",");
            jsonSch.add(spaces + "   \"relativeOffset\": " + fnode.getOffset() + ",");
            jsonSch.add(spaces + "   \"lvl\": " + fnode.getLvl() + ",");
        }
        if (node instanceof JsonArrayNode) { // an array (single value ot object)
            jsonSch.add(spaces + "   \"type\" : \"array\" , \"maxContains\":" + ((JsonArrayNode) node).getMaxContains()
                    + ", \"items\": {");
            spaces += "   ";
        }
        if (node instanceof JsonRedefNode) {
            jsonSch.add(spaces + "   \"type\" : \"object\",");
        } else if (node instanceof JsonObjectNode) {
            jsonSch.add(spaces + "   \"type\" : \"object\", \"properties\": {");
        } else {
            jsonSch.add(spaces + "   \"type\" : " + ((JsonFieldNode) node).getType().toString());
        }
        return;
    }

    String getSchemaObj(int lvl) {
        return "";
    }

    /*
     * findreDefs
     */
    public HashMap<Integer, List<String>> findRedefs(List<Record> recele) {
        HashMap<Integer, List<String>> redefs = new HashMap<Integer, List<String>>();
        List<String> rlist;
        for (Record ele : recele) {
            if ((ele.getRedefLvl().shortValue() == 0) || (ele.getRedefEle()  == 0))
                continue;

            Integer rkey =  ele.getRedefEle() ;
            if (redefs.containsKey(ele.getRedefEle())) {
                rlist = redefs.get(rkey);
            } else {
                rlist = new ArrayList<String>();
                redefs.put(rkey, rlist);
            }
            if (!rlist.contains(ele.getJsonfld())) {
                rlist.add(ele.getJsonfld());
            }
        }
        return redefs;
    }

    /*
     * genOneOf
     */
    public List<String> genOneOf(JsonRedefNode node) {
        List<String> jsonSch = new ArrayList<String>();
        String spaces = blanks.substring(0, 3 + minimum(((node.getLvl() - 1) * 2), 0));
        jsonSch.add(spaces + "   \"oneOf\": [ ");
        char cont = ' ';
        for (JsonDataNode child : node.getChildren()) {
            jsonSch.add(spaces + cont + "{ \"$ref\": \"#/$defs/" + child.getJsonFld() + "\" }");
            cont = ',';
        }

        jsonSch.add(spaces + "]");
        return jsonSch;
    }

    String getType(Record ele) {
        String dtype = "";
        String prec = "999999999999999";
        switch (ele.getDtype()) {
            case 1:
            case 0:
                dtype = "\"string\" , \"maxlength\" :" + ele.getLen().shortValue();
                break;
            case 2:
            case 3:
            case 5:
            case 128:
            case 129:
                if (ele.getMode().shortValue() < 2)
                    dtype = "\"integer\"";
                else
                    dtype = "\"numeric\"";
                dtype += ", \"maximum\" :"
                        + prec.substring(0, ele.getPrec().shortValue() - ele.getScale().shortValue());
            default:
                dtype = "unknown-" + ele.getDtype() + "-" + ele.getMode();
        }
        log.debug("datatype for {} is {} mode {}", ele.getEle(), ele.getDtype(), ele.getMode());
        return dtype;
    }

    public void updateSchemaWithMapInfo(JsonSchema jsch, List<Mapfields> mapfields) {
        for (Mapfields mfld : mapfields) {
            if (jsch.getNodes().containsKey(mfld.getEle() + mfld.getSeq().intValue())) {
                JsonDataNode node = jsch.getNodes().get(mfld.getEle() + mfld.getSeq().intValue());
                node.setMapfield(true);
                node.setUpdateable(mfld.getUpdateable().equalsIgnoreCase("Y") ? true : false);
                node.setRequired(mfld.getRequired().equalsIgnoreCase("Y") ? true : false);
                node.setSel4Output( true);
               
                node.setJsonSchField(true);
                
                if (node instanceof JsonFieldNode)
                    ((JsonFieldNode) node).setPicture(mfld.getPic());
                // go up in the level chain and make all group fields mapfields
                setParentAsMapfield(node);
            } else {
                log.debug("terrible situation encountered,mapfield  {} not to be found in jsonrec",
                        mfld.getEle() + mfld.getSeq().intValue());
            }
        }
    }

    public void setParentAsMapfield(JsonDataNode node) {
        JsonNode parent = node.getParent();
        if (parent != null && parent instanceof JsonFieldNode) {
            ((JsonFieldNode) parent).setMapfield(true);
            setParentAsMapfield((JsonFieldNode) parent);
            node.setJsonSchField(true);
            node.setJsonRequired(true);
        }

    }

    public List<String> genRecEleSelectList(JsonSchema jsch) {
        List<String> recList = new ArrayList<String>();
        HashMap<String, JsonDataNode> redefObj = new HashMap<String, JsonDataNode>();
        recList.add("{ [");
        for (JsonRecordNode rec : jsch.getRecords()) {
            for (JsonDataNode node : rec.getChildren()) {

                recList.addAll(genRecEleSelectList(node, " "));
                // recList.addAll(genRedefSelectList(node, redefObj));
            }
        }
        recList.add("] }");

        return recList;
    }

    public List<String> genRedefSelectList(JsonDataNode node, HashMap<String, JsonDataNode> redefObj) {
        List<String> recList = new ArrayList<String>();
        for (JsonDataNode child : node.getChildren()) {
            for (JsonDataNode redef : ((JsonRedefNode) child).getChildren()) {
                if (!redefObj.containsKey(redef.getName())) { // same redef grouping may exists
                    redefObj.put(redef.getName(), redef);
                    recList.addAll(genRecEleSelectList(redef, ","));
                }
            }
            recList.addAll(genRedefSelectList(child, redefObj));
        }
        return recList;
    }

    public List<String> genRecEleSelectList(JsonDataNode node, String cont) {
        log.debug("genlist {} {}", node.getClass(), node.getName());
        List<String> recList = new ArrayList<String>();
        if (node instanceof JsonArrayNode) {
            recList.add(cont + "[");
        } else {
            recList.add(cont + "{ \"rec\" :\"" + node.getRecord().getName() + "\""
                    + ",\"lvl\" :" + node.getLvl()
                    + ", \"ele\" :\"" + node.getName() + "\"" + blanks.substring(0, 32 - node.getName().length())
                    + ", \"seq\" :" + node.getSeq()
                    + ", \"include\" :\"" + node.isJsonSchField()
                    + "\", \"selected4Output\" :\"" + node.isSel4Output()
                    + "\", \"updateable\" :\"" + node.isUpdateable()
                    + "\", \"required\" :\"" + node.isJsonRequired()
                    + "\"}");
        }
        cont = ",";
        if (node instanceof JsonObjectNode) {
            for (JsonDataNode child : node.getChildren()) {
                recList.addAll(genRecEleSelectList(child, cont));
            }
            if (node instanceof JsonArrayNode)
                recList.add("]");
        }
        return recList;

    }

    public List<String> genJsonLoadModule(JsonSchema sch) {
        List<String> recList = new ArrayList<String>();
        List<String> eleList = new ArrayList<String>();
        char cont = ' ';
        HashMap<String, JsonDataNode> redefObj = new HashMap<String, JsonDataNode>();
    //    recList.add(stringPad(sch.getName(), 8) + toZoneNumeric(sch.getRecords().size(), 4));
        recList.add( "{ \"schema_info\" : { \"schema_name\" : \""+sch.getName()+"\""
         + ", \"rec_count\" :"+sch.getRecords().size() 
         + ", \"sch_ele_count\" : "+sch.countElements()
         + ", \"sch_ele_offset\" : "+(sch.getRecords().size()*40 + 14) +"}");       // lenght of schema_info and record_info is fixed
        recList.add( ",\"rec_info\" : [");
        cont=' ';
     //   recList.add("Lvl,IsGrp,Name                            ,Seq   ,chldCnt,Offset, Len, Dlen, -occBase- -occSize-,occBase,occurs, occlvl, occBase,occSize,isUpdateable,isJsonRequired , dtype, Usage,Len,Prec, Scale, Udc, UdcVal, ");
     int recEleOffset = 0;
     for (JsonRecordNode rec : sch.getRecords()) {
                int recEleCnt = rec.countElements() ; 
             
            recList.add(cont+"{ \"rec_name\":\""+rec.getName()+"\"" 
             + ", \"rec_version\":"+rec.getRecver()     
             + ", \"ele_count\":"+recEleCnt   
             + ", \"rec_childCnt\":"+rec.getChildren().size()
             + ", \"rec_ele_offset\":"+recEleOffset+" }"); 
             recEleOffset += recEleCnt;
 
            cont = ',';
        }
        recList.add("] \n");
        recList.add(",\"ele_info\" : [ ");

        // process all the record elements    
          cont=' ';
           recEleOffset = 0;
           int recCnt = 0;
           for (JsonRecordNode rec : sch.getRecords()) {   
            int recEleCnt = rec.countElements() ;      
            recCnt++;
              for (JsonDataNode node : rec.getChildren()) {
               recList.addAll(genJsonLoadModule(cont,node, recCnt,recEleOffset));
               cont=',';
              }
              recEleOffset += recEleCnt;
           }
       log.debug("ele count = {} -- {} cont={}",eleList.size(),recEleCnt,cont);
 
        recList.add("]");    // eleInfo end
        recList.add("}");    // json document end
    return recList;
    }
    public List<String> primeLoadModule(JsonSchema sch) {
        List<String> recList = new ArrayList<String>();
      
        char cont = ' ';
        HashMap<String, JsonDataNode> redefObj = new HashMap<String, JsonDataNode>();
    //    recList.add(stringPad(sch.getName(), 8) + toZoneNumeric(sch.getRecords().size(), 4));
    recList.add( "mod process ISPT-LOADMOD-PRIME ");
    recList.add( "process source follows ");
    recList.add( "move '"+sch.getName()+"'  TO W-SCHEMA-NAME. "  );
    recList.add( "move 'ISPTJLOD'  TO W-SCHEMA-NAME. "  );
    recList.add( "move "+toZoneNumeric(sch.getRecords().size(),2) +" to w-rec-count.");
    recList.add( "move "+toZoneNumeric(sch.countElements(),4) +" to w-sch-ele-count.");
    recList.add( "compute w-sch-ele-offset = slen(w-schema-info) +  ");
    recList.add( "        (w-rec-count * slen(w-rec-info(1))) .");
    recList.add( "call addSch.");
    recList.add( "move w-sch-ele-offset to w-rec-ele-offset(1).");
    int i = 0;
        for (JsonRecordNode rec : sch.getRecords()) {
        i++;
        recList.add( " move '"+rec.getName()+"'  TO w-rec-name("+i+"). "  );
        recList.add( " move "+rec.getRecver() +" to W-REC-VERSION("+i+"). "  );
        recList.add( " move "+rec.countElements() +" to W-ELE-COUNT("+i+"). "  );
        recList.add( " move "+rec.getChildren().size()+" to W-REC-CHILDCNT("+i+"). "  );
        if (i < 5) {
         recList.add( "compute w-rec-ele-offset("+(i+1)+") = w-rec-ele-offset("+i+") + ");
         recList.add( "          (slen(w-ele-info(1)) * w-ele-count("+i+")).");
        }

        recList.add( "call addRec.");
        recList.add( "move 0 to w-ecnt.");
       }
        int recCnt = 0;
         for (JsonRecordNode rec : sch.getRecords()) {
            recCnt++;
            recEleCnt=0;
            for (JsonDataNode node : rec.getChildren()) {
                recList.addAll(primeLoadModule(node, recCnt));
              }
          }
          recList.add( "call addEle.");
          recList.add( "call prolog.");
          recList.add("move concat(w-schema-name,' was successfully saved in ',"); 
          recList.add ("     db-name) to w-buffer.");                                   
          recList.add( "return. ");
          recList.add( " include ISPT-LOADMOD-PRIME-subroutines. ");
          recList.add( "msend.");
          return recList;
    }

    public String stringPad(String val, int len) {
        return val + blanks.substring(0, minimum(len - val.length(), 1));
    }

    public List<String> genRedefLoadModule(JsonDataNode node, HashMap<String, JsonDataNode> redefObj, int recId, int receleOffset) {
        List<String> recList = new ArrayList<String>();
        char cont = ' ';
        recList.addAll(genJsonLoadModule(cont,node, recId,receleOffset));
        if (node instanceof JsonObjectNode) {
            for (JsonDataNode child : node.getChildren()) {
                if (child instanceof JsonRedefNode) {
                    for (JsonDataNode redef : (child).getChildren()) {
                        if (!redefObj.containsKey(redef.getName())) { // same redef grouping may exists
                            redefObj.put(redef.getName(), redef);
                            recList.addAll(genJsonLoadModule(cont,redef, recId,receleOffset));
                        }
                    }
                    recList.addAll(genRedefLoadModule(child, redefObj, recId,receleOffset));
                }
            }
        }
        return recList;
    }

    public List<String> genJsonLoadModule(char cont,JsonDataNode node, int recId,int receleOffset) {
        log.debug("genJsonLoadModule( {}", node.getName());
        List<String> recList = new ArrayList<String>();
        List<String> recAds = new ArrayList<String>(); String sep = "";
        int childcnt = 0;
        JsonFieldNode ele;
       
 
        if (node instanceof JsonObjectNode) {
         if (node.getChildren().size() == 0) 
            log.debug("big problem");
          
            if (node instanceof JsonArrayNode) {
                        JsonDataNode child = node.getChildren().get(0);
                     recList.addAll( genJsonLoadModule(cont, child , recId,receleOffset));
  
            } else  {
                
                 recList.add(genLoadElementEntry(cont,node, recId,receleOffset));     // add the group as a ele
                 cont = ',';
                 for (JsonDataNode child: node.getChildren()) {
                      recList.addAll(  genJsonLoadModule(cont, child, recId,receleOffset)); 
        
                 }
     
            }
 
        }
         
        if (node instanceof JsonFieldNode) {
            recList.add(genLoadElementEntry(cont,node, recId,receleOffset));
        }

        return recList;

    }
 
  public String genLoadElementEntry(char cont,JsonDataNode child, int recId, int recEleOffset ) {

                recEleCnt++;
                String row = cont+"{ \"ele_node_info\" : {";
                int off = child.getParentOffset();
                off = (off < 0) ? off : ((off / 100) ) + recEleOffset;  // convert line index to offset
                row += "  \"parent_offset\" : " + off;
                off = child.getNextOffset();
                 off = (off < 0) ? off : ((off / 100) - 1) + recEleOffset;  // convert line index to offset
                row += ", \"next_offset\" : " + off;
                 off = child.get1stChildOffset();
                 off = (off < 0) ? off : ((off / 100) - 1) + recEleOffset;  // convert line index to offset
                row += ", \"1stChild_offset\" : " + off;
                row += "} \r\n ,\"ele_db_info\" : {";
                row += "  \"jsonfld\" :\""    + child.getJsonFld() + "\""  ;
                row += ", \"ele_lvl\" : "     +   child.getLvl()       ;
                row += ", \"ele_element\" :\""+ child.getName()  + "\""      ;
                row += ", \"ele_seq\" : "     +   child.getSeq()       ;
                row += ", \"ele_parent_type\" : \"" + child.getParentType() + "\"" ;
             
                if (child instanceof JsonObjectNode) 
                       row += ", \"ele_childcnt\" : "+    child.getChildren().size()   ;
                else 
                        row += ", \"ele_childcnt\" : 0" ;   
                row += ", \"ele_offset\" : "  +   child.getOffset()    ;
                row += ", \"ele_len\" : "     +   child.getLen()       ;
                row += ", \"ele_dlen\" : "    +   child.getDlen()      ;
                row += ", \"ele_occ\" : "     +   child.getOcc()               ;
                                                                   
                row += ", \"ele_occ_depend_ind\" :\""  +  child.getDependInd() + "\""    ;
                row += ", \"ele_occ_depend_offset\" : "+    child.getDependOffset()  ;  
                row += ", \"ele_occlvl\" : "           +    child.getOccLvl()   ;
               
                if (child.getOccLvl() == 0) {
                    row += ", \"ele_occ_offset\" : 0 " ;
                    row += ", \"ele_occsize\" : [0,0]"  ;
                 } else if (child.getOccLvl() == 1) {  
                    row += ", \"ele_occ_offset\" : "       +  ( child.getOccOffset(1) +  child.getOffset() )  ;
                    row += ", \"ele_occsize\" : ["  +   child.getOccSize(1) + ", 0]"  ;   
                 } else {
                    row += ", \"ele_occ_offset\" : "       + ( child.getOccOffset(1) + child.getOccOffset(2) +  child.getOffset());
                    row += ", \"ele_occsize\" : ["          +   child.getOccSize(1) + "," +  child.getOccSize(2) + "]"  ;   
                }
                row += ", \"ele_isgroupele\" :\""      +  child.getIsGrp()  + "\"" ; 
 
                if (child.getIsGrp().equals("Y")) {
                    row += ", \"ele_issel4ouput\" :\""     +   "N" + "\""  ; 
                    row += ", \"ele_isupdateable\" :\""    +   "N"  + "\""  ; 
                    row += ", \"ele_isjsonrequired\" :\""  +   "Y"   + "\""  ;
    
                } else {
                    row += ", \"ele_issel4ouput\" :\""     +   "Y"  + "\""  ; 
                    row += ", \"ele_isupdateable\" :\""    +   "Y"   + "\""  ; 
                    row += ", \"ele_isjsonrequired\" :\""  +   "N"  + "\""  ;
    
                }
                 if (child instanceof JsonFieldNode) {
                         row += ", \"ele_dtype\" : "   +    ((JsonFieldNode) child).getType().getdtype()  ;
                         row += ", \"ele_usage\" : "   +   child.getUsage()    ;
                         row += ", \"ele_prec\" : "    +   ((JsonFieldNode) child).getType().getPrec() ; 
                         row += ", \"ele_scale\" : "   +   ((JsonFieldNode) child).getType().getScale() ; 
                         row += ", \"ele_udc_key\" :\""+ ((JsonFieldNode) child).getUdc() + " \""    ;
                         row += ", \"ele_udc_val\" :\""+ ((JsonFieldNode) child).getUdcVal() + " \""    ;
                 } else {   
                 row += ", \"ele_dtype\" : 0";            
                 row += ", \"ele_usage\" : 0";   
                 row += ", \"ele_prec\" : 0";   
                 row += ", \"ele_scale\" : 0";   
                 row += ", \"ele_udc_key\" :\" \""; 
                 row += ", \"ele_udc_val\" :\" \""; 
                 }
                  row += "}\r\n}";
       
        return row;
    }
    public List<String> primeLoadModule(JsonDataNode node, int recId) {
        log.debug("primeLoadModule( {}", node.getName());
        List<String> recList = new ArrayList<String>();
        List<String> recAds = new ArrayList<String>(); String sep = "";
        int childcnt = 0;
        JsonFieldNode ele;
        if (node.getOccLvl() == 1) {
            occBase[1] = 0;
            occSize[1] = 0;
            occLvl = 1;
            }

         if (node.getOccLvl() == 0) {
            occBase[0] = 0;
            occSize[0] = 0;
            occBase[1] = 0;
            occSize[1] = 0;
            occurs = 0;
            occLvl = 0;
            }

        if (node instanceof JsonArrayNode) {
            occurs = node.getMaxContains();
            occLvl = node.getOccLvl();
            int offset = node.getOffset();
            if (occLvl == 1) {
                occBase[occLvl-1] = offset;
                occSize[occLvl-1] = node.getDlen() / occurs; // (length of 1 entry)
                node.getChildren().get(0).setOffset(0);
            } else if (occLvl == 2) {
                occBase[occLvl-1] = offset;
                occSize[occLvl-1] = node.getDlen() / occurs; // (length of 1 entry)
                node.getChildren().get(0).setOffset(0);
              
            } else {
                print("Array dimensionion Exceeded -- Only 1 and 2 dimensional Array are currently supported");

            }
   //         for (JsonDataNode child : ((JsonObjectNode) node).getChildren()) {
   //             recList.addAll(genJsonLoadModule(child));
   //         }

        }
        if (node instanceof JsonObjectNode) {
            childcnt = ((JsonObjectNode) node).getChildren().size();
            if (!(node instanceof JsonArrayNode)) {
       
                recList.addAll(primeLoadModuleEntry(node, recId, childcnt, occurs, occLvl, occBase, occSize, sep));
                
            }
            for (JsonDataNode child : ((JsonObjectNode) node).getChildren()) {
                recList.addAll(primeLoadModule(child, recId));
            }
        }
         
        if (node instanceof JsonFieldNode) {
            recList.addAll(primeLoadModuleEntry(node, recId,childcnt, occurs, occLvl, occBase, occSize, sep));
        }

        return recList;

    }
    public List<String> primeLoadModuleEntry(JsonDataNode child, int recId, int childCnt, int occurs, int occlvl, int[] occBase,
    int[] occSize,
    String sep) {
        List<String> recList = new ArrayList<String>();
        recList.add( "add 1 to w-ecnt.");
    
        recList.add("!* "+child.getJsonFld());  
        recList.add(" move "+  child.getParentOffset()   +                    " to W-PARENT-OFFSET(w-ecnt)."); 
        recList.add(" move '"+  child.getParentType()   +                    "' to W-ELE-PARENT-TYPE(w-ecnt)."); 
        recList.add(" move "+  child.getNextOffset()   +                      " to W-Next-OFFSET(w-ecnt)."); 
        recList.add(" move "+  child.get1stChildOffset()   +                  " to W-1STCHILD-OFFSET (w-ecnt)."); 
         
        recList.add(" move '"+ child.getJsonFld()    +                       "' to W-JSONFLD(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(child.getLvl(), 4)  +        " to W-ELE-LVL(w-ecnt).");
        recList.add(" move '"+ child.getName() +                             "' to W-ELE-ELEMENT(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(child.getSeq(), 6) +         " to W-ELE-SEQ(w-ecnt) .");
        recList.add(" move "+  toZoneNumeric(childCnt, 4)  +              " to W-ELE-CHILDCNT(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(child.getOffset(), 6)  +     " to W-ELE-OFFSET(w-ecnt).");
        recList.add(" move "+  toZoneNumeric( child.getLen(), 5)  +       " to W-ELE-LEN(w-ecnt).");
        recList.add(" move "+  toZoneNumeric( child.getDlen(), 5)  +      " to W-ELE-DLEN(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(occBase[0]+occBase[1]+child.getOffset(),5)  + " to W-ELE-OCC-OFFSET(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(child.getOcc(), 4)  +        " to W-ELE-OCC(w-ecnt).");
        recList.add(" move '"+child.getDependInd()+"' to w-ELE-OCC-DEPEND-IND(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(child.getDependOffset(), 5) +   " to W-ELE-OCC-DEPEND-OFFSET(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(occlvl, 4)  +        " to W-ELE-OCCLVL(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(occSize[0], 5)  +    " to W-ELE-OCCSIZE(w-ecnt,1).");
        recList.add(" move "+  toZoneNumeric(occSize[1], 5)  +    " to W-ELE-OCCSIZE(w-ecnt,2).");
        recList.add(" move '"+  child.getIsGrp()  +                   "' to W-ELE-ISGROUPELE(w-ecnt).");
        if (child.getIsGrp().equals("Y")) {
          recList.add(" move 'N' to W-ELE-ISSEL4OUPUT(w-ecnt).");
          recList.add(" move 'N' to W-ELE-ISUPDATEABLE(w-ecnt).");
          recList.add(" move 'Y' to W-ELE-ISJSONREQUIRED(w-ecnt).");
        } else {
            recList.add(" move 'Y' to W-ELE-ISSEL4OUPUT(w-ecnt).");
            recList.add(" move 'Y' to W-ELE-ISUPDATEABLE(w-ecnt).");
            recList.add(" move 'N' to W-ELE-ISJSONREQUIRED(w-ecnt).");
  
        }
    //    recList.add(" move '"+  (child.isSel4Output() ? "Y" : "N")  + "' to W-ELE-ISSEL4OUPUT(w-ecnt).");
    //    recList.add(" move '"+  (child.isUpdateable() ? "Y" : "N")  + "' to W-ELE-ISUPDATEABLE(w-ecnt).");
    //    recList.add(" move '"+  (child.isJsonRequired() ? "Y" : "N")+ "' to W-ELE-ISJSONREQUIRED(w-ecnt).");
            if (child instanceof JsonFieldNode) {
        recList.add(" move "+ toZoneNumeric(((JsonFieldNode) child).getType().getdtype(), 4)  + " to W-ELE-DTYPE(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(child.getUsage(), 4)  + " to W-ELE-USAGE(w-ecnt).");
        recList.add(" move "+ toZoneNumeric(((JsonFieldNode) child).getType().getPrec(), 4)  + " to W-ELE-PREC(w-ecnt).");
        recList.add(" move "+  toZoneNumeric(((JsonFieldNode) child).getType().getScale(), 4)  + " to W-ELE-SCALE(w-ecnt).");
        recList.add(" move '"+  ((JsonFieldNode) child).getUdc() + "' to W-ELE-UDC-KEY(w-ecnt).");
        recList.add(" move '"+  ((JsonFieldNode) child).getUdcVal()+ "' to W-ELE-UDC-VAL(w-ecnt).");
            } else {
        recList.add(" move 0 to W-ELE-DTYPE(w-ecnt).");
        recList.add(" move 0 to W-ELE-USAGE(w-ecnt).");
        recList.add(" move 0 to W-ELE-PREC(w-ecnt).");
        recList.add(" move 0 to W-ELE-SCALE(w-ecnt).");
        recList.add(" move ' ' to W-ELE-UDC-KEY(w-ecnt).");
        recList.add(" move ' ' to W-ELE-UDC-VAL(w-ecnt).");
               
            }
          
                 recList.add("  ");   
      
        return recList;

    }

    public String toZoneNumeric(int val, int len) {
        String z = "0000000000";
        String znum = z + val;

        znum = znum.substring(znum.length() - len);
        return znum;
    }

    public String toZoneNumeric(int[] val, int len,String sep) {
        String n = "";
        for (int e : val) {
            if (n.length()>0) n+=sep;
            n +=toZoneNumeric(e, len);
        }
        return n;
    }

    public String conv2Hex(int val) {
        String hex = "";
        String hv = "0123456789ABCDEF";
        for (int i = 0; i < 8; i++) {
            int r = val % 16;
            val = val / 16;
            hex = hv.substring(r, r + 1) + hex;
        }
        return hex;
    }
 
    /*
     * Class Jsons
     */
    class Jsons {
        List<String> jlist;
        List<String> jsonSch;
        List<String> jsonRef;
        HashMap<String, List<String>> redefs;

        public Jsons() {
            this.jsonSch = new ArrayList<String>();
            this.jsonRef = new ArrayList<String>();
            this.jlist = jsonSch;
        }

        public List<String> getJlist() {
            return jlist;
        }

        public void setCurrentList(List<String> lst) {
            jlist = lst;
        }

        public List<String> getJsonSch() {
            return jsonSch;
        }

        public List<String> getJsonRef() {
            return jsonRef;
        }

        public void setRedefs(HashMap<String, List<String>> redefs) {
            this.redefs = redefs;
        }

        public HashMap<String, List<String>> getRedefs() {
            return redefs;
        }

    }

    public static void writeFile(List<String> data, File file) {
        log.debug("writeFile {}", file.toString());
        FileWriter fr = null;
        BufferedWriter br = null;
        String newLine = System.getProperty("line.separator");
        newLine = "\r\n";
        try {
            fr = new FileWriter(file);
            br = new BufferedWriter(fr);
            for (String row : data) {
                br.write(row);
                br.write(newLine);
            }
        } catch (IOException e) {
            e.printStackTrace();
        } finally {
            try {
                br.close();
                fr.close();
            } catch (IOException e) {
                e.printStackTrace();
            }
        }
    }


/*
 * idms ISPT interface
 */
    public String postLoadMod(String datasource, List<String> loadmod)
    throws DataSourceNotFoundException, ResourceNotFoundException, BadRequestException, SQLException, IOException {
log.debug("JobStandardService.post({}, \n{}  )", datasource, loadmod);


Socket s = new Socket(url, port);
DataInputStream din = new DataInputStream(s.getInputStream());
DataOutputStream dout = new DataOutputStream(s.getOutputStream());
BufferedReader br = new BufferedReader(new InputStreamReader(din));

/*
 * Alternative syntax 
 */
 String dialog_premap =  "GET /iSpTDLOD/PREMAP HTTP/1.1\r\nHost:www.example.com\r\n\r\n";

 String dialog_insert01 = "POST /ISPTMLOD/ENTER HTTP";
  
 String dialog_exit = "GET /ISPTMLOD/CLEAR HTTP";
 
// build the variable list of changed fields only
String dialog_body_parms01 =  loadmodToString(loadmod);
 //

// doPost();

log.debug("postLoadmodCreate - send:" + dialog_premap);
String req = dialog_premap;
//byte[] b = req.getBytes();
//char[] rb = new char[48176];
//dout.write(b, 0, b.length);
dout.writeUTF(req);
dout.flush();
log.debug("completed: send premap request ");
log.debug("postLoadmod ISPTDLOD  wait for premap response ");
 
int i = -1;
String rslt = din.readUTF();
//i = br.read(rb, 0, rb.length);
log.debug("read after premap {} bytes msg:{}",i,rslt);
if (i == -1 ) {
    throw new ResourceNotFoundException("ISPTDLOD");
}
int j = 0;
int totlen = 25400;
String msg="";
while (i > 0 ) {
j += i;
if (j > totlen) break;
log.debug("read {} of {} bytes",i,j);
 
rslt = din.readUTF();
}
log.debug("post ISPTDLOD Received pm1 {} bytes: {}",j,msg);
 
// insert for ISPTLMOD 
log.debug("postJobStd ISPTLMOD dialog send POST request  send:{}" ,dialog_insert01);
log.debug(" bodyParms len={} content:{}",dialog_body_parms01.length(),dialog_body_parms01);
String dialog_body = "\r\nContent-Length: " + dialog_body_parms01.length() + "\r\n\r\n" + dialog_body_parms01 + " ";
req = dialog_insert01;
req += dialog_body;


//b = req.getBytes();
i = req.length();
log.debug("postJobStd ISPTLMOD request: len={} msg:{} ",i,req);
dout.writeUTF(req); 
//dout.write(b, 0, b.length);
dout.flush();
 rslt = din.readUTF();
 
log.debug("postJobStd ISPTLMOD PostReceived1 {} bytes, msg: {}:",i,rslt);
if (i == -1 ) {
    throw new BadRequestException("Request failed in ISPTLMOD - check IDMS log");
     
}

 
log.debug("postJobStd ISPTLMOD PostReceived2 " + i + " bytes:" + rslt);
int mi = rslt.indexOf("$Message");
int mi2 = rslt.indexOf("-",mi); // find the - in the message
log.debug("mi="+mi+" mi2="+mi2);
String severity ="";
if (mi>0 && mi2 > 0)        
 severity = rslt.substring(mi2+1,mi2+2);
log.debug("mi="+mi+" mi2="+mi2+" severity:"+severity);
if (severity.equalsIgnoreCase("F")) {
    throw new com.broadcom.dbapi.exception.ResourceNotFoundException("fatal message:"+rslt.substring(mi));

}


log.debug("postJobStd ISPTLMOD send after update CLEAR send:" + dialog_exit);
req = dialog_exit;
 
//dout.write(b, 0, b.length);
dout.writeUTF(req);
dout.flush();
rslt = din.readUTF();
log.debug("postJobStd received4 {} bytes:{]}",i, rslt);
dout.close();
s.close();
log.debug("postJobStd exit");
return rslt;
}

public String makeString(char[] a, int len) {
    StringBuffer sb = new StringBuffer();
    for (int i = 0; i < len; i++) {
        sb.append(a[i]);
    }
    return sb.toString();
}

  public String loadmodToString(List<String> loadmod) {
    StringBuffer sb = new StringBuffer();
  for (String str: loadmod) {
    sb.append(str);
  }

    return sb.toString();
  }

  public String restTest(String datasource, List<String> loadmod)
  throws DataSourceNotFoundException, ResourceNotFoundException, BadRequestException, SQLException, IOException {
log.debug("JobStandardService.post({}, \n{}  )", datasource, loadmod);


Socket s = new Socket(url, port);
DataInputStream din = new DataInputStream(s.getInputStream());
DataOutputStream dout = new DataOutputStream(s.getOutputStream());
BufferedReader br = new BufferedReader(new InputStreamReader(din));

/*
* Alternative syntax 
*/
String dialog_premap =  "GET /iSpTDLOD/PREMAP HTTP/1.1\r\nHost:www.example.com\r\n\r\n";

String dialog_insert01 = "POST /ISPTMLOD/ENTER HTTP";
return "";

  }


}

class Reckey {
    String ele;
    String seq;
}
