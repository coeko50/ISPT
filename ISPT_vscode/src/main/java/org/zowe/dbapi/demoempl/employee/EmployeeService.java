/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.demoempl.employee;

import java.math.*;    // for data types
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
 * @author Zowe Database API Generator
 * @since 1.0
 */
@Service("DemoemplEmployeeService")
@Slf4j
public class EmployeeService {

    static final String SQL_SELECT = "SELECT " +
        "\"EMP_ID\", \"MANAGER_ID\", \"EMP_FNAME\", \"EMP_LNAME\", \"DEPT_ID\", \"STREET\", \"CITY\", \"STATE\", " +
        "\"ZIP_CODE\", \"PHONE\", \"STATUS\", \"SS_NUMBER\", \"START_DATE\", \"TERMINATION_DATE\", \"BIRTH_DATE\" " +
        "FROM \"DEMOEMPL\".\"EMPLOYEE\" ";

    static final String SQL_SELECT_PKEYS = "SELECT " +
        "\"EMP_ID\" " +
        "FROM \"DEMOEMPL\".\"EMPLOYEE\" ";

    static final String SQL_WHERE_PKEYS = "WHERE \"EMP_ID\" = ?";

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * SELECT the primary or selected key and description columns from the EMPLOYEE table
     * @param empId EMP_ID value
     * @return EmployeeKeys array containing the primary or selected keys for the table or view
     */
    public List<EmployeeKeys> keys(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmployeeKeysService.keys()");

        List<EmployeeKeys> array = new ArrayList<EmployeeKeys>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT_PKEYS);
            ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                EmployeeKeys employeekeys = new EmployeeKeys();
                employeekeys
                .setEmpId((BigDecimal)rs.getObject("EMP_ID"));
                array.add(employeekeys);
            }
        }
        return array;
    }

    /**
     * SELECT exactly one row from the EMPLOYEE table
     * @param empId EMP_ID value
     * @return Employee object containing the contents of the data base record
     */
    public Employee get(String datasource, BigDecimal empId)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmployeeService.select({}, {})", datasource, empId);

        Employee employee = new Employee();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {
            stmt.setBigDecimal(1, empId);
            try(ResultSet rs = stmt.executeQuery();) {
                if (rs.next()) {
                    employee
                    .setEmpId((BigDecimal)rs.getObject("EMP_ID"))
                    .setManagerId((BigDecimal)rs.getObject("MANAGER_ID"))
                    .setEmpFname((String)rs.getObject("EMP_FNAME"))
                    .setEmpLname((String)rs.getObject("EMP_LNAME"))
                    .setDeptId((BigDecimal)rs.getObject("DEPT_ID"))
                    .setStreet((String)rs.getObject("STREET"))
                    .setCity((String)rs.getObject("CITY"))
                    .setState((String)rs.getObject("STATE"))
                    .setZipCode((String)rs.getObject("ZIP_CODE"))
                    .setPhone((String)rs.getObject("PHONE"))
                    .setStatus((String)rs.getObject("STATUS"))
                    .setSsNumber((BigDecimal)rs.getObject("SS_NUMBER"))
                    .setStartDate((Date)rs.getObject("START_DATE"))
                    .setTerminationDate((Date)rs.getObject("TERMINATION_DATE"))
                    .setBirthDate((Date)rs.getObject("BIRTH_DATE"));
                } else {
                    throw new ResourceNotFoundException("EMPLOYEE");
                }
            }
        }
        return employee;
    }

    /**
     * SELECT a result set from the EMPLOYEE table
     * @return Employee array containing the contents of the result set
     */
    public List<Employee> query(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmployeeService.query({})", datasource);

        List<Employee> array = new ArrayList<Employee>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try(ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    Employee employee = new Employee();
                    employee
                    .setEmpId((BigDecimal)rs.getObject("EMP_ID"))
                    .setManagerId((BigDecimal)rs.getObject("MANAGER_ID"))
                    .setEmpFname((String)rs.getObject("EMP_FNAME"))
                    .setEmpLname((String)rs.getObject("EMP_LNAME"))
                    .setDeptId((BigDecimal)rs.getObject("DEPT_ID"))
                    .setStreet((String)rs.getObject("STREET"))
                    .setCity((String)rs.getObject("CITY"))
                    .setState((String)rs.getObject("STATE"))
                    .setZipCode((String)rs.getObject("ZIP_CODE"))
                    .setPhone((String)rs.getObject("PHONE"))
                    .setStatus((String)rs.getObject("STATUS"))
                    .setSsNumber((BigDecimal)rs.getObject("SS_NUMBER"))
                    .setStartDate((Date)rs.getObject("START_DATE"))
                    .setTerminationDate((Date)rs.getObject("TERMINATION_DATE"))
                    .setBirthDate((Date)rs.getObject("BIRTH_DATE"));
                    array.add(employee);
                }
            }
        }
        return array;
    }
}
