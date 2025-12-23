/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.adsDemo.employee;

import java.math.*; // for data types
import java.sql.*;
import java.util.ArrayList;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zowe.dbapi.adsDemo.employee.exceptions.EmployeeNotFoundException;

import com.broadcom.dbapi.common.DataSourceRouter;
import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;
import org.zowe.dbapi.eafDemo.LDM54.exceptions.DuplicateJobStandardException;
import org.zowe.dbapi.ispt.IdmsResponse;
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

@Service("Ads EmployeeService")
@Slf4j
public class EmployeeService {
  
    @Autowired
    private DataSourceRouter dataSourceRouter;
   private  Ispt ispt ;

    public EmployeeService() {
          ispt = new Ispt(this.getClass().getName());
    }
    /**
     * get the mapout data from empinqd for a empid
     * 
     * @param empId EMP_ID value
     * @return JSON object representing the map data
     */
    public String getEmpInfo(String datasource, BigDecimal empId)
            throws EmployeeNotFoundException, DataSourceNotFoundException, ResourceNotFoundException, SQLException,
            IOException ,IllegalAccessException,NoSuchMethodException,InvocationTargetException{
        log.debug("ADS-EmployeeService.getEmpInfo-1({}, {})", datasource, empId);

       
        String dialog_premap = "GET /emplj/query/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_retrieve = "GET /emplj/query/enter?emp_id=" + empId.toString() + " HTTP";
        String dialog_exit = "GET /emplj/query/clear HTTP";
  
        ispt.setMethod(new Object() {}.getClass().getEnclosingMethod().getName());
     
        ispt.connect(datasource, dataSourceRouter);

        log.debug("getEmpInfo Dialog Premap - send:" + dialog_premap);

        IdmsResponse response = new IdmsResponse();
        String rslt = "{}";

        try {
            response = ispt.sendReceive(dialog_premap, "Premap");

            /*
             * Dialog is now active and displayed the map.
             * Trigger the response process to retrieve the data
             * and do a mapout again
             */
            log.debug("getEmpInfo dialog send Enter response  send:" + dialog_retrieve);
            response = ispt.sendReceive(dialog_retrieve, "retrieve");
            rslt = response.getJson();
            /*
             * rslt contains the json from the dialog
             * exit the dialog by sending the appropiate aid byte
             */
            log.debug("getEmp Dialog exit- send:" + dialog_exit);
            response = ispt.sendReceive(dialog_exit, "exit");
        } catch (Exception e) {
            log.debug("some error " + e.getStackTrace());
        }

        ispt.close();

        return rslt;
    }

    public String get(String datasource, BigDecimal empId)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException,
            IllegalAccessException, NoSuchMethodException, InvocationTargetException,NoSuchMethodException ,InvocationTargetException{
        log.debug("Adsdemo EmployeeService.get({}, {})", datasource, empId);
/*
        String dialog_premap = "GET /empmodd/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_retrieve = "GET /empmodd/enter?empid=" + empId.toString() + " HTTP";
        String dialog_exit = "GET /emplj/empmodd/clear HTTP";
  */
        String dialog_premap = "GET /emplj/query/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_retrieve = "GET /emplj/query/enter?emp_id=" + empId.toString() + " HTTP";
        String dialog_exit = "GET /emplj/query/clear HTTP";
  

      
        ispt.connect(datasource, dataSourceRouter);

        log.debug("getEmpInfo Dialog Premap - send:" + dialog_premap);

        IdmsResponse response = new IdmsResponse();
        String rslt = "{}";

        try {
            response = ispt.sendReceive(dialog_premap, "Premap");

            /*
             * Dialog is now active and displayed the map.
             * Trigger the response process to retrieve the data
             * and do a mapout again
             */
            log.debug("getEmpInfo dialog send Enter response  send:" + dialog_retrieve);
            response = ispt.sendReceive(dialog_retrieve, "retrieve");
            rslt = response.getJson();
            /*
             * rslt contains the json from the dialog
             * exit the dialog by sending the appropiate aid byte
             */
            log.debug("getEmp Dialog exit- send:" + dialog_exit);
            response = ispt.sendReceive(dialog_exit, "exit");
        } catch (Exception e) {
            log.debug("some error " + e.getStackTrace());
        }

        ispt.close();

        return rslt;
    }

