package org.zowe.dbapi.utilities;

import java.util.ArrayList;

import org.zowe.dbapi.ispt.record.Record;

public class JSimpleType extends Jtype {
    String typeName;
    String picture;
    // int seq;
    String udc;
    String udcVal;

   
    public JSimpleType(Record ele) {
        super(ele);
        this.picture = ele.getPicture();
        this.typeName = "TBD";
        this.udc = "";
        this.udcVal = "";
    }


    public String getTypeName() {
        return typeName;
    }


    public void setTypeName(String typeName) {
        this.typeName = typeName;
    }


    public String getPicture() {
        return picture;
    }


    public void setPicture(String picture) {
        this.picture = picture;
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
