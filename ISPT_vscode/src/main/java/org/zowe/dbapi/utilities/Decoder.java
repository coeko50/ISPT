package org.zowe.dbapi.utilities;

 
import java.util.HashMap;
import java.util.List;
import java.util.Set;

import lombok.extern.slf4j.Slf4j;
import java.io.*;
import java.net.*;
import org.apache.coyote.BadRequestException;

import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;
import com.github.andrewoma.dexx.collection.ArrayList;
// for debug
@Slf4j
/* 
 * the message are read in x,y coordinates 
 * to print we need print y axis in desending order  
 * the x axies are printed in ascending sequence 
 */
public class Decoder {
    int maxY;    // max y axis value
    public static void main(String args[]) {
        Decoder dcdr = new Decoder();
        log.debug("hello");
     //   int port = new Integer(args[1]).intValue();
        try {
        String msg = dcdr.readMessage("https://docs.google.com/document/d/e/2PACX-1vQGUck9HIFCyezsrBSnmENk5ieJuYwpt7YHYEzeNJkIb9OSDdx-ov2nRNReKQyey-cwJOoEKUhLmN9z/pub");
     HashMap<Integer, StringBuffer> matrix = dcdr.decodeMsg(msg);
        dcdr.printMsg(matrix);      } catch (Exception e) {
            e.printStackTrace();
        }
     
    }
/* 
 * decode the message --
 * pattern is: 
 *  x space char space y nl 
 * 
 */
private HashMap<Integer, StringBuffer> decodeMsg(String msg) {
     HashMap<Integer, StringBuffer> matrix = new HashMap<Integer, StringBuffer>();
     
     String[] lines =  msg.split("\n");
     
     for( String line : lines) {
        String[] entry = line.split(" ");
        int x = Integer.valueOf(entry[0]);
        Integer y = Integer.valueOf(entry[2]);
        if (!matrix.containsKey(y)) {
            maxY = y; 
            matrix.put(y,new StringBuffer(0));
        } 
 
 
        StringBuffer row = matrix.get(y);
       int missingChars = x - row.length();       
       for (int i = 0; i < missingChars; i++){
            row.append(" ");
        }
        row.append(entry[1]);
     }
 return matrix;
}

/*
 * print the string buffers in descending order 
 */
private void printMsg(HashMap<Integer, StringBuffer> matrix ) {
    
    for (int i = maxY ; i > 0; i--) {
        if (matrix.containsKey(new Integer(i))) {
            System.out.println(matrix.get(new Integer(i))); 
        } else {
            System.out.println("");
        }
    }
}
/* read the message as a string from the supplied url */
   public String readMessage(String url  ) 
    throws DataSourceNotFoundException, ResourceNotFoundException, BadRequestException,   IOException {
log.debug(" read from {}:{}\n  )", url );
 
try (Socket s = new Socket(url , 80)) {
    DataInputStream din = new DataInputStream(s.getInputStream());
     String req = din.readUTF();
     return req;
}
}
 
}
