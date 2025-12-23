/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.adsDemo.employee;

import static com.broadcom.restapi.sdk.apidoc.ApiDocConstants.DOC_SCHEME_BASIC_AUTH;

import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
//import io.swagger.v3.oas.annotations.media.ArraySchema;
import org.springframework.http.MediaType;

import java.math.*;    // for parameter types
//import java.sql.*;     // for parameter types
//import org.springframework.format.annotation.DateTimeFormat;
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//import java.time.LocalTime;
//import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Defines the REST API for the dialog EMPINQD
 *
 * @author Zowe Database API Generator + manual
 * @since 1.0
 */
@RestController("AdsDemoEmployeeController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(
   name = "adsDemo Employee",
   description = "REST API example showcasing ADS Dialog data Retrieval and Update"
)
public class EmployeeController {

    @Autowired
    private EmployeeService service;

 
    @GetMapping("/adsDemo/employee/info/{datasource}/{empId}")
    @Operation(
        summary = "Use EMPINQD dialog to retrieve Employee info for a specific EMPID",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = String.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public String getEmployeeInfo(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "empId", description = "EMPLOYEE EMP_ID", required = true, example = "1234")
        @PathVariable("empId") BigDecimal empId) throws Exception {
        log.debug("getEmployeeInfo({}, {})", datasource, empId);
        datasource = datasource.toUpperCase();
        String employeeJson = service.getEmpInfo(datasource, empId);
        return employeeJson;
    }
    @GetMapping("/adsDemo/employee/{datasource}/{empId}")
    @Operation(
        summary = "Use EMPMOD dialog to retrieve Employee for modification",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = String.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public String getEmployee(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "empId", description = "EMPLOYEE EMP_ID", required = true, example = "1234")
        @PathVariable("empId") BigDecimal empId) throws Exception {
        log.debug("getEmployee({}, {})", datasource, empId);
        datasource = datasource.toUpperCase();
        String employeeJson = service.get(datasource, empId);
        return employeeJson;
    }

    @PostMapping("/adsDemo/employee/{datasource}/{empId}")
    @Operation(
        summary = "Use EMPMOD dialog to update Employee info for a specific EMPID",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = String.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public String postEmployee(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "empId", description = "EMPLOYEE EMP_ID", required = true, example = "1234")
        @PathVariable("empId") BigDecimal empId, 
        @Parameter(name = "empStreet", description = "Employee Street name", required = false, example = "Affie Straat")
         @RequestParam (value ="empStreet",defaultValue = "' '",required = false) String empStreet,
        @Parameter(name = "empCity", description = "Employee home City name", required = false, example = "Boggemsfontein")
        @RequestParam (value ="empCity",defaultValue = "' '",required = false)  String empCity,
        @Parameter(name = "empState", description = "Employee home State code", required = false, example = "")
        @RequestParam (value ="empState",defaultValue = "' '",required = false)  String empState,
        @Parameter(name = "empZip", description = "Employee home address Zip Code", required = false, example = "")
        @RequestParam (value ="empZip",defaultValue = "' '",required = false)  String empZip
      
        ) throws Exception {
        log.debug("postEmployee({}, {} - {} {} {} {})", datasource, empId,empStreet,empCity,empState,empZip);
        datasource = datasource.toUpperCase();
        Employee employee = new Employee();
        employee.setEmpId(empId);
        if (empStreet != null) {
            employee.setStreet(empStreet);
        }
        if (empCity != null) {
            employee.setCity (empCity );
        }
        if (empState != null) {
            employee.setState(empState);
        }
        if (empZip != null) {
            employee.setZipCode(empZip) ;
        }
        String employeeJson = service.post(datasource,  employee);
        return employeeJson;
    }

    
}
