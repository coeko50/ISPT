package org.zowe.dbapi.ispt;
import java.io.BufferedReader;
import java.io.DataInputStream;
import java.io.DataOutputStream;
import java.io.IOException;
import java.io.InputStreamReader;
import java.lang.reflect.InvocationTargetException;
import java.lang.reflect.Method;
import java.net.Socket;
import java.net.UnknownHostException;
import java.sql.SQLException;
import java.util.Map;

import org.checkerframework.checker.units.qual.s;
import org.springframework.beans.factory.annotation.Autowired;

//import com.broadcom.dbapi.common.BasicDataSourceRouter;
 import com.broadcom.dbapi.common.DataSourceRouter;
//import com.broadcom.dbapi.config.DataSourceConfig;
//import com.broadcom.dbapi.datasource.Datasource;
//import com.broadcom.dbapi.datasource.DatasourceController;
import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;
import lombok.extern.slf4j.Slf4j;
import javax.sql.CommonDataSource;
 
@Slf4j
public class Ispt {
    int port ;
    String url;
    String dbname;
    Socket s;
    DataInputStream din;
    DataOutputStream dout;
    BufferedReader br; 
    String className;
    String method;
    
   
    public  Ispt () {
       this.className="unknown";

    }
       public  Ispt (String classname) {
          this.className = classname;
          this.method="";

    }
    public void connect( String datasource, DataSourceRouter dataSourceRouter) throws UnknownHostException, IOException , DataSourceNotFoundException, IllegalAccessException, NoSuchMethodException, InvocationTargetException{
   
        CommonDataSource cds = dataSourceRouter.getDataSource(datasource);
        url = (String)getPropertyByName(dataSourceRouter.getDataSourceClass(), cds, "serverName");
        port = ((Integer)getPropertyByName(dataSourceRouter.getDataSourceClass(), cds, "portNumber")).intValue();
        dbname = (String)getPropertyByName(dataSourceRouter.getDataSourceClass(), cds, "databaseName");

        log.debug("will connect to {}, server {} port {}", dbname, url, port);
 
        s = new Socket(url, port);
        din = new DataInputStream(s.getInputStream());
        dout = new DataOutputStream(s.getOutputStream());
        br = new BufferedReader(new InputStreamReader(din));
    }

     public IdmsResponse sendReceive(String req, String debugMarker)
            throws IOException {
        IdmsResponse response = new IdmsResponse();

        char[] rb = new char[548176];

        dout.writeUTF(req);
        dout.flush();
        log.debug("{}.{}-{} - request send, wait for response {} ",className, method,debugMarker ,req);

        int i = -1;
        i = br.read(rb, 0, rb.length);
        response.build(makeString(rb, i));
        
        log.debug("{}.{}-{} {} received header {} bytes - {}",className, method,debugMarker, response.getResponseCode(), i, makeString(rb, i));
      
        if (i < 0 || !response.getResponseCode().equals("200") || response.getMessageSeverity().equals("F"))
            return response;

         
        if (response.getJson().length() == 0) {
        i = br.read(rb, 0, rb.length);
        response.build(makeString(rb, i));
        log.debug("{}.{}-{} {} received body {} bytes - {}",className, method,debugMarker, response.getResponseCode(),i, makeString(rb, i));
        }
        return response;

    }

  
    private Object getPropertyByName(Class<?> dataSourceClass, CommonDataSource dataSource, String propertyName) {
        Object propertyValue = null;

        try {
            propertyName = propertyName.substring(0, 1).toUpperCase() + propertyName.substring(1);
            Method getMethod = dataSourceClass.getMethod("get" + propertyName, (Class[]) null);
             propertyValue = getMethod.invoke(dataSource, (Object[]) null);
        } catch (NoSuchMethodException e) {
  log.error("Error property {} has not get method: {}", propertyName,e.toString());
              } catch (Exception e) {
            log.error("Error getting property {}: {}", propertyName,e.toString());
        }
        // log.debug("PropertyName: {} PropertyValue: {}", propertyName, propertyValue);
        return propertyValue;
    }


    public String toDialogBody(String parms) {
    return    "\r\nContent-Length: " +  parms.length() + "\r\n\r\n" + parms + " ";
 
}
    public void assertResponse(String map,String val, String expected) throws IOException {
        if (val==null) {
            log.debug("isptAssert {} not found - is null", expected);
            return;
        }
        if (val.equals(expected))
            return;
        close();
        throw new org.zowe.dbapi.ispt.exceptions.UnexpectedIDMSResponseException(
                map+" Received "+val.trim()+" Expected " + expected );
    }
    public void close() throws  IOException {
        dout.close();
        s.close();
    }
    public String makeString(char[] a, int len) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < len; i++) {
            sb.append(a[i]);
        }
        return sb.toString();
    }
    public void setMethod(String name) {
 method = name;

    }
}
