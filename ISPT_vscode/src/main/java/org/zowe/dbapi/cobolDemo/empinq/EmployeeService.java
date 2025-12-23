/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.cobolDemo.empinq;

import java.math.*; // for data types
import java.sql.*;
import java.util.ArrayList;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.sql.CommonDataSource;
import javax.sql.DataSource;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.zowe.dbapi.ispt.IdmsResponse;
import org.zowe.dbapi.ispt.Ispt;

import com.broadcom.dbapi.common.BasicDataSourceRouter;
import com.broadcom.dbapi.common.DataSourceRouter;
import com.broadcom.dbapi.datasource.Datasource;
import com.broadcom.dbapi.datasource.DatasourceController;
import com.broadcom.dbapi.exception.DataSourceNotFoundException;
import com.broadcom.dbapi.exception.ResourceNotFoundException;
import com.broadcom.dbapi.config.DataSourceConfig;
//import ca.idms.jdbc.IdmsDataSource;
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
import java.lang.reflect.Method;
import java.net.*;

@Service("Cobol EmployeeService")
@Slf4j
public class EmployeeService {
    public static void main(String args[]) {
        log.debug("Run cobol.EmployeeService.main");
        EmployeeService service = new EmployeeService();
        BigDecimal empid = new BigDecimal(31);
        // Employee e = new Employee();
        try {
            String ee = service.get("APIDEMO", empid);
            print(ee);

        } catch (Exception ee) {

            ee.printStackTrace();
        }
    }

    @Autowired
    private DataSourceRouter dataSourceRouter;
    Ispt ispt;

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
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException,IllegalAccessException ,NoSuchMethodException,InvocationTargetException {
        log.debug("Cobol.EmployeeService.getEmpInfo({}, {})", datasource, empId);

        String cobol_premap = "GET /empInqpc/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String cobol_retrieve = "GET /empinqpc/enter?emp_id=" + empId.toString() + " HTTP";
        String cobol_exit = "GET /empinqpc/clear HTTP";
        ispt.setMethod(new Object() {
        }.getClass().getEnclosingMethod().getName());
        ispt.connect(datasource, dataSourceRouter);
        log.debug("getEmpInfo program Premap - send:" + cobol_premap);

        IdmsResponse response = new IdmsResponse();
        String rslt = "{}";
        try {
            log.debug("cobolDemo Premap - send:" + cobol_premap);

            response = ispt.sendReceive(cobol_premap, "Premap");

            /*
             * Cobol program is now active and displayed the map.
             * Trigger the response to retrieve the data
             * and do a mapout again
             */
            log.debug("cobolDemo.getEmp dialog send Enter response  send:" + cobol_retrieve);
            response = ispt.sendReceive(cobol_retrieve, "retrieve");
            rslt = response.getJson();
            /*
             * rslt contains the json from the dialog
             * exit the program but sending the appropiate aid byte
             *
             */
            log.debug("cobolDemo.getEmp exit- send:" + cobol_exit);
            response = ispt.sendReceive(cobol_exit, "exit");
        } catch (Exception e) {
            log.debug("some error " + e.getStackTrace());
        }

        ispt.close();
        log.debug("getEmp exit");
        return rslt;
    }

