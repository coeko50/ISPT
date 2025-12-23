package org.zowe.dbapi.utilities;

import java.util.ArrayList;
import java.util.List;

public class JsonRedefNode extends JsonObjectNode {
    

    public JsonRedefNode() {
 
    }
      public JsonRedefNode transfer(JsonDataNode node) {
        JsonRedefNode copy = this;
        copy.setJsonFld(node.jsonFld);
        copy.setLvl(node.lvl);
        copy.setSeq(node.seq);
        copy.setPos(node.pos);
        copy.setName(node.getName());
        copy.setChildren(new ArrayList<JsonDataNode>());
        copy.getChildren().add(node);
        copy.setRecord(node.getRecord());
        /* remove current item from parent as child */
        JsonNode parent = node.getParent();
        copy.setParent(parent);
        node.setParent(copy);
        List<JsonDataNode> childLst = parent.getChildren();
        childLst.remove(childLst.indexOf(node));
        childLst.add(copy);
        return copy;

    }
}