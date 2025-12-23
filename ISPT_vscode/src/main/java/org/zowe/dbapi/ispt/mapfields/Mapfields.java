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
@Schema(name="Sql Mapfields",description = "Represents a row in the SQL.MAPFIELDS view")
public class Mapfields {
     @Schema(description = "SQL column REC", example = "null", nullable = true)
     @JsonProperty("rec")
     private String rec;

     @Schema(description = "SQL column RECVER", example = "null", nullable = true)
     @JsonProperty("recver")
     private Short recver;

     @Schema(description = "SQL column ELE", example = "null", nullable = true)
     @JsonProperty("ele")
     private String ele;

     @Schema(description = "SQL column UPDATEABLE", example = "null", nullable = true)
     @JsonProperty("updateable")
     private String updateable;

     @Schema(description = "SQL column REQUIRED", example = "null", nullable = true)
     @JsonProperty("required")
     private String required;
 
     @Schema(description = "SQL column SEQ", example = "null", nullable = true)
     @JsonProperty("seq")
     private Integer seq;

     @Schema(description = "SQL column LVL", example = "null", nullable = true)
     @JsonProperty("lvl")
     private Short lvl;

     @Schema(description = "SQL column PIC", example = "null", nullable = true)
     @JsonProperty("pic")
     private String pic;

     @Schema(description = "SQL column MAP", example = "null", nullable = true)
     @JsonProperty("map")
     private String map;
}
