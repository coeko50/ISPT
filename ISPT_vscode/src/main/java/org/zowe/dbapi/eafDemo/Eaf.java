package main.java.org.zowe.dbapi.eafDemo ; 

import java.io.IOException;

import org.zowe.dbapi.ispt.Ispt;
 

import java.io.IOException;
 
import lombok.extern.slf4j.Slf4j;
 

@Slf4j
public class Eaf extends Ispt {
        public void eafAssert(String map,String val, String expected) throws IOException {
        if (val==null) {
            log.debug("eafassert {} not found - is null", expected);
            return;
        }
        if (val.equals(expected))
            return;
        close();
        throw new com.broadcom.dbapi.exception.ResourceNotFoundException(
                map+" Received "+val.trim()+" Expected " + expected );
    }
}
