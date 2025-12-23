package org.zowe.dbapi.utilities;

import java.util.ArrayList;
import java.util.List;

import org.zowe.dbapi.ispt.record.Record;

import lombok.extern.slf4j.Slf4j;

@Slf4j
public class JsonFieldNode extends JsonDataNode {

    Jtype type;
    String typeName;
    String element;
    String desc;
    String picture;
    String prefix;
 //   int seq;
String udc;
String udcVal;

    public JsonFieldNode(JsonRecordNode rec, Record ele, Jtype type, JsonDataNode parent) {
        super(rec, ele, parent);
        this.desc = ele.getDesc();
        this.element = ele.getEle();
        this.type = type;
        this.prefix = ele.getPrefix();
this.udc=" ";
this.udcVal = " ";
    }

    public Jtype getType() {
        return type;
    }

    public void setType(Jtype type) {
        this.type = type;
    }

    public String getTypeName() {
        return typeName;
    }

    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }

    public String getElement() {
        return element;
    }

    public void setElement(String element) {
        this.element = element;
    }

    public String getDesc() {
        return desc;
    }

    public void setDesc(String desc) {
        this.desc = desc;
    }

    public String getPicture() {
        return picture;
    }

    public void setPicture(String picture) {
        this.picture = picture;
    }

    public String getPrefix() {
        return prefix;
    }

    public void setPrefix(String prefix) {
        this.prefix = prefix;
    }

    public String getUdc() {
        return udc;
    }

    public void setUdc(String udc) {
        this.udc = udc;
    }

    public String getUdcVal() {
        return udcVal;
    }

    public void setUdcVal(String udcVal) {
        this.udcVal = udcVal;
    }

     
}
