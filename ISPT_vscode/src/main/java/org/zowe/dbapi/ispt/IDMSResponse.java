package org.zowe.dbapi.ispt;

public class IdmsResponse {
    String message;
    String messageCode;
   
    String messageSeverity;
    String map;  // idms mapname

    String responseCode;
    String json;
    public IdmsResponse() {
        message ="";
        map="";
        responseCode="400";
        messageCode="";
        messageSeverity="";
        json="";
    }

     public String getMessageCode() {
        return messageCode;
    }
    public String getMessageSeverity() {
        return messageSeverity;
    }
  
  

    public String getMessage() {
        return message;
    }

    public String getMap() {
        return map;
    }

    public String getResponseCode() {
        return responseCode;
    }

    public String getJson() {
        return json;
    }

    public IdmsResponse build(String s) {
         if (s.length() < 8) {
            this.responseCode = "200";
            return this;
         }
         
        if (s.substring(0, 8).equals("HTTP/1.1")) {
            this.responseCode = s.substring(9, 12);
            int i = s.indexOf("{");
            if (i>0) {
                this.json = s.substring(i);
            }

        } else {
            this.json = s;
        }

        int i = s.indexOf("$Message");
        if (i > 0) {
            this.message = s.substring(i+11, s.indexOf("\"", i+11));
            this.messageCode = this.message.substring(0,4);
            this.messageSeverity =  String.valueOf(this.message.charAt(5));
        }

        i = s.indexOf("MapName");
        if (i > 0) {
            this.map = s.substring(i + 9, s.indexOf(" ", i + 10));
        }

        return this;
    }
}
