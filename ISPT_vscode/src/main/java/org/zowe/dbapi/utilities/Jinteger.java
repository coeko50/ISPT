package org.zowe.dbapi.utilities;

import org.zowe.dbapi.ispt.record.Record;

public class Jinteger extends Jtype {
    int maximum;

    public Jinteger(int maximum) {
        this.maximum = maximum;
    }
    public Jinteger(Record ele,int maximum) {
        super(ele);
        this.maximum = maximum;
    }
   
    public String toString() {
        String type ="integer";
        
            type += ", \"maximum\" :"+maximum;
            return type;        
        }
       
}
