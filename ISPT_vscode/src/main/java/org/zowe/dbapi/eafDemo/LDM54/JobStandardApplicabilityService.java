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

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.broadcom.dbapi.common.DataSourceRouter;
import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;

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
import java.net.*;

@Service("ADS JobStandardApplicabilityService")
@Slf4j
public class JobStandardApplicabilityService {
    public static void main(String args[]) {
        JobStandardApplicabilityService service = new JobStandardApplicabilityService();
        String jobStdNr = "000012"; //new String();
        // Employee e = new Employee();
        try {
            String ee = service.get("ddd", jobStdNr);
            print(ee);

        } catch (Exception ee) {

            ee.printStackTrace();
        }
    }


    @Autowired
    private DataSourceRouter dataSourceRouter;

 
    public String get(String datasource, String jobStdNr)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException {
        log.debug("jobStdApplervice.get({}, {})", datasource, jobStdNr);

        Socket s = new Socket("192.168.24.227", 40117);
        DataInputStream din = new DataInputStream(s.getInputStream());
        DataOutputStream dout = new DataOutputStream(s.getOutputStream());
        BufferedReader br = new BufferedReader(new InputStreamReader(din));

        String dialog_premap = "GET /empmodd/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_retrieve = "GET /empmodd/enter?empid=" + jobStdNr + " HTTP";
        String dialog_exit = "GET /emplj/empmodd/clear HTTP";

        log.debug("getEmp Dialog Premap - send:" + dialog_premap);

        String req = dialog_premap;
        byte[] b = req.getBytes();
        char[] rb = new char[48176];
        dout.write(b, 0, b.length);
        dout.flush();
        log.debug("getEmp completed: send premap request ");
        log.debug("wait for response ");

        int i = -1;
        i = br.read(rb, 0, rb.length);
        log.debug("getEmp Received pm1 " + i + " bytes:" + makeString(rb, i));

        i = br.read(rb, 0, rb.length);
        log.debug("getEmp Received pm2 " + i + " bytes:" + makeString(rb, i));
        /*
         * Dialog is now active and displayed the map.
         * Trigger the response process to retrieve the data
         * and do a mapout again
         */
        log.debug("getEmp dialog send Enter response  send:" + dialog_retrieve);
        req = dialog_retrieve;
        b = req.getBytes();
        dout.write(b, 0, b.length);
        dout.flush();
        i = br.read(rb, 0, rb.length);
        String rslt = makeString(rb, i);
        log.debug("getEmp Received1 should be 200ok: " + i + " bytes:" + rslt);
        i = br.read(rb, 0, rb.length);
        rslt = makeString(rb, i);
        log.debug("getEmp Received2 - should be resultset: " + i + " bytes:" + rslt);
        /*
         * rslt contains the json from the dialog
         * exit the dialog but sending the appropiate aid byte
         *
         */
        log.debug("getEmp Dialog exit- send:" + dialog_exit);
        req = dialog_exit;
        b = req.getBytes();
        dout.write(b, 0, b.length);
        dout.flush();
    //    i = br.read(rb, 0, rb.length);
    //    log.debug("received5 " + i + " bytes:" + makeString(rb, i));

        dout.close();
        s.close();
        log.debug("getEmp exit");
        return rslt;
    }
    public String post(String datasource, JobStandardInfo jobStdInfo)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException {
   //    log.debug("EmployeeService.post({}, - {} new Values {} {} {})", datasource, emp.getEmpId(), emp.getStreet(),
   //             emp.getCity(), emp.getState(), emp.getZipCode());

   //     Employee employee = new Employee();

        Socket s = new Socket("192.168.24.227", 40117);
        DataInputStream din = new DataInputStream(s.getInputStream());
        DataOutputStream dout = new DataOutputStream(s.getOutputStream());
        BufferedReader br = new BufferedReader(new InputStreamReader(din));

        /*
         * Alternative syntax 
         */
         String dialog_premap =  "GET /EMPMODD/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
         String dialog_retrieve = "GET /EMPMODD/enter?empid="  + jobStdInfo.getLdm54wm1_job_std_nr() + " HTTP";
         String dialog_update = "POST /EMPMODD/PF4?empid="   ; //+ emp.getEmpId().toString() + " HTTP";
         String dialog_exit = "GET /EMPMODD/clear HTTP";
         
        // build the variable list of changed fields only
        String dialog_body_parms = "jobStandardNr="  + jobStdInfo.getLdm54wm1_job_std_nr()  + "&tcto=" + jobStdInfo.getLdm54wm1_tcto_nr() ;
        //
        String dialog_body = "\r\nContent-Length: " + dialog_body_parms.length() + "\r\n\r\n" + dialog_body_parms + " ";

        // doPost();

        log.debug("postEmp Dialog Premap - send:" + dialog_premap);
        String req = dialog_premap;
        byte[] b = req.getBytes();
        char[] rb = new char[48176];
        dout.write(b, 0, b.length);
        dout.flush();
        log.debug("completed: send premap request ");
        log.debug("postEmp wait for response ");

        int i = -1;
        i = br.read(rb, 0, rb.length);
        log.debug("postEmp Received pm1 " + i + " bytes:" + makeString(rb, i));

        i = br.read(rb, 0, rb.length);
        log.debug("postEmp Received pm2 " + i + " bytes:" + makeString(rb, i));

        // 
        log.debug("postEmp dialog send Enter response  send:" + dialog_retrieve);
        req = dialog_retrieve;
        b = req.getBytes();
        dout.write(b, 0, b.length);
        dout.flush();
        i = br.read(rb, 0, rb.length);
        String rslt = makeString(rb, i);
        log.debug("postEmp Received1 should be 200ok: " + i + " bytes:" + rslt);
        i = br.read(rb, 0, rb.length);
        rslt = makeString(rb, i);
        log.debug("postEmp Received2 - should be resultset: " + i + " bytes:" + rslt);

        // do the update
        log.debug("postEmp dialog send POST request  send:" + dialog_update);
        req = dialog_update;
        req += dialog_body;

        log.debug("postEmp request: " + req);
        b = req.getBytes();
        dout.write(b, 0, b.length);
        dout.flush();
        i = br.read(rb, 0, rb.length);
        rslt = makeString(rb, i);
        log.debug("postEmp PostReceived1 " + i + " bytes:" + rslt);
        i = br.read(rb, 0, rb.length);
        rslt = makeString(rb, i);
        log.debug("postEmp PostReceived2 " + i + " bytes:" + rslt);

        log.debug("postEmp send after update Clear send:" + dialog_exit);
        req = dialog_exit;
        b = req.getBytes();
        dout.write(b, 0, b.length);
        dout.flush();
        i = br.read(rb, 0, rb.length);
        log.debug("postEmp received4 " + i + " bytes:" + makeString(rb, i));
        dout.close();
        s.close();
        log.debug("postEmp exit");
        return rslt;
    }

    public String makeString(char[] a, int len) {
        StringBuffer sb = new StringBuffer();
        for (int i = 0; i < len; i++) {
            sb.append(a[i]);
        }
        return sb.toString();
    }

    public static void print(String str) {
        System.out.println(str);
    }

   
}
