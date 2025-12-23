package org.zowe.dbapi.adsDemo.employee;

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
@Schema(name="Demoempl Employee",description = "Represents a row in the DEMOEMPL.EMPLOYEE table")
public class Employee {
     @Schema(description = "SQL column EMP_ID", example = "null", nullable = true)
     @JsonProperty("empId")
     private BigDecimal empId;

     @Schema(description = "SQL column MANAGER_ID", example = "null", nullable = true)
     @JsonProperty("managerId")
     private BigDecimal managerId;

     @Schema(description = "SQL column EMP_FNAME", example = "null", nullable = true)
     @JsonProperty("empFname")
     private String empFname;

     @Schema(description = "SQL column EMP_LNAME", example = "null", nullable = true)
     @JsonProperty("empLname")
     private String empLname;

     @Schema(description = "SQL column DEPT_ID", example = "null", nullable = true)
     @JsonProperty("deptId")
     private BigDecimal deptId;

     @Schema(description = "SQL column STREET", example = "null", nullable = true)
     @JsonProperty("street")
     private String street;

     @Schema(description = "SQL column CITY", example = "null", nullable = true)
     @JsonProperty("city")
     private String city;

     @Schema(description = "SQL column STATE", example = "null", nullable = true)
     @JsonProperty("state")
     private String state;

     @Schema(description = "SQL column ZIP_CODE", example = "null", nullable = true)
     @JsonProperty("zipCode")
     private String zipCode;

     @Schema(description = "SQL column PHONE", example = "null", nullable = true)
     @JsonProperty("phone")
     private String phone;

     @Schema(description = "SQL column STATUS", example = "null", nullable = true)
     @JsonProperty("status")
     private String status;

     @Schema(description = "SQL column SS_NUMBER", example = "null", nullable = true)
     @JsonProperty("ssNumber")
     private BigDecimal ssNumber;

     @Schema(description = "SQL column START_DATE", example = "null", nullable = true)
     @JsonProperty("startDate")
     private Date startDate;

     @Schema(description = "SQL column TERMINATION_DATE", example = "null", nullable = true)
     @JsonProperty("terminationDate")
     private Date terminationDate;

     @Schema(description = "SQL column BIRTH_DATE", example = "null", nullable = true)
     @JsonProperty("birthDate")
     private Date birthDate;
}
