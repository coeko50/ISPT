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
 * Defines the REST API for the EMPSCHM.JOB table
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@RestController("EmpschmJobController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(
   name = "Empschm Job",
   description = "EMPSCHM.JOB table API"
)
public class JobController {

    @Autowired
    private JobService service;

    @GetMapping("/empschm/job/keys/{datasource}")
    @Operation(
        summary = "Retrieve all key values from the EMPSCHM.JOB table",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = JobKeys.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<JobKeys> JobKeys(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource) throws Exception {
        log.debug("queryJobKeys({})", datasource);
        datasource = datasource.toUpperCase();
        List<JobKeys> jobkeys = service.keys(datasource);
        return jobkeys;
    }

    @GetMapping("/empschm/job/{datasource}/{jobId0440}")
    @Operation(
        summary = "Retrieve a single row from the EMPSCHM.JOB table",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = Job.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public Job getJob(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "jobId0440", description = "JOB CALC key column JOB_ID_0440", required = true, example = "1234")
        @PathVariable("jobId0440") BigDecimal jobId0440) throws Exception {
        log.debug("getJob({}, {})", datasource, jobId0440);
        datasource = datasource.toUpperCase();
        Job job = service.get(datasource, jobId0440);
        return job;
    }

    @GetMapping("/empschm/job/{datasource}")
    @Operation(
        summary = "Retrieve all rows from the EMPSCHM.JOB table",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = Job.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<Job> queryJob(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource) throws Exception {
        log.debug("queryJob({})", datasource);
        datasource = datasource.toUpperCase();
        List<Job> job = service.query(datasource);
        return job;
    }
}
