package org.zowe.dbapi.eafDemo.LDM54;

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
@Schema(name="SCL1P JobStandardInfo",description = "Represents a JobStandard row ")
public class JobStandardInfo{
     @Schema(description = "PAGE NUMBER DISPLAYED ON SCREEN", example = "null", nullable = true)
     @JsonProperty("cscrnw01_page_nr")
     private BigDecimal cscrnw01_page_nr;
     
     @Schema(description = "SCREEN DISPLAY - DATE", example = "null", nullable = true)
     @JsonProperty("cscrnw01_date_screen")
     private String cscrnw01_date_screen;
     
     @Schema(description = "SCREEN DISPLAY - TIME", example = "null", nullable = true)
     @JsonProperty("cscrnw01_time_screen")
     private String cscrnw01_time_screen;
     
     @Schema(description = "JULIAN DAYS", example = "null", nullable = true)
     @JsonProperty("cscrnw01_jul_ddd")
     private BigDecimal cscrnw01_jul_ddd;
     
     @Schema(description = "ORGANIZATION CODE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_user_orgnztn")
     private String ldm54wm1_user_orgnztn;
     
     @Schema(description = "JOB STANDARD NUMBER", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_job_std_nr")
     private String ldm54wm1_job_std_nr;
     
     @Schema(description = "JOB STANDARD DESCRIPTION", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_job_std_dscrptn")
     private String ldm54wm1_job_std_dscrptn;
     
     @Schema(description = "TYPE MAINTENANCE CODE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_type_maint_code")
     private String ldm54wm1_type_maint_code;
     
     @Schema(description = "JOB DESIGNATOR CODE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_job_dsgntr_code")
     private String ldm54wm1_job_dsgntr_code;
     
     @Schema(description = "LEVEL OF MAINTENANCE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_lvl_maint")
     private String ldm54wm1_lvl_maint;
     
     @Schema(description = "TCTO NUMBER", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_tcto_nr")
     private String ldm54wm1_tcto_nr;
     
     @Schema(description = "OPERATING INTERVAL CODE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_oprtg_intvl_code")
     private String ldm54wm1_oprtg_intvl_code;
     
     @Schema(description = "OPERATING INTERVAL BASE VALUE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_oprtg_intvl_base_val")
     private BigDecimal ldm54wm1_oprtg_intvl_base_val;
     
     @Schema(description = "CALENDAR DAY", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_base_val_lw_tolr")
     private BigDecimal ldm54wm1_base_val_lw_tolr;
     
     @Schema(description = "CALENDAR DAY", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_base_val_up_tolr")
     private BigDecimal ldm54wm1_base_val_up_tolr;
     
     @Schema(description = "INTERVAL FREQUENCY", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_intvl_freq")
     private BigDecimal ldm54wm1_intvl_freq;
     
     @Schema(description = "CALENDAR DAY", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_freq_lw_tolr")
     private BigDecimal ldm54wm1_freq_lw_tolr;
     
     @Schema(description = "CALENDAR DAY", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_freq_up_tolr")
     private BigDecimal ldm54wm1_freq_up_tolr;
     
     @Schema(description = "BASIS FOR ALGORITHM", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_bas_for_algor")
     private String ldm54wm1_bas_for_algor;
     
     @Schema(description = "EQUIPMENT DESIGNATOR", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_eqpmt_dsgntr_aff")
     private String ldm54wm1_eqpmt_dsgntr_aff;
     
     @Schema(description = "WORK UNIT CODE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_wrk_unt_code")
     private String ldm54wm1_wrk_unt_code;
     
     @Schema(description = "EQUIPMENT DESIGNATOR", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_eqpmt_dsgntr_tbm")
     private String ldm54wm1_eqpmt_dsgntr_tbm;
     
     @Schema(description = "FEDERAL SUPPLY CODE FOR MANUFACTURER (FSCM)", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_fscm")
     private String ldm54wm1_fscm;
     
     @Schema(description = "PART NUMBER", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_prt_nr")
     private String ldm54wm1_prt_nr;
     
     @Schema(description = "WORK AREA CODE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_wrk_ar_code")
     private String ldm54wm1_wrk_ar_code;
     
     @Schema(description = "ORGANIZATION CODE", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_orgnztn_code")
     private String ldm54wm1_orgnztn_code;
     
     @Schema(description = "", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_tci_indctr")
     private String ldm54wm1_tci_indctr;
     
     @Schema(description = "", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_phase_ind")
     private String ldm54wm1_phase_ind;
     
     @Schema(description = "", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_prdcty_chng_ind")
     private String ldm54wm1_prdcty_chng_ind;
     
     @Schema(description = "", example = "null", nullable = true)
     @JsonProperty("ldm54wm1_oil_consumption_jsn")
     private String ldm54wm1_oil_consumption_jsn;
}
