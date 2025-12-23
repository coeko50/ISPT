/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.empschm.job;

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
 * Implements SQL access for the SQL JOB table
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@Service("EmpschmJobService")
@Slf4j
public class JobService {

    static final String SQL_SELECT = "SELECT " +
        "\"JOB_ID_0440\", \"TITLE_0440\", \"DESCRIPTION_LINE_0440_1\", \"DESCRIPTION_LINE_0440_2\", \"REQUIREMENT_LINE_0440_1\", \"REQUIREMENT_LINE_0440_2\", \"MINIMUM_SALARY_0440\", \"MAXIMUM_SALARY_0440\", " +
        "\"SALARY_GRADES_0440_1\", \"SALARY_GRADES_0440_2\", \"SALARY_GRADES_0440_3\", \"SALARY_GRADES_0440_4\", \"NUMBER_OF_POSITIONS_0440\", \"NUMBER_OPEN_0440\", \"ROWID\" " +
        "FROM \"EMPSCHM\".\"JOB\" ";

    static final String SQL_SELECT_PKEYS = "SELECT " +
        "\"JOB_ID_0440\" " +
        "FROM \"EMPSCHM\".\"JOB\" ";

    static final String SQL_WHERE_PKEYS = "WHERE \"JOB_ID_0440\" = ?";

    @Autowired
    private DataSourceRouter dataSourceRouter;

    /**
     * SELECT the primary or selected key and description columns from the JOB table
     * @param jobId0440 JOB_ID_0440 value
     * @return JobKeys array containing the primary or selected keys for the table or view
     */
    public List<JobKeys> keys(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("JobKeysService.keys()");

        List<JobKeys> array = new ArrayList<JobKeys>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT_PKEYS);
            ResultSet rs = stmt.executeQuery();) {
            while (rs.next()) {
                JobKeys jobkeys = new JobKeys();
                jobkeys
                .setJobId0440((BigDecimal)rs.getObject("JOB_ID_0440"));
                array.add(jobkeys);
            }
        }
        return array;
    }

    /**
     * SELECT exactly one row from the JOB table
     * @param jobId0440 JOB_ID_0440 value
     * @return Job object containing the contents of the data base record
     */
    public Job get(String datasource, BigDecimal jobId0440)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("JobService.select({}, {})", datasource, jobId0440);

        Job job = new Job();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT + SQL_WHERE_PKEYS);) {
            stmt.setBigDecimal(1, jobId0440);
            try(ResultSet rs = stmt.executeQuery();) {
                if (rs.next()) {
                    job
                    .setJobId0440((BigDecimal)rs.getObject("JOB_ID_0440"))
                    .setTitle0440((String)rs.getObject("TITLE_0440"))
                    .setDescriptionLine04401((String)rs.getObject("DESCRIPTION_LINE_0440_1"))
                    .setDescriptionLine04402((String)rs.getObject("DESCRIPTION_LINE_0440_2"))
                    .setRequirementLine04401((String)rs.getObject("REQUIREMENT_LINE_0440_1"))
                    .setRequirementLine04402((String)rs.getObject("REQUIREMENT_LINE_0440_2"))
                    .setMinimumSalary0440((BigDecimal)rs.getObject("MINIMUM_SALARY_0440"))
                    .setMaximumSalary0440((BigDecimal)rs.getObject("MAXIMUM_SALARY_0440"))
                    .setSalaryGrades04401((BigDecimal)rs.getObject("SALARY_GRADES_0440_1"))
                    .setSalaryGrades04402((BigDecimal)rs.getObject("SALARY_GRADES_0440_2"))
                    .setSalaryGrades04403((BigDecimal)rs.getObject("SALARY_GRADES_0440_3"))
                    .setSalaryGrades04404((BigDecimal)rs.getObject("SALARY_GRADES_0440_4"))
                    .setNumberOfPositions0440((BigDecimal)rs.getObject("NUMBER_OF_POSITIONS_0440"))
                    .setNumberOpen0440((BigDecimal)rs.getObject("NUMBER_OPEN_0440"))
                    .setRowid((byte[])rs.getObject("ROWID"));
                } else {
                    throw new ResourceNotFoundException("JOB");
                }
            }
        }
        return job;
    }

    /**
     * SELECT a result set from the JOB table
     * @return Job array containing the contents of the result set
     */
    public List<Job> query(String datasource)
        throws DataSourceNotFoundException, ResourceNotFoundException, SQLException {
        log.debug("JobService.query({})", datasource);

        List<Job> array = new ArrayList<Job>();
        try(Connection conn = dataSourceRouter.getConnection(datasource);
            PreparedStatement stmt = conn.prepareStatement(SQL_SELECT);) {
            try(ResultSet rs = stmt.executeQuery();) {
                while (rs.next()) {
                    Job job = new Job();
                    job
                    .setJobId0440((BigDecimal)rs.getObject("JOB_ID_0440"))
                    .setTitle0440((String)rs.getObject("TITLE_0440"))
                    .setDescriptionLine04401((String)rs.getObject("DESCRIPTION_LINE_0440_1"))
                    .setDescriptionLine04402((String)rs.getObject("DESCRIPTION_LINE_0440_2"))
                    .setRequirementLine04401((String)rs.getObject("REQUIREMENT_LINE_0440_1"))
                    .setRequirementLine04402((String)rs.getObject("REQUIREMENT_LINE_0440_2"))
                    .setMinimumSalary0440((BigDecimal)rs.getObject("MINIMUM_SALARY_0440"))
                    .setMaximumSalary0440((BigDecimal)rs.getObject("MAXIMUM_SALARY_0440"))
                    .setSalaryGrades04401((BigDecimal)rs.getObject("SALARY_GRADES_0440_1"))
                    .setSalaryGrades04402((BigDecimal)rs.getObject("SALARY_GRADES_0440_2"))
                    .setSalaryGrades04403((BigDecimal)rs.getObject("SALARY_GRADES_0440_3"))
                    .setSalaryGrades04404((BigDecimal)rs.getObject("SALARY_GRADES_0440_4"))
                    .setNumberOfPositions0440((BigDecimal)rs.getObject("NUMBER_OF_POSITIONS_0440"))
                    .setNumberOpen0440((BigDecimal)rs.getObject("NUMBER_OPEN_0440"))
                    .setRowid((byte[])rs.getObject("ROWID"));
                    array.add(job);
                }
            }
        }
        return array;
    }
}
