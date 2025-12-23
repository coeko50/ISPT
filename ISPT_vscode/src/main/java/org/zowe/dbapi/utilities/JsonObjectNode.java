package org.zowe.dbapi.utilities;

import java.util.ArrayList;
import java.util.List;

import org.zowe.dbapi.ispt.record.Record;

public class JsonObjectNode extends JsonDataNode {
    List<JsonDataNode> children;

    public void setChildren(List<JsonDataNode> children) {
        this.children = children;
    }

    public List<JsonDataNode> getChildren() {
        return  children;
    }

    public JsonObjectNode(JsonRecordNode rec,Record ele, JsonDataNode parent) {
       super(rec, ele, parent);
       children = new ArrayList<JsonDataNode>();
         
    }

    public JsonObjectNode() {
        children = new ArrayList<JsonDataNode>();
    }

 
}
