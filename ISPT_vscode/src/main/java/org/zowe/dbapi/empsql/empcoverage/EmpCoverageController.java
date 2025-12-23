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

import static com.broadcom.restapi.sdk.apidoc.ApiDocConstants.DOC_SCHEME_BASIC_AUTH;

import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
import io.swagger.v3.oas.annotations.media.ArraySchema;
import org.springframework.http.MediaType;

import java.math.*;    // for parameter types
import java.sql.*;     // for parameter types
import org.springframework.format.annotation.DateTimeFormat;
import java.time.LocalDate;
import java.time.LocalDateTime;
import java.time.LocalTime;
import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Defines the REST API for the EMPSQL.EMP_COVERAGE table
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@RestController("EmpsqlEmpCoverageController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(
   name = "Empsql EmpCoverage",
   description = "EMPSQL.EMP_COVERAGE table API"
)
public class EmpCoverageController {

    @Autowired
    private EmpCoverageService service;

    @GetMapping("/empsql/empCoverage/keys/{datasource}")
    @Operation(
        summary = "Retrieve all key values from the EMPSQL.EMP_COVERAGE table",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = EmpCoverageKeys.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<EmpCoverageKeys> EmpCoverageKeys(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource) throws Exception {
        log.debug("queryEmpCoverageKeys({})", datasource);
        datasource = datasource.toUpperCase();
        List<EmpCoverageKeys> empcoveragekeys = service.keys(datasource);
        return empcoveragekeys;
    }

    @GetMapping("/empsql/empCoverage/{datasource}/{empId}")
    @Operation(
        summary = "Retrieve the coverage history for an emp using the EMPSQL.EMP_COVERAGE table",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = EmpCoverage.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<EmpCoverage> getEmpCoverage(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "empId", description = "EMP_COVERAGE EMPCOVRG_KEY EMP_ID", required = true, example = "0023")
        @PathVariable("empId") BigDecimal empId
        ) throws Exception {
        log.debug("getEmpCoverage({}, {} )", datasource, empId );
        datasource = datasource.toUpperCase();
        List<EmpCoverage> empcoverages = service.get(datasource, empId );
        return empcoverages;
    }

    @GetMapping("/empsql/empCoverage/{datasource}")
    @Operation(
        summary = "Retrieve all rows from the EMPSQL.EMP_COVERAGE table",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = EmpCoverage.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<EmpCoverage> queryEmpCoverage(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource) throws Exception {
        log.debug("queryEmpCoverage({})", datasource);
        datasource = datasource.toUpperCase();
        List<EmpCoverage> empcoverage = service.query(datasource);
        return empcoverage;
    }

    /* 
 * Code insersion starts
 * Code the POST and PUT operations manually
 */
    @PostMapping("/empsql/empCoverage/{datasource}")
    @Operation(summary = "insert new coverage into EMPSQL.EMP_COVERAGE table", security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
    })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "OK", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = EmpCoverage.class))),
            @ApiResponse(responseCode = "400", description = "Bad request", content = @Content),
            @ApiResponse(responseCode = "401", description = "Authentication is required", content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden", content = @Content),
            @ApiResponse(responseCode = "404", description = "Not Found", content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
    })
    public int postEmpCoverage(
            @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO") @PathVariable("datasource") String datasource,
            @Parameter(name = "empId", description = "EMP_COVERAGE primary key column EMP_ID", required = true, example = "0023") 
              @RequestParam (value ="empId",defaultValue = "' '",required = true) BigDecimal empId,
            @Parameter(name = "selDate", description = "SELECTION_DATE", example = "2023-05-12",  required = true)
              @RequestParam (value ="selDate",defaultValue = "' '",required = true) Date selDate,
            @Parameter(name = "termDate", description = "Termination DATE", example = "2024-11-27", required = true) 
              @RequestParam (value ="termDate",defaultValue = "' '",required = true) Date termDate,
            @Parameter(name = "typeCode", description = "Type of insurance", example = "F", required  = true) 
              @RequestParam (value ="typeCode",defaultValue = "' '",required = true) String typeCode,
            @Parameter(name = "insPlanCode", description = "Insurance plan code", example = "001", required  = true) 
              @RequestParam (value ="insPlanCode",defaultValue = "' '",required = true) String insPlanCode
  
            ) throws Exception {
        log.debug("postEmpCoverage({}, {})", datasource, empId);
        datasource = datasource.toUpperCase();
        int rowsInserted = service.post(datasource, empId,selDate,termDate,typeCode,insPlanCode);
        return rowsInserted;
    }

    @PutMapping("/empsql/empCoverage/{datasource}/{empId}")
    @Operation(summary = "Maintain EMPSQL.EMP_COVERAGE table", security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
    })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "OK", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = EmpCoverage.class))),
            @ApiResponse(responseCode = "400", description = "Bad request", content = @Content),
            @ApiResponse(responseCode = "401", description = "Authentication is required", content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden", content = @Content),
            @ApiResponse(responseCode = "404", description = "Not Found", content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
    })
    public int putEmpCoverage(
          @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO") @PathVariable("datasource") String datasource,
          @Parameter(name = "empId", description = "EMP_COVERAGE EMPCOVRG_KEY primary key column EMP_ID", required = true, example = "2023") 
            @PathVariable("empId")
            @RequestParam (value ="empId",defaultValue = "' '",required = true) BigDecimal empId,
          @Parameter(name = "selDate", description = "SELECTION_DATE", example = "2023-05-12",  required = false)
            @RequestParam (value ="selDate",defaultValue = "' '",required = false) Date selDate,
          @Parameter(name = "termDate", description = "Termination DATE", example = "2024-11-27", required = false) 
            @RequestParam (value ="termDate",defaultValue = "' '",required = false) Date termDate,
          @Parameter(name = "typeCode", description = "Type of insurance", example = "F", required  = false)
            @RequestParam (value ="typeCode" ,required = false) String typeCode,
          @Parameter(name = "insPlanCode", description = "Insurance plan code", example = "001", required  = false) 
            @RequestParam (value ="insPlanCode", required = false) String insPlanCode,
          @Parameter(name = "occNbr", description = "set occurance to update", example = "03", required  = true)
             @RequestParam (value ="occNbr",defaultValue = "null",required = false)  BigDecimal occNbr 

            ) throws Exception {
        log.debug("putEmpCoverage({}, {})", datasource, empId);
        datasource = datasource.toUpperCase();
        int rowsUpdated = service.put(datasource, empId,selDate,termDate,typeCode,insPlanCode,occNbr);
        return rowsUpdated;
    }
/*
 * Code insersion ends
 */
}
