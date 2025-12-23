package org.zowe.dbapi.utilities;

import java.util.ArrayList;
import java.util.List;

public class JsonRecordNode extends JsonNode {
  List<JsonDataNode> children;
  JsonSchema schema;
   int recver;
  // JsonNode root;
  public JsonRecordNode(String name, int recver) {
    super(name);
    this.recver=recver;
    children = new ArrayList<JsonDataNode>();
  }

  public List<JsonDataNode> getChildren() {
    return children;
  }

  public void setChildren(List<JsonDataNode> children) {
    this.children = children;
  }
public int getLvl() {
  return 1;
}

public int countElements() {
  int totele = 0;
  for (JsonDataNode node : children) {
    if ( (node instanceof JsonFieldNode)  ) 
     totele ++;
    if (node instanceof JsonObjectNode)
         totele += countElements((JsonObjectNode)node);
  }
  return totele;
}
public int countElements(JsonObjectNode pnode) {
   
  int totele = 0;
  for (JsonDataNode node : pnode.getChildren()) {
    if ( (node instanceof JsonFieldNode) ||  (node instanceof JsonObjectNode)) 
      totele ++;

    if (node instanceof JsonObjectNode)
     totele += countElements((JsonObjectNode)node);

  }
  return totele;
}
 
  public JsonSchema getSchema() {
    return schema;
  }

  public void setSchema(JsonSchema schema) {
    this.schema = schema;
  }
 

  public JsonNode getParentforLevel(int lvl) {
    return this;
  }
  public JsonNode getParent(int lvl) {
    return this;
  }
  public JsonRecordNode getParent(JsonNode prevNode, int lvl) {
    return this;
  }

  public JsonRecordNode getParent() {
    return this;
  }

  public int getRecver() {
    return recver;
  }

  public void setRecver(int recver) {
    this.recver = recver;
  }
}
