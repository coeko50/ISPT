package org.zowe.dbapi.utilities;

import org.zowe.dbapi.ispt.record.Record;

public class Jtype {

  /*
   * Cass Jtype
   */

  String name;
  private int dlen; // internal length
  private int dtype; // idms data type
  private int prec;
  private int scale;
  String udc;
  String udcVal;

  public String getName() {
    return name;
  }

  public void setName(String name) {
    this.name = name;
  }
  public  Jtype( ) {
    
 
 }
  public  Jtype(Record ele) {
    this.dlen = ele.getDlen();
   this.dtype = ele.getDtype();
   this.prec = ele.getPrec();
   this.scale = ele.getScale();
 
 }

 

  public int getDlen() {
    return dlen;
  }

  public void setDlen(int dlen) {
    this.dlen = dlen;
  }

  public int getDtype() {
    return dtype;
  }

  public void setDtype(int dtype) {
    this.dtype = dtype;
  }

  public void setPrec(int prec) {
    this.prec = prec;
  }

  public void setScale(int scale) {
    this.scale = scale;
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

  public int getPrec() {
    return prec;
  }

  public int getScale() {
    return scale;
  }

  public int getIntLen() {
    return dlen;
  }

  public int getdtype() {
    return dtype;
  }  
   
  
  public void setJtype(Record ele) {
     this.dlen = ele.getDlen();
    this.dtype = ele.getDtype();
    this.prec = ele.getPrec();
    this.scale = ele.getScale();
  
  }
   
}
