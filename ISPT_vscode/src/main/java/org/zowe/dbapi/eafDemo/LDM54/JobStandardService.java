/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.eafDemo.LDM54;

import java.math.*; // for data types
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.apache.coyote.BadRequestException;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zowe.dbapi.ispt.IdmsResponse;
import org.zowe.dbapi.ispt.Ispt;

import com.broadcom.dbapi.common.DataSourceRouter;
import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;
import org.zowe.dbapi.ispt.Ispt;
/**
 * Implements SQL access for the SQL EMPLOYEE table
 *
 * ./gradlew bootRun
 * 
 * 
 * @author Zowe Database API Generator
 * @since 1.0
 */
import java.io.*;
import java.lang.reflect.InvocationTargetException;
import java.net.*;

@Service("ADS JobStandardService")
@Slf4j
public class JobStandardService {

    private Ispt ispt;

    public JobStandardService() {
        ispt = new Ispt(this.getClass().getName());
    }

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * get the mapout data from empinqd for a jobStdNr
     * 
     * @param jobStdNr EMP_ID value
     * @return JSON object representing the map data
     */
    public String getJobStandardInfo(String datasource, String jobStdNr)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException,
            NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        log.debug("JobStandardService.getJobStdInfo({}, {})", datasource, jobStdNr);

        IdmsResponse response = new IdmsResponse();

        String dialog_premap = "GET /LDM54D01/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_retrieve = "GET /LDM54D01/ENTER?jobStdNr=" + jobStdNr.toString() + " HTTP";
        String dialog_exit = "GET /LDM54D01/PF12 HTTP";

