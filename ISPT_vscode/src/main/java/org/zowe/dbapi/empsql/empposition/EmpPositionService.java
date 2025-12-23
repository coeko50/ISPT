/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.empsql.empposition;

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
 * Implements SQL access for the SQL EMP_POSITION view
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@Service("EmpsqlEmpPositionService")
@Slf4j
public class EmpPositionService {

    static final String SQL_SELECT = "SELECT " +
        "\"EMPID\", \"FNAME\", \"LNAME\", \"DEPTID\", \"DEPTNAME\", \"JOBID\", \"JOBTITLE\", \"POS_START_DATE\", \"POS_END_DATE\" " +
        "FROM \"EMPSQL\".\"EMP_POSITION\" ";

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * SELECT a result set from the EMP_POSITION view
     * @return EmpPosition array containing the contents of the result set
     */
    public List<EmpPosition> query(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("EmpPositionService.query({})", datasource);

        List<EmpPosition> array = new ArrayList<EmpPosition>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try(ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    EmpPosition empposition = new EmpPosition();
                    empposition
                    .setEmpid((BigDecimal)rs.getObject("EMPID"))
                    .setFname((String)rs.getObject("FNAME"))
                    .setLname((String)rs.getObject("LNAME"))
                    .setDeptid((BigDecimal)rs.getObject("DEPTID"))
                    .setDeptname((String)rs.getObject("DEPTNAME"))
                    .setJobid((BigDecimal)rs.getObject("JOBID"))
                    .setJobtitle((String)rs.getObject("JOBTITLE"))
                    .setPosStartDate((Date)rs.getObject("POS_START_DATE"))
                    .setPosEndDate((Date)rs.getObject("POS_END_DATE"));
                    array.add(empposition);
                }
            }
        }
        return array;
    }
}
