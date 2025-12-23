/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.empschm.emposition;

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
 * Implements SQL access for the SQL EMPOSITION table
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@Service("EmpschmEmpositionService")
@Slf4j
public class EmpositionService {

    static final String SQL_SELECT = "SELECT " +
        "\"START_YEAR_0420\", \"START_MONTH_0420\", \"START_DAY_0420\", \"FINISH_YEAR_0420\", \"FINISH_MONTH_0420\", \"FINISH_DAY_0420\", \"SALARY_GRADE_0420\", \"SALARY_AMOUNT_0420\", " +
        "\"BONUS_PERCENT_0420\", \"COMMISSION_PERCENT_0420\", \"OVERTIME_RATE_0420\", \"ROWID\", \"FKEY_EMP_EMPOSITION\", \"FKEY_JOB_EMPOSITION\" " +
        "FROM \"EMPSCHM\".\"EMPOSITION\" ";

    static final String SQL_SELECT_PKEYS = "SELECT " +
        "\"ROWID\" " +
        "FROM \"EMPSCHM\".\"EMPOSITION\" ";

    static final String SQL_WHERE_PKEYS = "WHERE \"ROWID\" = ?";

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * SELECT the primary or selected key and description columns from the EMPOSITION table
     * @param rowid ROWID value
     * @return EmpositionKeys array containing the primary or selected keys for the table or view
     */
    public List<EmpositionKeys> keys(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpositionKeysService.keys()");

        List<EmpositionKeys> array = new ArrayList<EmpositionKeys>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT_PKEYS);
            ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                EmpositionKeys empositionkeys = new EmpositionKeys();
                empositionkeys
                .setRowid((byte[])rs.getObject("ROWID"));
                array.add(empositionkeys);
            }
        }
        return array;
    }

    /**
     * SELECT exactly one row from the EMPOSITION table
     * @param rowid ROWID value
     * @return Emposition object containing the contents of the data base record
     */
    public Emposition get(String datasource, byte[] rowid)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpositionService.select({}, {})", datasource, rowid);

        Emposition emposition = new Emposition();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {
            stmt.setBytes(1, rowid);
            try(ResultSet rs = stmt.executeQuery();) {
                if (rs.next()) {
                    emposition
                    .setStartYear0420((BigDecimal)rs.getObject("START_YEAR_0420"))
                    .setStartMonth0420((BigDecimal)rs.getObject("START_MONTH_0420"))
                    .setStartDay0420((BigDecimal)rs.getObject("START_DAY_0420"))
                    .setFinishYear0420((BigDecimal)rs.getObject("FINISH_YEAR_0420"))
                    .setFinishMonth0420((BigDecimal)rs.getObject("FINISH_MONTH_0420"))
                    .setFinishDay0420((BigDecimal)rs.getObject("FINISH_DAY_0420"))
                    .setSalaryGrade0420((BigDecimal)rs.getObject("SALARY_GRADE_0420"))
                    .setSalaryAmount0420((BigDecimal)rs.getObject("SALARY_AMOUNT_0420"))
                    .setBonusPercent0420((BigDecimal)rs.getObject("BONUS_PERCENT_0420"))
                    .setCommissionPercent0420((BigDecimal)rs.getObject("COMMISSION_PERCENT_0420"))
                    .setOvertimeRate0420((BigDecimal)rs.getObject("OVERTIME_RATE_0420"))
                    .setRowid((byte[])rs.getObject("ROWID"))
                    .setFkeyEmpEmposition((byte[])rs.getObject("FKEY_EMP_EMPOSITION"))
                    .setFkeyJobEmposition((byte[])rs.getObject("FKEY_JOB_EMPOSITION"));
                } else {
                    throw new ResourceNotFoundException("EMPOSITION");
                }
            }
        }
        return emposition;
    }

    /**
     * SELECT a result set from the EMPOSITION table
     * @return Emposition array containing the contents of the result set
     */
    public List<Emposition> query(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpositionService.query({})", datasource);

        List<Emposition> array = new ArrayList<Emposition>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try(ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    Emposition emposition = new Emposition();
                    emposition
                    .setStartYear0420((BigDecimal)rs.getObject("START_YEAR_0420"))
                    .setStartMonth0420((BigDecimal)rs.getObject("START_MONTH_0420"))
                    .setStartDay0420((BigDecimal)rs.getObject("START_DAY_0420"))
                    .setFinishYear0420((BigDecimal)rs.getObject("FINISH_YEAR_0420"))
                    .setFinishMonth0420((BigDecimal)rs.getObject("FINISH_MONTH_0420"))
                    .setFinishDay0420((BigDecimal)rs.getObject("FINISH_DAY_0420"))
                    .setSalaryGrade0420((BigDecimal)rs.getObject("SALARY_GRADE_0420"))
                    .setSalaryAmount0420((BigDecimal)rs.getObject("SALARY_AMOUNT_0420"))
                    .setBonusPercent0420((BigDecimal)rs.getObject("BONUS_PERCENT_0420"))
                    .setCommissionPercent0420((BigDecimal)rs.getObject("COMMISSION_PERCENT_0420"))
                    .setOvertimeRate0420((BigDecimal)rs.getObject("OVERTIME_RATE_0420"))
                    .setRowid((byte[])rs.getObject("ROWID"))
                    .setFkeyEmpEmposition((byte[])rs.getObject("FKEY_EMP_EMPOSITION"))
                    .setFkeyJobEmposition((byte[])rs.getObject("FKEY_JOB_EMPOSITION"));
                    array.add(emposition);
                }
            }
        }
        return array;
    }
}