    public String get(String datasource, BigDecimal empId)
            throws ResourceNotFoundException, SQLException, IOException, IllegalAccessException, NoSuchMethodException,
            InvocationTargetException {

        log.debug("Cobol.EmployeeService.get init {}, {})", datasource, empId);
        ispt.setMethod(new Object() {
        }.getClass().getEnclosingMethod().getName());

        ispt.connect(datasource, dataSourceRouter);

        String cobol_premap = "GET /empInqpc/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String cobol_retrieve = "GET /empinqpc/enter?emp_id=" + empId.toString() + " HTTP";
        String cobol_exit = "GET /empinqpc/clear HTTP";

        IdmsResponse response = new IdmsResponse();
        String rslt = "{}";
        try {
            log.debug("cobolDemo Premap - send:" + cobol_premap);

            response = ispt.sendReceive(cobol_premap, "Premap");

            /*
             * Cobol program is now active and displayed the map.
             * Trigger the response to retrieve the data
             * and do a mapout again
             */
            log.debug("cobolDemo.getEmp dialog send Enter response  send:" + cobol_retrieve);
            response = ispt.sendReceive(cobol_retrieve, "retrieve");
            rslt = response.getJson();
            /*
             * rslt contains the json from the dialog
             * exit the program but sending the appropiate aid byte
             *
             */
            log.debug("cobolDemo.getEmp exit- send:" + cobol_exit);
            response = ispt.sendReceive(cobol_exit, "exit");
        } catch (Exception e) {
            log.debug("some error " + e.getStackTrace());
        }

        ispt.close();
        log.debug("getEmp exit");
        return rslt;
    }

    public String post(String datasource, CobolEmployee emp)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException, IOException ,IllegalAccessException ,NoSuchMethodException,InvocationTargetException{
        log.debug("EmployeeService.post({}, - {} new Values {} {} {})", datasource, emp.getEmpId(), emp.getStreet(),
                emp.getCity(), emp.getState(), emp.getZipCode());

        CobolEmployee employee = new CobolEmployee();
        String cobol_premap = "GET /EMPMODD/premap HTTP/1.1\r\nHost:www.example.com\r\n\r\n";
        String cobol_retrieve = "GET /EMPMODD/enter?emp_id=" + emp.getEmpId().toString() + " HTTP";
        String cobol_update = "POST /EMPMODD/PF4?empid=" + emp.getEmpId().toString() + " HTTP";
        String cobol_exit = "GET /EMPMODD/clear HTTP";

        // build the variable list of changed fields only
        String cobol_body_parms = "empstreet=" + emp.getStreet() + "&empcity=" + emp.getCity();
        //
        String cobol_body = "\r\nContent-Length: " + cobol_body_parms.length() + "\r\n\r\n" + cobol_body_parms + " ";
        ispt.setMethod(new Object() {
        }.getClass().getEnclosingMethod().getName());

        ispt.connect(datasource, dataSourceRouter);

        IdmsResponse response = new IdmsResponse();
        String rslt = "{}";
        try {
            log.debug("cobolDemo post Premap - send:" + cobol_premap);

            response = ispt.sendReceive(cobol_premap, "Premap");

            /*
             * Cobol program is now active and displayed the map.
             * Trigger the response to retrieve the data
             * and do a mapout again
             */
            log.debug("cobolDemo.post send Enter response  send:" + cobol_retrieve);
            response = ispt.sendReceive(cobol_retrieve, "retrieve");
            rslt = response.getJson();
            /*
             * do the update
             */
            log.debug("cobolDemo.post do update send:" + cobol_retrieve);
            response = ispt.sendReceive(cobol_retrieve, "retrieve");
            rslt = response.getJson();
            /*
             * rslt contains the json from the dialog
             * exit the program but sending the appropiate aid byte
             *
             */
            log.debug("cobolDemo.post exit- send:" + cobol_exit);
            response = ispt.sendReceive(cobol_exit, "exit");
        } catch (Exception e) {
            log.debug("some error " + e.getStackTrace());
        }

        ispt.close();
        log.debug("getEmp exit");
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

    /**
     * SELECT a result set from the EMPLOYEE table
     * 
     * @return Employee array containing the contents of the result set
     */
    public List<CobolEmployee> query(String datasource)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmployeeService.query({})", datasource);
        String SQL_SELECT = "select empid from empschm.employee";
        List<CobolEmployee> array = new ArrayList<CobolEmployee>();
        try (Connection conn = dataSourceRouter.getConnection(datasource);
                PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try (ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    CobolEmployee employee = new CobolEmployee();
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