    public String post(String datasource, Employee emp)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException,
            DuplicateJobStandardException,IllegalAccessException ,NoSuchMethodException,InvocationTargetException{
        log.debug("EmployeeService.post({}, - {} new Values {} {} {})", datasource, emp.getEmpId(), emp.getStreet(),
                emp.getCity(), emp.getState(), emp.getZipCode());

        Employee employee = new Employee();
  
       /*
         * Alternative syntax
         */
        String dialog_premap = "GET /EMPMODD/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String dialog_retrieve = "GET /EMPMODD/enter?empid=" + emp.getEmpId().toString() + " HTTP";
        String dialog_update = "POST /EMPMODD/PF4?empid=" + emp.getEmpId().toString() + " HTTP";
        String dialog_exit = "GET /EMPMODD/clear HTTP";

        // build the variable list of changed fields only
        String dialog_body_parms = "empstreet=" + emp.getStreet() + "&empcity=" + emp.getCity();
        //
        String dialog_body = "\r\nContent-Length: " + dialog_body_parms.length() + "\r\n\r\n" + dialog_body_parms + " ";

        // doPost();

         Ispt ispt = new Ispt();
        ispt.connect(datasource, dataSourceRouter);   /* establish connect with poor old IDMS  */

        log.debug("getEmp Dialog Premap - send:" + dialog_premap);

        IdmsResponse response = new IdmsResponse();
        String rslt = "{}";

        try {
            response = ispt.sendReceive(dialog_premap, "Premap");

            /*
             * Dialog is now active and displayed the map.
             * Trigger the response process to retrieve the data
             * and do a mapout again
             */
            log.debug("post dialog send Enter response  send:" + dialog_retrieve);
            response = ispt.sendReceive(dialog_retrieve, "retrieve");
            rslt = response.getJson();
            /*
             * Dialog is now active and displayed the map.
             * Trigger the response process to update the data
             * and do a mapout again
             */
            log.debug("post dialog send Enter response  send:" + dialog_retrieve);
            response = ispt.sendReceive(dialog_update, "update");
            rslt = response.getJson();
           /*
             * rslt contains the json from the dialog
             * exit the dialog by sending the appropiate aid byte
             */
            log.debug("post Dialog exit- send:" + dialog_exit);
            response = ispt.sendReceive(dialog_exit, "exit");
        } catch (Exception e) {
            log.debug("some error " + e.getStackTrace());
        }

        ispt.close();

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

    

    public String toDialogBody(String parms) {
        return "\r\nContent-Length: " + parms.length() + "\r\n\r\n" + parms + " ";

    }

  
    /**
     * SELECT a result set from the EMPLOYEE table
     * 
     * @return Employee array containing the contents of the result set
     */
    public List<Employee> query(String datasource)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmployeeService.query({})", datasource);
        String SQL_SELECT = "select empid from empschm.employee";
        List<Employee> array = new ArrayList<Employee>();
        try (Connection conn = dataSourceRouter.getConnection(datasource);
                PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try (ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    Employee employee = new Employee();
                    employee
                            .setEmpId((BigDecimal) rs.getObject("EMP_ID"))
                            .setManagerId((BigDecimal) rs.getObject("MANAGER_ID"))
                            .setEmpFname((String) rs.getObject("EMP_FNAME"))
                            .setEmpLname((String) rs.getObject("EMP_LNAME"))
                            .setDeptId((BigDecimal) rs.getObject("DEPT_ID"))
                            .setStreet((String) rs.getObject("STREET"))
                            .setCity((String) rs.getObject("CITY"))
                            .setState((String) rs.getObject("STATE"))
                            .setZipCode((String) rs.getObject("ZIP_CODE"))
                            .setPhone((String) rs.getObject("PHONE"))
                            .setStatus((String) rs.getObject("STATUS"))
                            .setSsNumber((BigDecimal) rs.getObject("SS_NUMBER"))
                            .setStartDate((Date) rs.getObject("START_DATE"))
                            .setTerminationDate((Date) rs.getObject("TERMINATION_DATE"))
                            .setBirthDate((Date) rs.getObject("BIRTH_DATE"));
                    array.add(employee);
                }
            }
        }
        return array;
    }
}
