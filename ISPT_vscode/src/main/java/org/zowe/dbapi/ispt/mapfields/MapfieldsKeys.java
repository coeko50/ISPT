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
 * Defines the JSON equivalent of the SQL table or view keys.
 *
 * @author Broadcom Database API Generator
 * @since 1.0
 */
@Data
@Accessors(chain = true)
@NoArgsConstructor
@AllArgsConstructor

@Schema(name="Sql MapfieldsKeys",description = "Represents the primary or selected unique keys for the SQL.MAPFIELDS view")
public class MapfieldsKeys {
     @Schema(description = "SQL column MAP", example = "null", nullable = true)
     @JsonProperty("map")
     private String map;
}
