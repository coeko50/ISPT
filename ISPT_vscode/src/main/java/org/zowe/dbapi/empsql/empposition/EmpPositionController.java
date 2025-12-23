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
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Defines the REST API for the EMPSQL.EMP_POSITION view
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@RestController("EmpsqlEmpPositionController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(
   name = "Empsql EmpPosition",
   description = "EMPSQL.EMP_POSITION view API"
)
public class EmpPositionController {

    @Autowired
    private EmpPositionService service;

    @GetMapping("/empsql/empPosition/{datasource}")
    @Operation(
        summary = "Retrieve all rows from the EMPSQL.EMP_POSITION view",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = EmpPosition.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<EmpPosition> queryEmpPosition(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource) throws Exception {
        log.debug("queryEmpPosition({})", datasource);
        datasource = datasource.toUpperCase();
        List<EmpPosition> empposition = service.query(datasource);
        return empposition;
    }
}
