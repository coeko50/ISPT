package org.zowe.dbapi.utilities;

import java.util.ArrayList;
import java.util.List;

import org.zowe.dbapi.ispt.record.Record;

import lombok.extern.slf4j.Slf4j;

@Slf4j

class JsonDataNode extends JsonNode {

    JsonDataNode next;

    int lvl;
    int seq;
    int pos;
    int offset;
    int len;
    int dlen;
    int usage;
    String jsonFld;
    JsonRecordNode record;
    int occ;
    int occLvl;
    char dependInd;
    int dependOffset;
    String dependEle;

    String isGrp;
    JsonNode parent;

    boolean isMapfield; // field is on a map
    boolean isUpdateable; // field is unprotected on the map
    boolean isRequired; // field is required by the map
    boolean isSel4Output; // field selected for output (mapout)
    boolean isJsonSchField; // field should be part of the json schema.
    boolean isJsonRequired; // field must be part of the json schema.

    public JsonDataNode() {

        this.lvl = 0;
    }

    public JsonDataNode(JsonRecordNode rec, Record ele, JsonDataNode parent) {
        this.parent = parent;
        this.name = ele.getEle();
        this.jsonFld = ele.getJsonfld();
        this.lvl = ele.getLvl().intValue();
        this.occ = ele.getOcc().intValue();
        if (this.occ > 0) 
           log.debug("occ={}",this.occ);
        this.occLvl = ele.getOccLvl().intValue();
        this.seq = ele.getSeq().intValue();
        this.len = ele.getLen().intValue();
        this.dlen = ele.getDlen().intValue();
        this.pos = ele.getPos();
        this.offset = ele.getPos() - 1;
        this.record = rec;
        this.isMapfield = false;
        this.isUpdateable = false;
        this.isRequired = true;
        this.isJsonSchField = false;
        this.isJsonRequired = false;
        this.isGrp = ele.getIsGrp();
        this.parent = parent;
        this.dependInd = 'N';
        rec.getSchema().getNodes().put(this.name, this);
        if (ele.getOccDependEle().trim().length() > 0) {
            log.debug("looking for |{}|" , ele.getOccDependEle());
             if (!rec.getSchema().getNodes().containsKey(ele.getOccDependEle().trim())) {
                for(String key : rec.getSchema().getNodes().keySet()) {
                        log.debug ("key:|{}|",key);
                }
             }
            JsonDataNode dependEle = rec.getSchema().getNodes().get(ele.getOccDependEle().trim());
            this.dependOffset = dependEle.getOffset();
            if (dependEle.getLen() == 2)
                this.dependInd = '2';
            else
                this.dependInd = '4';
            // } else {
            // throw new Exception("depend ele not found");
            // }
        }
    }

    public JsonNode getParent(JsonNode prevNode, int lvl) {
        JsonNode parent;
        if (lvl == prevNode.getLvl()) {
            if ((prevNode instanceof JsonObjectNode) || (prevNode instanceof JsonRedefNode)
                    || (prevNode instanceof JsonRecordNode)) {
                parent = prevNode.getParent(); // same parent
            } else
                parent = prevNode.getParent().getParent(); // his parent
        } else if (lvl > prevNode.getLvl()) { // new child
            if ((prevNode instanceof JsonObjectNode) || (prevNode instanceof JsonRedefNode)
                    || (prevNode instanceof JsonRecordNode)) {
                parent = prevNode;
            } else
                parent = prevNode.getParent();

        } else { // pop up a level or two
            parent = prevNode.getParentforLevel(lvl);
        }
        return parent;
    }

    public int getParentOffset() {
        JsonNode parent = getParent();
        if (parent instanceof JsonArrayNode)
            parent = parent.getParent();
        if (this.name.toLowerCase().contains("info"))
            log.debug("info field {}", this.name);
        if (parent instanceof JsonRecordNode) {
            int i = parent.getSchema().getRecords().indexOf(parent);
            ;

            return i;
        }
        return ((JsonDataNode) parent).getSeq();

    }

    public char getParentType() {
        JsonNode parent = getParent();
        if (parent instanceof JsonArrayNode)
            parent = parent.getParent();

        if (parent instanceof JsonRecordNode) {
            return 'R';
        }
        return 'G';
    }

   

    public int getNextOffset() {
        JsonNode dataParent = getDataParent();
        JsonNode parent = getParent();
        JsonNode testNode = this;
        if (dataParent != parent) 
            testNode = parent;
        int i = dataParent.getChildren().indexOf(testNode);
        if (++i < dataParent.getChildren().size()) {
            JsonDataNode next = dataParent.getChildren().get(i);
            return next.getSeq();
        }
        return -1; // last child
    }

    public int get1stChildOffset() {
        if (this instanceof JsonObjectNode) {
            if (((JsonObjectNode) this).getChildren().size() > 0) {
                return ((JsonDataNode) ((JsonObjectNode) this).getChildren().get(0)).getSeq();
            }
        }
        return -1;
    }
    public int getOccOffset(int occLvl) {
        if (this.occ > 0) return offset;      // the element that contains the occurs clause still has a correct offset if occlvl=1

        JsonDataNode parent = (JsonDataNode) getParent();
        if (!((parent instanceof JsonArrayNode) && (occLvl != parent.getOccLvl()) ) )
            parent = (JsonDataNode) parent.getParent();

       // we are at a array node at the correct level (or so we hope)
      
            return parent.getOffset();
    }

