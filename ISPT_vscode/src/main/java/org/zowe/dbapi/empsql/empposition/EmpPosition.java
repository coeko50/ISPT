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
@Schema(name="Empsql EmpPosition",description = "Represents a row in the EMPSQL.EMP_POSITION view")
public class EmpPosition {
     @Schema(description = "SQL column EMPID", example = "null", nullable = true)
     @JsonProperty("empid")
     private BigDecimal empid;

     @Schema(description = "SQL column FNAME", example = "null", nullable = true)
     @JsonProperty("fname")
     private String fname;

     @Schema(description = "SQL column LNAME", example = "null", nullable = true)
     @JsonProperty("lname")
     private String lname;

     @Schema(description = "SQL column DEPTID", example = "null", nullable = true)
     @JsonProperty("deptid")
     private BigDecimal deptid;

     @Schema(description = "SQL column DEPTNAME", example = "null", nullable = true)
     @JsonProperty("deptname")
     private String deptname;

     @Schema(description = "SQL column JOBID", example = "null", nullable = true)
     @JsonProperty("jobid")
     private BigDecimal jobid;

     @Schema(description = "SQL column JOBTITLE", example = "null", nullable = true)
     @JsonProperty("jobtitle")
     private String jobtitle;

     @Schema(description = "SQL column POS_START_DATE", example = "null", nullable = true)
     @JsonProperty("posStartDate")
     private Date posStartDate;

     @Schema(description = "SQL column POS_END_DATE", example = "null", nullable = true)
     @JsonProperty("posEndDate")
     private Date posEndDate;
}
