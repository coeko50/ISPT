/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.empsql.empcoverage;

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
 * Implements SQL access for the SQL EMP_COVERAGE table
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@Service("EmpsqlEmpCoverageService")
@Slf4j
public class EmpCoverageService {

    static final String SQL_SELECT = "SELECT " +
        "\"EMP_ID\", \"SEL_DATE\", \"TERM_DATE\", \"TYPE_CODE\", \"INS_PLAN_CODE\", \"OCC_NBR\" " +
        "FROM \"EMPSQL\".\"EMP_COVERAGE\" ";

    static final String SQL_SELECT_PKEYS = "SELECT " +
        "\"EMP_ID\", \"SEL_DATE\" " +
        "FROM \"EMPSQL\".\"EMP_COVERAGE\" ";

    static final String SQL_WHERE_PKEYS = "WHERE \"EMP_ID\" = ?  ";
    
    static final String SQL_UPDATE = "UPDATE \"EMPSQL\".\"EMP_COVERAGE\" SET " +
            " \"TERM_DATE\"=? , \"TYPE_CODE\"=? ,\"INS_PLAN_CODE\"=?WHERE \"EMP_ID\" = ? AND \"SEL_DATE\" = ?";
    
    static final String SQL_UPDATE_OCC = "UPDATE EMPSQL.EMP_COVERAGE SET " +
            " SEL_DATE=? ,TERM_DATE=? , TYPE_CODE=? ,INS_PLAN_CODE=?" +
            " WHERE EMP_ID = ? AND OCC_NBR = ?";
    
    static final String SQL_INSERT = "INSERT INTO \"EMPSQL\".\"EMP_COVERAGE\" (" +
            "\"EMP_ID\", \"SEL_DATE\", \"TERM_DATE\", \"TYPE_CODE\", \"INS_PLAN_CODE\" ) " +
            "VALUES (?,?,?,?,?) ";

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * SELECT the primary or selected key and description columns from the EMP_COVERAGE table
     * @param empId EMP_ID value
     * @param selDate SEL_DATE value
     * @return EmpCoverageKeys array containing the primary or selected keys for the table or view
     */
    public List<EmpCoverageKeys> keys(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpCoverageKeysService.keys()");

        List<EmpCoverageKeys> array = new ArrayList<EmpCoverageKeys>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT_PKEYS);
            ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                EmpCoverageKeys empcoveragekeys = new EmpCoverageKeys();
                empcoveragekeys
                .setEmpId((BigDecimal)rs.getObject("EMP_ID"))
                .setSelDate((Date)rs.getObject("SEL_DATE"));
                array.add(empcoveragekeys);
            }
        }
        return array;
    }

    /**
     * SELECT  rows from the EMP_COVERAGE table
     * @param empId EMP_ID value
      
     * @return EmpCoverage object containing the contents of the data base record
     */
    public List<EmpCoverage> get(String datasource, BigDecimal empId )
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpCoverageService.select({}, {}   )", datasource, empId );
        List<EmpCoverage> array = new ArrayList<EmpCoverage>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {
            stmt.setBigDecimal(1, empId);
            
            try(ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    EmpCoverage empcoverage = new EmpCoverage();
                     empcoverage
                    .setEmpId((BigDecimal)rs.getObject("EMP_ID"))
                    .setSelDate((Date)rs.getObject("SEL_DATE"))
                    .setTermDate((Date)rs.getObject("TERM_DATE"))
                    .setTypeCode((String)rs.getObject("TYPE_CODE"))
                    .setInsPlanCode((String)rs.getObject("INS_PLAN_CODE"))
                    .setOccNbr((BigDecimal)rs.getObject("OCC_NBR"));
                    array.add(empcoverage);
                }  
            }
        }
        return array;
    }

    /**
     * SELECT a result set from the EMP_COVERAGE table
     * @return EmpCoverage array containing the contents of the result set
     */
    public List<EmpCoverage> query(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpCoverageService.query({})", datasource);

        List<EmpCoverage> array = new ArrayList<EmpCoverage>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try(ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    EmpCoverage empcoverage = new EmpCoverage();
                    empcoverage
                    .setEmpId((BigDecimal)rs.getObject("EMP_ID"))
                    .setSelDate((Date)rs.getObject("SEL_DATE"))
                    .setTermDate((Date)rs.getObject("TERM_DATE"))
                    .setTypeCode((String)rs.getObject("TYPE_CODE"))
                    .setInsPlanCode((String)rs.getObject("INS_PLAN_CODE"))
                    .setOccNbr((BigDecimal)rs.getObject("OCC_NBR"));
                    array.add(empcoverage);
                }
            }
        }
        return array;
    }

     /*
     * Code insersion starts
     * Code the POST (insert) and PUT (update) operations manually
     */
    /**
     * insert exactly one row from the EMP_COVERAGE table
     * 
     * @param empId       EMP_ID value
     * @param selDate     SEL_DATE value
     * @param termDate    TERM_DATE value
     * @param typeCode    TYPE_CODE value
     * @param InsPlanCode INS_PLAN_CODE value
     * @return
     */
    public int post(String datasource, BigDecimal empId, Date selDate, Date termDate, String typeCode,
            String insPlanCode)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpCoverageService.post({}, {})", datasource, empId);
        int rowsInserted;
        try (Connection conn = dataSourceRouter.getConnection(datasource);
                PreparedStatement stmt = conn.prepareStatement(SQL_INSERT);) {
            stmt.setBigDecimal(1, empId);
            stmt.setDate(2, selDate);
            stmt.setDate(3, termDate);
            stmt.setString(4, typeCode);
            stmt.setString(5, insPlanCode);
            rowsInserted = stmt.executeUpdate();

        }
        return rowsInserted;
    }

    /**
     * insert exactly one row from the EMP_COVERAGE table
     * 
     * @param empId       EMP_ID value
     * @param selDate     SEL_DATE value
     * @param termDate    TERM_DATE value
     * @param typeCode    TYPE_CODE value
     * @param InsPlanCode INS_PLAN_CODE value
     * @param occNbr      Set occurrance number
     * @return
     */
    public int put(String datasource, BigDecimal empId, Date selDate, Date termDate, String typeCode,
            String insPlanCode, BigDecimal occNbr)
            throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpCoverageService.put({}, {} occ: {})", datasource, empId.toString(), occNbr);
        int rowsUpdated = 0;

        if (occNbr == null) {
            try (Connection conn = dataSourceRouter.getConnection(datasource);
                    PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE);) {
                stmt.setDate(1, termDate);
                stmt.setString(2, typeCode);
                stmt.setString(3, insPlanCode);
                stmt.setBigDecimal(4, empId);
                stmt.setDate(5, selDate);
                rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("emp coverage updated successfully!");
                }
            }
        } else {
            try (Connection conn = dataSourceRouter.getConnection(datasource);
                    PreparedStatement stmt = conn.prepareStatement(SQL_UPDATE_OCC);) {
                stmt.setDate(1, selDate);
                stmt.setDate(2, termDate);
                stmt.setString(3, typeCode);
                stmt.setString(4, insPlanCode);
                stmt.setBigDecimal(5, empId);
                stmt.setBigDecimal(6, occNbr);
                rowsUpdated = stmt.executeUpdate();
                if (rowsUpdated > 0) {
                    System.out.println("Emp coverage occurrence was updated successfully!");
                }
            }
        }
        return rowsUpdated;
    }

    /*
     * Code insersion ends
     */
}
