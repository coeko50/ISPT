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
@Schema(name="Sql Record",description = "Represents a row in the SQL.RECORD view")
public class Record {
 
      @Schema(description = "SQL column jsonRec", example = "null", nullable = true)
     @JsonProperty("jsonRec")
    private String jsonRec;
     @Schema(description = "SQL column jrecVer", example = "null", nullable = true)
     @JsonProperty("jrecVer")
    private Short jrecVer;
     @Schema(description = "SQL column jsonfld", example = "null", nullable = true)
     @JsonProperty("jsonfld")
    private String jsonfld;
     @Schema(description = "SQL column rec", example = "null", nullable = true)
     @JsonProperty("rec")
    private String rec;
     @Schema(description = "SQL column recVer", example = "null", nullable = true)
     @JsonProperty("recVer")
    private Short recVer;
     @Schema(description = "SQL column ELE", example = "null", nullable = true)
     @JsonProperty("ele")
    private String ele;
     @Schema(description = "SQL column seq", example = "null", nullable = true)
     @JsonProperty("seq")
    private Integer seq;
     @Schema(description = "SQL column lvl", example = "null", nullable = true)
     @JsonProperty("lvl")
    private Short lvl;
     @Schema(description = "SQL column isGrp", example = "null", nullable = true)
     @JsonProperty("isGrp")
    private String isGrp;
     @Schema(description = "SQL column pos", example = "null", nullable = true)
     @JsonProperty("pos")
    private Short  pos;
     @Schema(description = "SQL column dtype", example = "null", nullable = true)
     @JsonProperty("dtype")
    private Short  dtype;
     @Schema(description = "SQL column mode", example = "null", nullable = true)
     @JsonProperty("mode")
    private Short mode;
     @Schema(description = "SQL column len", example = "null", nullable = true)
     @JsonProperty("len")
    private Short  len;
     @Schema(description = "SQL column dlen", example = "null", nullable = true)
     @JsonProperty("dlen")
    private Short  dlen;
     @Schema(description = "SQL column prec", example = "null", nullable = true)
     @JsonProperty("prec")
    private Short  prec;
      @Schema(description = "SQL column scale", example = "null", nullable = true)
     @JsonProperty("scale")
   private Short  scale;
     @Schema(description = "SQL column occ", example = "null", nullable = true)
     @JsonProperty("occ")
   private Short occ;
   @Schema(description = "Occurs depeding on element", example = "null", nullable = true)
   @JsonProperty("occDependEle")
  private String occDependEle;
 @Schema(description = "SQL column occLvl", example = "null", nullable = true)
     @JsonProperty("occLvl")
   private Short  occLvl;
     @Schema(description = "SQL column redefLvl", example = "null", nullable = true)
     @JsonProperty("redefLvl")
    private Short redefLvl;
     @Schema(description = "SQL column redefEle", example = "null", nullable = true)
     @JsonProperty("redefEle")
    private Integer redefEle;
     @Schema(description = "SQL column desc", example = "null", nullable = true)
     @JsonProperty("desc")
    private String desc;
     @Schema(description = "SQL column picture", example = "null", nullable = true)
     @JsonProperty("picture")
    private String picture;
    @Schema(description = "SQL column prefix", example = "null", nullable = true)
    @JsonProperty("prefix")
   private String prefix;
   @Schema(description = "ISPT internal picture", example = "null", nullable = true)
   @JsonProperty("udc")
  private String udc;
  @Schema(description = "UDC value", example = "null", nullable = true)
  @JsonProperty("udcval")
 private String udcval;

 }
