package org.zowe.dbapi.utilities;

public class Jstring extends Jtype  {
    int maxLength;

    public Jstring(int maxLength) {
        this.maxLength = maxLength;
    }
    public String toString() {
        String type   = "\"string\"";
         type += ", \"maxLength\" :"+ maxLength;
        return type;        
    }
    public int getMaxLength() {
        return maxLength;
    }

}
