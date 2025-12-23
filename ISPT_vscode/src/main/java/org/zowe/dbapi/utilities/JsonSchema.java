package org.zowe.dbapi.utilities;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
  
public class JsonSchema extends JsonNode{
  //  String name;
 
     
    List<JsonRecordNode> records;
     HashMap<String,JsonDataNode> nodes;

    public JsonSchema(String name , List<JsonRecordNode> records) {
        super(name);
        this.records=records; 
    }

    
    public JsonSchema(String name) {
        super(name);
        records = new ArrayList<JsonRecordNode>();
     nodes = new HashMap<String,JsonDataNode>();
    }

    public void addRecord(JsonRecordNode record) {
        this.records.add(record);
    }

     
    public void setRecords(List<JsonRecordNode> recordNodes) {
        this.records = records;
    }

    public String getName() {
        return name;
    }
    List<JsonRecordNode> getRecords() {
        return  records;
    }
    public int countElements() {
        int totele = 0;
        for (JsonRecordNode rec : records) {
            totele += rec.countElements( );
        }
        return totele;
      }

    public HashMap<String, JsonDataNode> getNodes() {
        return nodes;
    }


    public void setNodes(HashMap<String, JsonDataNode> nodes) {
        this.nodes = nodes;
    }

   


  

}