    public int getOccSize(int occLvl) {
        if (this.occ > 0) return this.getDlen() / this.getOcc(); 
        JsonDataNode parent = (JsonDataNode) getParent();
        if (!((parent instanceof JsonArrayNode) && (occLvl != parent.getOccLvl()) ) )
            parent = (JsonDataNode) parent.getParent();

       // we are at a array node at the correct level (or so we hope)
      
            return parent.getDlen() / parent.getOcc();
        
    }
    public JsonDataNode getRedefinedNode(Integer redef) {
        log.debug("getParentbyName lookfor |{}| at {}.|{}| ", redef, this.seq, this.name);

        if (this.getSeq() == redef.intValue()) {
            if (this.getParent() instanceof JsonRedefNode) // if parent is a redefined node - return that
                return (JsonDataNode) this.getParent();
            return this;
        }
        return ((JsonDataNode) this.getParent()).getRedefinedNode(redef);

    }

    public JsonNode getParentforLevel(int lvl) {
        if (this.getLvl() == lvl) {
            if (this.getParent() instanceof JsonArrayNode)
                return this.getParent().getParent(); // return arraynode's parent
            return this.getParent();
        }

        return this.getParent().getParentforLevel(lvl);

    }

    public JsonNode getParent(int lvl) {
        if (this.getLvl() == lvl) {
            if (this.getParent() instanceof JsonArrayNode)
                return this.getParent().getParent(); // return arraynode's parent
            return this.getParent();
        } else if (this.getLvl() < lvl) {
            if (this instanceof JsonArrayNode)
                return this.getParent();
            return this;
        }
        return this.getParent().getParent(lvl);

    }

    public static org.slf4j.Logger getLog() {
        return log;
    }

    public int getSeq() {
        return seq;
    }

    public void setSeq(int seq) {
        this.seq = seq;
    }

    public int getOffset() {
        return offset;
    }

    public void setOffset(int offset) {
        this.offset = offset;
    }

    public int getLen() {
        return len;
    }

    public void setLen(int len) {
        this.len = len;
    }

    public int getLvl() {
        return lvl;
    }

    public void setLvl(int lvl) {
        this.lvl = lvl;
    }

    public void setParent(JsonNode parent) {
        this.parent = parent;
    }

    public JsonSchema getSchema() {

        return parent.getSchema();
    }

    public JsonNode getParent() {
        return parent;
    }

    public int getPos() {
        return pos;
    }

    public void setPos(int pos) {
        this.pos = pos;
    }

    public int getUsage() {
        return usage;
    }

    public void setUsage(int usage) {
        this.usage = usage;
    }

    public String getJsonFld() {
        return jsonFld;
    }

    public void setJsonFld(String jsonFld) {
        this.jsonFld = jsonFld;
    }

    public JsonRecordNode getRecord() {
        return record;
    }

    public void setRecord(JsonRecordNode record) {
        this.record = record;
    }

    public boolean isMapfield() {
        return isMapfield;
    }

    public void setMapfield(boolean isMapfield) {
        this.isMapfield = isMapfield;
    }

    public boolean isUpdateable() {
        return isUpdateable;
    }

    public void setUpdateable(boolean isUpdateable) {
        this.isUpdateable = isUpdateable;
    }

    public boolean isRequired() {
        return isRequired;
    }

    public void setRequired(boolean isRequired) {
        this.isRequired = isRequired;
    }

    public boolean isJsonSchField() {
        return isJsonSchField;
    }

    public void setJsonSchField(boolean isJsonSchField) {
        this.isJsonSchField = isJsonSchField;
    }

    public boolean isJsonRequired() {
        return isJsonRequired;
    }

    public void setJsonRequired(boolean isJsonRequired) {
        this.isJsonRequired = isJsonRequired;
    }

    public int getMaxContains() {
        return 0;
    };

    public int getOccLvl() {
        return occLvl;
    };

    public int getDlen() {
        return dlen;
    }

    public void setDlen(int dlen) {
        this.dlen = dlen;
    }

    public String getIsGrp() {
        return isGrp;
    }

    public void setIsGrp(String isGrp) {
        this.isGrp = isGrp;
    }

    public int getOcc() {
        return occ;
    }

    public void setOcc(int occ) {
        this.occ = occ;
    }

    public void setOccLvl(int occLvl) {
        this.occLvl = occLvl;
    }

    public boolean isSel4Output() {
        return isSel4Output;
    }

    public void setSel4Output(boolean isSel4Output) {
        this.isSel4Output = isSel4Output;
    }

    public char getDependInd() {
        return dependInd;
    }

    public void setDependInd(char dependInd) {
        this.dependInd = dependInd;
    }

    public int getDependOffset() {
        return dependOffset;
    }

    public void setDependOffset(int dependOffset) {
        this.dependOffset = dependOffset;
    }

    public String getDependEle() {
        return dependEle;
    }

    public void setDependEle(String dependEle) {
        this.dependEle = dependEle;
    }

}
