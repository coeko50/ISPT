package org.zowe.dbapi.eafDemo.LDM54;

import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
//import java.math.*;    // for data types
//import java.sql.*;     // for data types

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
@Schema(name="LDM54 Cscrnw01",description = "Map work record - read only")

public class Cscrnw01 {

@Schema(description="page_nr",example = "null", nullable = true)
@JsonProperty("page_nr")
private String page_nr;


@Schema(description="page_nr_last",example = "null", nullable = true)
@JsonProperty("page_nr_last")
private String page_nr_last;


@Schema(description="date_screen",example = "null", nullable = true)
@JsonProperty("date_screen")
private String date_screen;

@Schema(description="time_screen",example = "null", nullable = true)
@JsonProperty("time_screen")
private String time_screen;

@Schema(description="pgm_id",example = "null", nullable = true)
@JsonProperty("pgm_id")
private String pgm_id;



@Schema(description="rqstr_id",example = "null", nullable = true)
@JsonProperty("rqstr_id")
private String      rqstr_id;


@Schema(description="trnsn_cmpltn_code",example = "null", nullable = true)
@JsonProperty("trnsn_cmpltn_code")
private String trnsn_cmpltn_code;


@Schema(description="jul_date",example = "null", nullable = true)
@JsonProperty("jul_date")
private String jul_date;

@Schema(description="cal_date",example = "null", nullable = true)
@JsonProperty("cal_date")
private String cal_date;
 
@Schema(description="sys_date",example = "null", nullable = true)
@JsonProperty("sys_date")
private String sys_date;
 
@Schema(description="sys_time",example = "null", nullable = true)
@JsonProperty("sys_time")
private String sys_time;
         }
