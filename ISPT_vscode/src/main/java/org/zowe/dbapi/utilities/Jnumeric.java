package org.zowe.dbapi.utilities;

import org.zowe.dbapi.ispt.record.Record;

public class Jnumeric extends Jtype {
    int maximum;
    int precision;
    int scale;
    String pic;

    public Jnumeric() {
        this.maximum = 0;
        this.precision = 0;
        this.scale = 0;
        this.pic = "";
    }
    public Jnumeric(Record ele) {
        this.maximum = ele.getPrec() - ele.getScale();
        this.precision = ele.getPrec(); 
        this.scale = ele.getScale();
        this.pic = "";
    }
    public Jnumeric(int maximum, int precision, int scale, String pic) {
        this.maximum = maximum;
        this.precision = precision;
        this.scale = scale;
        this.pic = pic;
    }
    public String toString()   {
        String type   = "\"numberic\"";
        maximum =   precision - scale;
        type += ", \"maximum\" :"+"999999999".substring(0,maximum);
        return type;        
    }

}