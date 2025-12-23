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
@Schema(name="Empschm Employee",description = "Represents a row in the EMPSCHM.EMPLOYEE table")
public class Employee {
     @Schema(description = "SQL column EMP_ID_0415", example = "null", nullable = true)
     @JsonProperty("empId0415")
     private BigDecimal empId0415;

     @Schema(description = "SQL column EMP_FIRST_NAME_0415", example = "null", nullable = true)
     @JsonProperty("empFirstName0415")
     private String empFirstName0415;

     @Schema(description = "SQL column EMP_LAST_NAME_0415", example = "null", nullable = true)
     @JsonProperty("empLastName0415")
     private String empLastName0415;

     @Schema(description = "SQL column EMP_STREET_0415", example = "null", nullable = true)
     @JsonProperty("empStreet0415")
     private String empStreet0415;

     @Schema(description = "SQL column EMP_CITY_0415", example = "null", nullable = true)
     @JsonProperty("empCity0415")
     private String empCity0415;

     @Schema(description = "SQL column EMP_STATE_0415", example = "null", nullable = true)
     @JsonProperty("empState0415")
     private String empState0415;

     @Schema(description = "SQL column EMP_ZIP_FIRST_FIVE_0415", example = "null", nullable = true)
     @JsonProperty("empZipFirstFive0415")
     private String empZipFirstFive0415;

     @Schema(description = "SQL column EMP_ZIP_LAST_FOUR_0415", example = "null", nullable = true)
     @JsonProperty("empZipLastFour0415")
     private String empZipLastFour0415;

     @Schema(description = "SQL column EMP_PHONE_0415", example = "null", nullable = true)
     @JsonProperty("empPhone0415")
     private BigDecimal empPhone0415;

     @Schema(description = "SQL column STATUS_0415", example = "null", nullable = true)
     @JsonProperty("status0415")
     private String status0415;

     @Schema(description = "SQL column SS_NUMBER_0415", example = "null", nullable = true)
     @JsonProperty("ssNumber0415")
     private BigDecimal ssNumber0415;

     @Schema(description = "SQL column START_YEAR_0415", example = "null", nullable = true)
     @JsonProperty("startYear0415")
     private BigDecimal startYear0415;

     @Schema(description = "SQL column START_MONTH_0415", example = "null", nullable = true)
     @JsonProperty("startMonth0415")
     private BigDecimal startMonth0415;

     @Schema(description = "SQL column START_DAY_0415", example = "null", nullable = true)
     @JsonProperty("startDay0415")
     private BigDecimal startDay0415;

     @Schema(description = "SQL column TERMINATION_YEAR_0415", example = "null", nullable = true)
     @JsonProperty("terminationYear0415")
     private BigDecimal terminationYear0415;

     @Schema(description = "SQL column TERMINATION_MONTH_0415", example = "null", nullable = true)
     @JsonProperty("terminationMonth0415")
     private BigDecimal terminationMonth0415;

     @Schema(description = "SQL column TERMINATION_DAY_0415", example = "null", nullable = true)
     @JsonProperty("terminationDay0415")
     private BigDecimal terminationDay0415;

     @Schema(description = "SQL column BIRTH_YEAR_0415", example = "null", nullable = true)
     @JsonProperty("birthYear0415")
     private BigDecimal birthYear0415;

     @Schema(description = "SQL column BIRTH_MONTH_0415", example = "null", nullable = true)
     @JsonProperty("birthMonth0415")
     private BigDecimal birthMonth0415;

     @Schema(description = "SQL column BIRTH_DAY_0415", example = "null", nullable = true)
     @JsonProperty("birthDay0415")
     private BigDecimal birthDay0415;

     @Schema(description = "SQL column ROWID", example = "null", nullable = true)
     @JsonProperty("rowid")
     private byte[] rowid;

     @Schema(description = "SQL column FKEY_DEPT_EMPLOYEE", example = "null", nullable = true)
     @JsonProperty("fkeyDeptEmployee")
     private byte[] fkeyDeptEmployee;

     @Schema(description = "SQL column FKEY_OFFICE_EMPLOYEE", example = "null", nullable = true)
     @JsonProperty("fkeyOfficeEmployee")
     private byte[] fkeyOfficeEmployee;
}
