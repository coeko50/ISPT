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

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import java.math.*;    // for data types
import java.sql.*;     // for data types

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.AllArgsConstructor;
import lombok.experimental.Accessors;

/**
 * Defines the JSON equivalent of the SQL table, view, or procedure
 *
 * @author Broadcom Database API Generator
 * @since 1.0
 */
@Data
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor
@Schema(name="Empschm Job",description = "Represents a row in the EMPSCHM.JOB table")
public class Job {
     @Schema(description = "SQL column JOB_ID_0440", example = "null", nullable = true)
     @JsonProperty("jobId0440")
     private BigDecimal jobId0440;

     @Schema(description = "SQL column TITLE_0440", example = "null", nullable = true)
     @JsonProperty("title0440")
     private String title0440;

     @Schema(description = "SQL column DESCRIPTION_LINE_0440_1", example = "null", nullable = true)
     @JsonProperty("descriptionLine04401")
     private String descriptionLine04401;

     @Schema(description = "SQL column DESCRIPTION_LINE_0440_2", example = "null", nullable = true)
     @JsonProperty("descriptionLine04402")
     private String descriptionLine04402;

     @Schema(description = "SQL column REQUIREMENT_LINE_0440_1", example = "null", nullable = true)
     @JsonProperty("requirementLine04401")
     private String requirementLine04401;

     @Schema(description = "SQL column REQUIREMENT_LINE_0440_2", example = "null", nullable = true)
     @JsonProperty("requirementLine04402")
     private String requirementLine04402;

     @Schema(description = "SQL column MINIMUM_SALARY_0440", example = "null", nullable = true)
     @JsonProperty("minimumSalary0440")
     private BigDecimal minimumSalary0440;

     @Schema(description = "SQL column MAXIMUM_SALARY_0440", example = "null", nullable = true)
     @JsonProperty("maximumSalary0440")
     private BigDecimal maximumSalary0440;

     @Schema(description = "SQL column SALARY_GRADES_0440_1", example = "null", nullable = true)
     @JsonProperty("salaryGrades04401")
     private BigDecimal salaryGrades04401;

     @Schema(description = "SQL column SALARY_GRADES_0440_2", example = "null", nullable = true)
     @JsonProperty("salaryGrades04402")
     private BigDecimal salaryGrades04402;

     @Schema(description = "SQL column SALARY_GRADES_0440_3", example = "null", nullable = true)
     @JsonProperty("salaryGrades04403")
     private BigDecimal salaryGrades04403;

     @Schema(description = "SQL column SALARY_GRADES_0440_4", example = "null", nullable = true)
     @JsonProperty("salaryGrades04404")
     private BigDecimal salaryGrades04404;

     @Schema(description = "SQL column NUMBER_OF_POSITIONS_0440", example = "null", nullable = true)
     @JsonProperty("numberOfPositions0440")
     private BigDecimal numberOfPositions0440;

     @Schema(description = "SQL column NUMBER_OPEN_0440", example = "null", nullable = true)
     @JsonProperty("numberOpen0440")
     private BigDecimal numberOpen0440;

     @Schema(description = "SQL column ROWID", example = "null", nullable = true)
     @JsonProperty("rowid")
     private byte[] rowid;
}
