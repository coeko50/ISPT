/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.ispt.record;

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
import org.springframework.web.bind.annotation.PostMapping;
/**
 * Defines the REST API for the ISPT.RECORD view
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@RestController("IsptRecordController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(
   name = "IDD Record",
   description = "ISPT.RECORD view API"
)
public class RecordController {

    @Autowired
    private RecordService service;

    @GetMapping("/ispt/retrieveRecord/{datasource}/{loadmod}/{map}")
    @Operation(
        summary = "Retrieve Records used by map(s)",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = String.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<String> RetrieveRecords(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "APIDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "loadmod", description = "Json to IDMS Record mapping loadmodule name", required = true, example = "ISPTJLOD")
        @PathVariable("loadmod") String loadmod,
       @Parameter(name = "map", description = "Map name(s) that form(s) the transaction (single name or comma delimited list)", required = true, example = "ISPTMLOD")
        @PathVariable("map") String map,
         @Parameter(name = "mapVersion", description = "Map Version", required = false, example = "1")
        @RequestParam (value ="mapVersion",defaultValue = "1",required = false)  Short mapver,
        @Parameter(name = "path", description = "path for generated artefacts", required = false, example = "/Users/coeko50/Documents/GitHub/IDMS_RestApi/dbapi-demo/src/main/java/org/zowe/dbapi/isptJsonSchema/restapi/projec") 
        @RequestParam(value="path",required = false) String path 
       
        ) throws Exception {
 // "./project or c:/restapi/project") 
        log.debug("build JsonSchema for Maprecords({}, {} {} {})", datasource, map, mapver, path);
          
        datasource = datasource.toUpperCase();
        List<String> jsonSchema = service.jsonSchema4mapRecords(datasource,loadmod,map,mapver,path);
        return jsonSchema;
    }
 


    @PostMapping("/ispt/generateJsonSchema/{datasource}/{transaction}")
    @Operation(
        summary = "Generate Rest API Service schema and IDMS mapping loadmodule",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = String.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<String> genJsonSchema(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "APIDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "transaction", description = "Transaction name for this service (will become the Json schema name)", required = false, example = "JobStandardController")
        @PathVariable("transaction") String schema,         
        @Parameter(name = "path", description = "path for generated artefacts", required = true, example = "./project or c:/restapi/project")
        @RequestParam(value="path",required = false) String path ,
        @Parameter(name = "mappingFile", description = "file containing the mapping selections", required = true, example = "name.txt")
        @RequestParam(value="mappingFile",required = false) String mappingFile
     
        ) throws Exception {
 
        log.debug("build JsonSchema for Maprecords({}, {} {})", datasource, schema, path,mappingFile);
          
        datasource = datasource.toUpperCase();
        List<String> jsonSchema = service.generateJsonSchema(datasource,schema,path,mappingFile);
        return jsonSchema;
    }
}
