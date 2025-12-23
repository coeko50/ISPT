package org.zowe.dbapi.utilities;

import java.util.List;

public class JsonNode {
    String name;


    public String getName() {
        return name;
    }

public JsonNode(String name) {
    this.name = name;

}
public JsonNode( ) {
    this.name = null;
}
public JsonNode getDataParent() {
    JsonNode parent = getParent();
    if (parent instanceof JsonArrayNode)
        parent = parent.getDataParent();
    return parent;
}
    public void setName(String name) {
        this.name = name;
    }
    public JsonNode getParentforLevel(int lvl) {
        return null;
    }
    public JsonNode getParentbyName(String name) {
        return null;
    }
    public JsonSchema getSchema() {
        return null;
    }
    public int getLvl() {
        return 0;
    }
    public JsonNode getParent() {
        return null;
    }
    public JsonNode getParent(JsonNode prevNode, int lvl ) {
        return null;
    }
     public JsonNode getParent(int lvl ) {
        return null;
    }
    public List<JsonDataNode> getChildren() {
        return null;
    }
 }