        log.debug("getLrTEST JobStdInfo Dialog Premap - send:" + dialog_premap);
        ispt.setMethod(new Object() {
        }.getClass().getEnclosingMethod().getName());
        ispt.connect(datasource, dataSourceRouter);
        return response.getJson();
    }

    public String get(String datasource, String jobStdNr)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException {
        log.debug("JobStandardService.get({}, {})", datasource, jobStdNr);
        IdmsResponse response = new IdmsResponse();

        String dialog_premap = "GET /LDM54D01/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_retrieve = "GET /LDM54D01/enter?jobStdNr=" + jobStdNr.toString() + " HTTP";
        String dialog_exit = "GET /LDM54D01/PF12 HTTP";

        log.debug("getJobStdInfo Dialog Premap - send:" + dialog_premap);
        try {
            response = ispt.sendReceive(dialog_premap, "Premap");
            log.debug("map {} $message:{} json:{}", response.getMap(), response.getMessage().trim(),
                    response.getJson());
            // eafAssert(response.getMessageSeverity(),"I");
            eafAssert(response.getMap(), response.getMessageCode(), "0044");

            response = ispt.sendReceive(dialog_retrieve, "retrieve");
            response = ispt.sendReceive(dialog_exit, "exit");

            log.debug("post jobStandardService  exit");
        } catch (IOException e) {
            ispt.close();
            throw new com.broadcom.dbapi.exception.ResourceNotFoundException("fatal message:" + response.getMessage());
        }
        ispt.close();
        return response.getJson();

    }

    public String post(String datasource, LDM54Interface ldm54Map)
            throws DataSourceNotFoundException, ResourceNotFoundException, BadRequestException, SQLException,
            IOException, NoSuchMethodException, IllegalAccessException, InvocationTargetException {
        // log.debug("\"JobStandardService.postnew({}, - {} new Values {} {} {} )",
        // datasource,
        // ldm54Map.ldm54wm1.getLdm54wm1JobStdNr(),ldm54Map.ldm54wm1.getLdm54wm1JobStdDscrptn(),ldm54Map.ldm54wm1.getLdm54wm1TctoNr(),ldm54Map.ldm54wm1.getLdm54wm1OrgnztnCode());
        log.debug("\"JobStandardService.postnew({}, - {} new Values {} {} {} )", datasource, ldm54Map);

        IdmsResponse response = new IdmsResponse();

        /*
         * methods
         */
        String dialog_premap = "GET /LDM54D01/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_insert01 = "POST /LDM54D01/ENTER HTTP";
        String dialog_insert02 = "POST /LDM54D02/ENTER HTTP";
        String dialog_insert03 = "POST /LDM54D03/ENTER HTTP";
        String dialog_exit = "GET /LDM54D01/PF12 HTTP";

        //
        ldm54Map = new LDM54Interface();
        ldm54Map.cscrnw01 = new Cscrnw01();
        ldm54Map.ldm54wm1 = new Ldm54wm1();
        ldm54Map.ldm54wm1.setLdm54wm1JobStdNr("12345");
        ldm54Map.ldm54wm1.setLdm54wm1JobStdDscrptn("testDesc");
        ldm54Map.ldm54wm1.setLdm54wm1TctoNr("000000000000000000000000");
        List orgcodes = new ArrayList();
        orgcodes.add("001");
        ldm54Map.ldm54wm1.setLdm54wm1OrgnztnCode(orgcodes);

        // build the variable list of changed fields only
        // String dialog_body_parms01 = loadmodToString(ldm54Map);
        String dialog_body_parms01 = " {\"job_std_nr\" : \"" + ldm54Map.ldm54wm1.getLdm54wm1JobStdNr()
                + "\",\"job_std_dscrptn\": \"" + ldm54Map.ldm54wm1.getLdm54wm1JobStdDscrptn() + "\"}";
        String dialog_body_parms02 = "{\"tcto_nr\":\"" + ldm54Map.ldm54wm1.getLdm54wm1TctoNr() + "\"}";
        String dialog_body_parms03 = "{\"orgnztn_code\"["
                + toJsonString(ldm54Map.ldm54wm1.getLdm54wm1OrgnztnCode()) + "]}";

        ispt.setMethod(new Object() {
        }.getClass().getEnclosingMethod().getName());
        ispt.connect(datasource, dataSourceRouter);

        dialog_insert01 += toDialogBody(dialog_body_parms01);
        dialog_insert02 += toDialogBody(dialog_body_parms02);
        dialog_insert03 += toDialogBody(dialog_body_parms03);

        char[] rb = new char[48176];
        log.debug("post jobStandardService - commencing.");
        // IdmsResponse response = new IdmsResponse();

        try {
            response = ispt.sendReceive(dialog_premap, "Premap");
            log.debug("map {} $message:{} json:{}", response.getMap(), response.getMessage().trim(),
                    response.getJson());
            // eafAssert(response.getMessageSeverity(),"I");
            eafAssert(response.getMap(), response.getMessageCode(), "0044");

            response = ispt.sendReceive(dialog_insert01, "LDM54D01");
            log.debug("1map {} $message:{} json:{}", response.getMap(), response.getMessage().trim(),
                    response.getJson());
            eafAssert(response.getMap(), response.getMessageCode(), "0044");

            response = ispt.sendReceive(dialog_insert02, "LDM54D02");
            log.debug("2map {} $message:{} json:{}", response.getMap(), response.getMessage().trim(),
                    response.getJson());
            eafAssert(response.getMap(), response.getMessageCode(), "0052");

            IdmsResponse response3 = ispt.sendReceive(dialog_insert03, "LDM54D03");
            log.debug("3map {} $message:{} json:{}", response3.getMap(), response.getMessage().trim(),
                    response3.getJson());
            eafAssert(response3.getMap(), response3.getMessageCode(), "0013");

            IdmsResponse response2 = ispt.sendReceive(dialog_exit, "LDM54D01-Exit");

            log.debug("post jobStandardService  exit");
        } catch (IOException e) {
            ispt.close();
            throw new com.broadcom.dbapi.exception.ResourceNotFoundException("fatal message:" + response.getMessage());
        }
        ispt.close();
        return response.getJson();
    }

    public String toJsonString(List<String> str) {
        String jstr = "";
        String cont = "";
        for (String s : str) {
            jstr += cont + "\"" + s.trim() + "\"";
            cont = ", ";
        }
        return jstr;
    }

    public static void print(String str) {
        System.out.println(str);
    }

    public String toDialogBody(String parms) {
        return "\r\nContent-Length: " + parms.length() + "\r\n\r\n" + parms + " ";

    }

    public void eafAssert(String map, String val, String expected) throws IOException {
        if (val == null) {
            log.debug("eafassert {} not found - is null", expected);
            return;
        }
        if (val.equals(expected))
            return;

        throw new com.broadcom.dbapi.exception.ResourceNotFoundException(
                map + " Received " + val.trim() + " Expected " + expected);
    }
    /**
     * SELECT a result set from the EMPLOYEE table
     * 
     * @return Employee array containing the contents of the result set
     */
    /*
     * public List<Employee> query(String datasource)
     * throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
     * log.debug("JobStandardService.query({})", datasource);
     * String SQL_SELECT = "select jobStdNr from empschm.employee";
     * List<Employee> array = new ArrayList<Employee>();
     * try (Connection conn = dataSourceRouter.getConnection(datasource);
     * PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
     * try (ResultSet rs = stmt.executeQuery();) {
     * while (rs.next()) {
     * Employee employee = new Employee();
     * employee
     * .setjobStdNr((BigDecimal) rs.getObject("EMP_ID"))
     * .setManagerId((BigDecimal) rs.getObject("MANAGER_ID"))
     * .setEmpFname((String) rs.getObject("EMP_FNAME"))
     * .setEmpLname((String) rs.getObject("EMP_LNAME"))
     * .setDeptId((BigDecimal) rs.getObject("DEPT_ID"))
     * .setStreet((String) rs.getObject("STREET"))
     * .setCity((String) rs.getObject("CITY"))
     * .setState((String) rs.getObject("STATE"))
     * .setZipCode((String) rs.getObject("ZIP_CODE"))
     * .setPhone((String) rs.getObject("PHONE"))
     * .setStatus((String) rs.getObject("STATUS"))
     * .setSsNumber((BigDecimal) rs.getObject("SS_NUMBER"))
     * .setStartDate((Date) rs.getObject("START_DATE"))
     * .setTerminationDate((Date) rs.getObject("TERMINATION_DATE"))
     * .setBirthDate((Date) rs.getObject("BIRTH_DATE"));
     * array.add(employee);
     * }
     * }
     * }
     * return array;
     * }
     */
}
