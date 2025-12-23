/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.empschm.employee;

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
@Service("EmpschmEmployeeService")
@Slf4j
public class EmployeeService {

    static final String SQL_SELECT = "SELECT " +
        "\"EMP_ID_0415\", \"EMP_FIRST_NAME_0415\", \"EMP_LAST_NAME_0415\", \"EMP_STREET_0415\", \"EMP_CITY_0415\", \"EMP_STATE_0415\", \"EMP_ZIP_FIRST_FIVE_0415\", \"EMP_ZIP_LAST_FOUR_0415\", " +
        "\"EMP_PHONE_0415\", \"STATUS_0415\", \"SS_NUMBER_0415\", \"START_YEAR_0415\", \"START_MONTH_0415\", \"START_DAY_0415\", \"TERMINATION_YEAR_0415\", \"TERMINATION_MONTH_0415\", " +
        "\"TERMINATION_DAY_0415\", \"BIRTH_YEAR_0415\", \"BIRTH_MONTH_0415\", \"BIRTH_DAY_0415\", \"ROWID\", \"FKEY_DEPT_EMPLOYEE\", \"FKEY_OFFICE_EMPLOYEE\" " +
        "FROM \"EMPSCHM\".\"EMPLOYEE\" ";

    static final String SQL_SELECT_PKEYS = "SELECT " +
        "\"EMP_ID_0415\" " +
        "FROM \"EMPSCHM\".\"EMPLOYEE\" ";

    static final String SQL_WHERE_PKEYS = "WHERE \"EMP_ID_0415\" = ?";

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * SELECT the primary or selected key and description columns from the EMPLOYEE table
     * @param empId0415 EMP_ID_0415 value
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
                .setEmpId0415((BigDecimal)rs.getObject("EMP_ID_0415"));
                array.add(employeekeys);
            }
        }
        return array;
    }

    /**
     * SELECT exactly one row from the EMPLOYEE table
     * @param empId0415 EMP_ID_0415 value
     * @return Employee object containing the contents of the data base record
     */
    public Employee get(String datasource, BigDecimal empId0415)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmployeeService.select({}, {})", datasource, empId0415);

        Employee employee = new Employee();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {
            stmt.setBigDecimal(1, empId0415);
            try(ResultSet rs = stmt.executeQuery();) {
                if (rs.next()) {
                    employee
                    .setEmpId0415((BigDecimal)rs.getObject("EMP_ID_0415"))
                    .setEmpFirstName0415((String)rs.getObject("EMP_FIRST_NAME_0415"))
                    .setEmpLastName0415((String)rs.getObject("EMP_LAST_NAME_0415"))
                    .setEmpStreet0415((String)rs.getObject("EMP_STREET_0415"))
                    .setEmpCity0415((String)rs.getObject("EMP_CITY_0415"))
                    .setEmpState0415((String)rs.getObject("EMP_STATE_0415"))
                    .setEmpZipFirstFive0415((String)rs.getObject("EMP_ZIP_FIRST_FIVE_0415"))
                    .setEmpZipLastFour0415((String)rs.getObject("EMP_ZIP_LAST_FOUR_0415"))
                    .setEmpPhone0415((BigDecimal)rs.getObject("EMP_PHONE_0415"))
                    .setStatus0415((String)rs.getObject("STATUS_0415"))
                    .setSsNumber0415((BigDecimal)rs.getObject("SS_NUMBER_0415"))
                    .setStartYear0415((BigDecimal)rs.getObject("START_YEAR_0415"))
                    .setStartMonth0415((BigDecimal)rs.getObject("START_MONTH_0415"))
                    .setStartDay0415((BigDecimal)rs.getObject("START_DAY_0415"))
                    .setTerminationYear0415((BigDecimal)rs.getObject("TERMINATION_YEAR_0415"))
                    .setTerminationMonth0415((BigDecimal)rs.getObject("TERMINATION_MONTH_0415"))
                    .setTerminationDay0415((BigDecimal)rs.getObject("TERMINATION_DAY_0415"))
                    .setBirthYear0415((BigDecimal)rs.getObject("BIRTH_YEAR_0415"))
                    .setBirthMonth0415((BigDecimal)rs.getObject("BIRTH_MONTH_0415"))
                    .setBirthDay0415((BigDecimal)rs.getObject("BIRTH_DAY_0415"))
                    .setRowid((byte[])rs.getObject("ROWID"))
                    .setFkeyDeptEmployee((byte[])rs.getObject("FKEY_DEPT_EMPLOYEE"))
                    .setFkeyOfficeEmployee((byte[])rs.getObject("FKEY_OFFICE_EMPLOYEE"));
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
                    .setEmpId0415((BigDecimal)rs.getObject("EMP_ID_0415"))
                    .setEmpFirstName0415((String)rs.getObject("EMP_FIRST_NAME_0415"))
                    .setEmpLastName0415((String)rs.getObject("EMP_LAST_NAME_0415"))
                    .setEmpStreet0415((String)rs.getObject("EMP_STREET_0415"))
                    .setEmpCity0415((String)rs.getObject("EMP_CITY_0415"))
                    .setEmpState0415((String)rs.getObject("EMP_STATE_0415"))
                    .setEmpZipFirstFive0415((String)rs.getObject("EMP_ZIP_FIRST_FIVE_0415"))
                    .setEmpZipLastFour0415((String)rs.getObject("EMP_ZIP_LAST_FOUR_0415"))
                    .setEmpPhone0415((BigDecimal)rs.getObject("EMP_PHONE_0415"))
                    .setStatus0415((String)rs.getObject("STATUS_0415"))
                    .setSsNumber0415((BigDecimal)rs.getObject("SS_NUMBER_0415"))
                    .setStartYear0415((BigDecimal)rs.getObject("START_YEAR_0415"))
                    .setStartMonth0415((BigDecimal)rs.getObject("START_MONTH_0415"))
                    .setStartDay0415((BigDecimal)rs.getObject("START_DAY_0415"))
                    .setTerminationYear0415((BigDecimal)rs.getObject("TERMINATION_YEAR_0415"))
                    .setTerminationMonth0415((BigDecimal)rs.getObject("TERMINATION_MONTH_0415"))
                    .setTerminationDay0415((BigDecimal)rs.getObject("TERMINATION_DAY_0415"))
                    .setBirthYear0415((BigDecimal)rs.getObject("BIRTH_YEAR_0415"))
                    .setBirthMonth0415((BigDecimal)rs.getObject("BIRTH_MONTH_0415"))
                    .setBirthDay0415((BigDecimal)rs.getObject("BIRTH_DAY_0415"))
                    .setRowid((byte[])rs.getObject("ROWID"))
                    .setFkeyDeptEmployee((byte[])rs.getObject("FKEY_DEPT_EMPLOYEE"))
                    .setFkeyOfficeEmployee((byte[])rs.getObject("FKEY_OFFICE_EMPLOYEE"));
                    array.add(employee);
                }
            }
        }
        return array;
    }
}
