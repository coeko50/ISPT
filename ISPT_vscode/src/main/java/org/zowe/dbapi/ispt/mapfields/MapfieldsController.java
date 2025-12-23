/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.ispt.mapfields;

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
 * Defines the REST API for the SQL.MAPFIELDS view
 *
 * @author Zowe Database API Generator
 * @since 1.0
 */
@RestController("IsptMapfieldsController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(
   name = "Mapfields for an idms map",
   description = "ispt.MAPFIELDS view API"
)
public class MapfieldsController {

    @Autowired
    private MapfieldsService service;

    @GetMapping("/ispt/mapfields/keys/{datasource}")
    @Operation(
        summary = "Retrieve all key values from the ispt.MAPFIELDS view",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = MapfieldsKeys.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<MapfieldsKeys> MapfieldsKeys(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource) throws Exception {
        log.debug("queryMapfieldsKeys({})", datasource);
        datasource = datasource.toUpperCase();
        List<MapfieldsKeys> mapfieldskeys = service.keys(datasource);
        return mapfieldskeys;
    }

    @GetMapping("/ispt/mapfields/{datasource}/{map}")
    @Operation(
        summary = "Retrieve a single row from the SQL.MAPFIELDS view",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = Mapfields.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public Mapfields getMapfields(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "map", description = "MAPFIELDS column MAP", required = true, example = "12345678")
        @PathVariable("map") String map) throws Exception {
        log.debug("getMapfields({}, {})", datasource, map);
        datasource = datasource.toUpperCase();
        Mapfields mapfields = service.get(datasource, map);
        return mapfields;
    }

    @GetMapping("/ispt/mapfields/{datasource}")
    @Operation(
        summary = "Retrieve all rows from the ispt.MAPFIELDS view that satisfy the query parameters",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            array = @ArraySchema(schema = @Schema(implementation = Mapfields.class)))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public List<Mapfields> queryMapfields(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name ="map",description = "MAP Name", example = "LDM54M01")
        @RequestParam String map,
        @Parameter(name ="mapver",description = "MAP version", example = "1")
        @RequestParam (value ="mapver",defaultValue = "1",required = true) Short mapver
       ) throws Exception {
        log.debug("queryMapfields({}, {} {})", datasource, map, mapver);
        datasource = datasource.toUpperCase();
        List<Mapfields> mapfields = service.query(datasource, map, mapver);
        return mapfields;
    }
}
