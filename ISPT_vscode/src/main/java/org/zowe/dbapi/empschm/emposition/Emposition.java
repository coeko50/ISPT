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
@Schema(name="Empschm Emposition",description = "Represents a row in the EMPSCHM.EMPOSITION table")
public class Emposition {
     @Schema(description = "SQL column START_YEAR_0420", example = "null", nullable = true)
     @JsonProperty("startYear0420")
     private BigDecimal startYear0420;

     @Schema(description = "SQL column START_MONTH_0420", example = "null", nullable = true)
     @JsonProperty("startMonth0420")
     private BigDecimal startMonth0420;

     @Schema(description = "SQL column START_DAY_0420", example = "null", nullable = true)
     @JsonProperty("startDay0420")
     private BigDecimal startDay0420;

     @Schema(description = "SQL column FINISH_YEAR_0420", example = "null", nullable = true)
     @JsonProperty("finishYear0420")
     private BigDecimal finishYear0420;

     @Schema(description = "SQL column FINISH_MONTH_0420", example = "null", nullable = true)
     @JsonProperty("finishMonth0420")
     private BigDecimal finishMonth0420;

     @Schema(description = "SQL column FINISH_DAY_0420", example = "null", nullable = true)
     @JsonProperty("finishDay0420")
     private BigDecimal finishDay0420;

     @Schema(description = "SQL column SALARY_GRADE_0420", example = "null", nullable = true)
     @JsonProperty("salaryGrade0420")
     private BigDecimal salaryGrade0420;

     @Schema(description = "SQL column SALARY_AMOUNT_0420", example = "null", nullable = true)
     @JsonProperty("salaryAmount0420")
     private BigDecimal salaryAmount0420;

     @Schema(description = "SQL column BONUS_PERCENT_0420", example = "null", nullable = true)
     @JsonProperty("bonusPercent0420")
     private BigDecimal bonusPercent0420;

     @Schema(description = "SQL column COMMISSION_PERCENT_0420", example = "null", nullable = true)
     @JsonProperty("commissionPercent0420")
     private BigDecimal commissionPercent0420;

     @Schema(description = "SQL column OVERTIME_RATE_0420", example = "null", nullable = true)
     @JsonProperty("overtimeRate0420")
     private BigDecimal overtimeRate0420;

     @Schema(description = "SQL column ROWID", example = "null", nullable = true)
     @JsonProperty("rowid")
     private byte[] rowid;

     @Schema(description = "SQL column FKEY_EMP_EMPOSITION", example = "null", nullable = true)
     @JsonProperty("fkeyEmpEmposition")
     private byte[] fkeyEmpEmposition;

     @Schema(description = "SQL column FKEY_JOB_EMPOSITION", example = "null", nullable = true)
     @JsonProperty("fkeyJobEmposition")
     private byte[] fkeyJobEmposition;
}
