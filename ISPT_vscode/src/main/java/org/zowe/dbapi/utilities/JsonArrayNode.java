package org.zowe.dbapi.utilities;

import java.util.ArrayList;

import org.zowe.dbapi.ispt.record.Record;

public class JsonArrayNode extends JsonObjectNode {
    int maxContains;
      
    public int getMaxContains() {
        return maxContains;
    }

    public void setMaxContains(int maxContains) {
        this.maxContains = maxContains;
    }

    public JsonArrayNode(JsonRecordNode rec, Record ele, JsonDataNode parent) {
        super(rec, ele, parent);
 
        this.maxContains = ele.getOcc();
      
        this.children = new ArrayList<JsonDataNode>();
    }

}