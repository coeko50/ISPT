package org.zowe.dbapi.eafDemo.LDM54;
 
import java.util.LinkedHashMap;
import java.util.List;
import java.util.Map;
import javax.annotation.Generated;
import javax.validation.Valid;
import javax.validation.constraints.DecimalMax;
import javax.validation.constraints.NotNull;

import com.fasterxml.jackson.annotation.JsonAnyGetter;
import com.fasterxml.jackson.annotation.JsonAnySetter;
import com.fasterxml.jackson.annotation.JsonIgnore;
import com.fasterxml.jackson.annotation.JsonInclude;
import com.fasterxml.jackson.annotation.JsonProperty;
import com.fasterxml.jackson.annotation.JsonPropertyDescription;
import com.fasterxml.jackson.annotation.JsonPropertyOrder;

@JsonInclude(JsonInclude.Include.NON_NULL)
 
@JsonPropertyOrder({
    "cscrnw01_page_nr",
    "cscrnw01_date_screen",
    "cscrnw01_time_screen",
    "cscrnw01_jul_ddd",
    "ldm54wm1_user_orgnztn",
    "ldm54wm1_job_std_nr",
    "ldm54wm1_job_std_dscrptn",
    "ldm54wm1_type_maint_code",
    "ldm54wm1_job_dsgntr_code",
    "ldm54wm1_lvl_maint",
    "ldm54wm1_tcto_nr",
    "ldm54wm1_oprtg_intvl_code",
    "ldm54wm1_oprtg_intvl_base_val",
    "ldm54wm1_base_val_lw_tolr",
    "ldm54wm1_base_val_up_tolr",
    "ldm54wm1_intvl_freq",
    "ldm54wm1_freq_lw_tolr",
    "ldm54wm1_freq_up_tolr",
    "ldm54wm1_bas_for_algor",
    "ldm54wm1_eqpmt_dsgntr_aff",
    "ldm54wm1_wrk_unt_code",
    "ldm54wm1_eqpmt_dsgntr_tbm",
    "ldm54wm1_fscm",
    "ldm54wm1_prt_nr",
    "ldm54wm1_wrk_ar_code",
    "ldm54wm1_orgnztn_code",
    "ldm54wm1_tci_indctr",
    "ldm54wm1_phase_ind",
    "ldm54wm1_prdcty_chng_ind",
    "ldm54wm1_oil_consumption_jsn"
    })
@Generated("jsonschema2pojo")
public class Ldm54wm1 {

/**
* PAGE NUMBER DISPLAYED ON SCREEN
*
*/
@JsonProperty("cscrnw01_page_nr")
@JsonPropertyDescription("PAGE NUMBER DISPLAYED ON SCREEN")
@DecimalMax("99")
private Integer cscrnw01PageNr = 0;
/**
* SCREEN DISPLAY - DATE
*
*/
@JsonProperty("cscrnw01_date_screen")
@JsonPropertyDescription("SCREEN DISPLAY - DATE")
private String cscrnw01DateScreen = "null";
/**
* SCREEN DISPLAY - TIME
*
*/
@JsonProperty("cscrnw01_time_screen")
@JsonPropertyDescription("SCREEN DISPLAY - TIME")
private String cscrnw01TimeScreen = "null";
/**
* JULIAN DAYS
*
*/
@JsonProperty("cscrnw01_jul_ddd")
@JsonPropertyDescription("JULIAN DAYS")
@DecimalMax("999")
private Integer cscrnw01JulDdd = 0;
/**
* ORGANIZATION CODE
*
*/
@JsonProperty("ldm54wm1_user_orgnztn")
@JsonPropertyDescription("ORGANIZATION CODE")
private String ldm54wm1UserOrgnztn = "null";
/**
* JOB STANDARD NUMBER
*
*/
@JsonProperty("ldm54wm1_job_std_nr")
@JsonPropertyDescription("JOB STANDARD NUMBER")
@NotNull
private String ldm54wm1JobStdNr = "null";
/**
* JOB STANDARD DESCRIPTION
*
*/
@JsonProperty("ldm54wm1_job_std_dscrptn")
@JsonPropertyDescription("JOB STANDARD DESCRIPTION")
@NotNull
private String ldm54wm1JobStdDscrptn = "null";
/**
* TYPE MAINTENANCE CODE
*
*/
@JsonProperty("ldm54wm1_type_maint_code")
@JsonPropertyDescription("TYPE MAINTENANCE CODE")
private String ldm54wm1TypeMaintCode = "null";
/**
* JOB DESIGNATOR CODE
*
*/
@JsonProperty("ldm54wm1_job_dsgntr_code")
@JsonPropertyDescription("JOB DESIGNATOR CODE")
private String ldm54wm1JobDsgntrCode = "null";
/**
* LEVEL OF MAINTENANCE
*
*/
@JsonProperty("ldm54wm1_lvl_maint")
@JsonPropertyDescription("LEVEL OF MAINTENANCE")
private String ldm54wm1LvlMaint = "null";
/**
* TCTO NUMBER
*
*/
@JsonProperty("ldm54wm1_tcto_nr")
@JsonPropertyDescription("TCTO NUMBER")
@NotNull
private String ldm54wm1TctoNr = "null";
/**
* OPERATING INTERVAL CODE
*
*/
@JsonProperty("ldm54wm1_oprtg_intvl_code")
@JsonPropertyDescription("OPERATING INTERVAL CODE")
@Valid
private List<String> ldm54wm1OprtgIntvlCode;
/**
* OPERATING INTERVAL BASE VALUE
*
*/
@JsonProperty("ldm54wm1_oprtg_intvl_base_val")
@JsonPropertyDescription("OPERATING INTERVAL BASE VALUE")
@Valid
private List<Double> ldm54wm1OprtgIntvlBaseVal;
/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_base_val_lw_tolr")
@JsonPropertyDescription("CALENDAR DAY")
@Valid
private List<Integer> ldm54wm1BaseValLwTolr;
/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_base_val_up_tolr")
@JsonPropertyDescription("CALENDAR DAY")
@Valid
private List<Integer> ldm54wm1BaseValUpTolr;
/**
* INTERVAL FREQUENCY
*
*/
@JsonProperty("ldm54wm1_intvl_freq")
@JsonPropertyDescription("INTERVAL FREQUENCY")
@Valid
private List<Double> ldm54wm1IntvlFreq;
/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_freq_lw_tolr")
@JsonPropertyDescription("CALENDAR DAY")
@Valid
private List<Integer> ldm54wm1FreqLwTolr;
/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_freq_up_tolr")
@JsonPropertyDescription("CALENDAR DAY")
@Valid
private List<Integer> ldm54wm1FreqUpTolr;
/**
* BASIS FOR ALGORITHM
*
*/
@JsonProperty("ldm54wm1_bas_for_algor")
@JsonPropertyDescription("BASIS FOR ALGORITHM")
@Valid
private List<String> ldm54wm1BasForAlgor;
/**
* EQUIPMENT DESIGNATOR
*
*/
@JsonProperty("ldm54wm1_eqpmt_dsgntr_aff")
@JsonPropertyDescription("EQUIPMENT DESIGNATOR")
@Valid
private List<String> ldm54wm1EqpmtDsgntrAff;
/**
* WORK UNIT CODE
*
*/
@JsonProperty("ldm54wm1_wrk_unt_code")
@JsonPropertyDescription("WORK UNIT CODE")
@Valid
private List<String> ldm54wm1WrkUntCode;
/**
* EQUIPMENT DESIGNATOR
*
*/
@JsonProperty("ldm54wm1_eqpmt_dsgntr_tbm")
@JsonPropertyDescription("EQUIPMENT DESIGNATOR")
@Valid
private List<String> ldm54wm1EqpmtDsgntrTbm;
/**
* FEDERAL SUPPLY CODE FOR MANUFACTURER (FSCM)
*
*/
@JsonProperty("ldm54wm1_fscm")
@JsonPropertyDescription("FEDERAL SUPPLY CODE FOR MANUFACTURER (FSCM)")
@Valid
private List<String> ldm54wm1Fscm;
/**
* PART NUMBER
*
*/
@JsonProperty("ldm54wm1_prt_nr")
@JsonPropertyDescription("PART NUMBER")
@Valid
private List<String> ldm54wm1PrtNr;
/**
* WORK AREA CODE
*
*/
@JsonProperty("ldm54wm1_wrk_ar_code")
@JsonPropertyDescription("WORK AREA CODE")
@Valid
private List<String> ldm54wm1WrkArCode;
/**
* ORGANIZATION CODE
*
*/
@JsonProperty("ldm54wm1_orgnztn_code")
@JsonPropertyDescription("ORGANIZATION CODE")
@NotNull
@Valid
private List<String> ldm54wm1OrgnztnCode;
/**
* Desc
*
*/
@JsonProperty("ldm54wm1_tci_indctr")
@JsonPropertyDescription("Desc")
private String ldm54wm1TciIndctr = "null";
/**
* Desc
*
*/
@JsonProperty("ldm54wm1_phase_ind")
@JsonPropertyDescription("Desc")
private String ldm54wm1PhaseInd = "null";
/**
* Desc
*
*/
@JsonProperty("ldm54wm1_prdcty_chng_ind")
@JsonPropertyDescription("Desc")
private String ldm54wm1PrdctyChngInd = "null";
/**
* Desc
*
*/
@JsonProperty("ldm54wm1_oil_consumption_jsn")
@JsonPropertyDescription("Desc")
private String ldm54wm1OilConsumptionJsn = "null";
@JsonIgnore
@Valid
private Map<String, Object> additionalProperties = new LinkedHashMap<String, Object>();

/**
* PAGE NUMBER DISPLAYED ON SCREEN
*
*/
@JsonProperty("cscrnw01_page_nr")
public Integer getCscrnw01PageNr() {
return cscrnw01PageNr;
}

/**
* PAGE NUMBER DISPLAYED ON SCREEN
*
*/
@JsonProperty("cscrnw01_page_nr")
public void setCscrnw01PageNr(Integer cscrnw01PageNr) {
this.cscrnw01PageNr = cscrnw01PageNr;
}

/**
* SCREEN DISPLAY - DATE
*
*/
@JsonProperty("cscrnw01_date_screen")
public String getCscrnw01DateScreen() {
return cscrnw01DateScreen;
}

/**
* SCREEN DISPLAY - DATE
*
*/
@JsonProperty("cscrnw01_date_screen")
public void setCscrnw01DateScreen(String cscrnw01DateScreen) {
this.cscrnw01DateScreen = cscrnw01DateScreen;
}

/**
* SCREEN DISPLAY - TIME
*
*/
@JsonProperty("cscrnw01_time_screen")
public String getCscrnw01TimeScreen() {
return cscrnw01TimeScreen;
}

/**
* SCREEN DISPLAY - TIME
*
*/
@JsonProperty("cscrnw01_time_screen")
public void setCscrnw01TimeScreen(String cscrnw01TimeScreen) {
this.cscrnw01TimeScreen = cscrnw01TimeScreen;
}

/**
* JULIAN DAYS
*
*/
@JsonProperty("cscrnw01_jul_ddd")
public Integer getCscrnw01JulDdd() {
return cscrnw01JulDdd;
}

/**
* JULIAN DAYS
*
*/
@JsonProperty("cscrnw01_jul_ddd")
public void setCscrnw01JulDdd(Integer cscrnw01JulDdd) {
this.cscrnw01JulDdd = cscrnw01JulDdd;
}

/**
* ORGANIZATION CODE
*
*/
@JsonProperty("ldm54wm1_user_orgnztn")
public String getLdm54wm1UserOrgnztn() {
return ldm54wm1UserOrgnztn;
}

/**
* ORGANIZATION CODE
*
*/
@JsonProperty("ldm54wm1_user_orgnztn")
public void setLdm54wm1UserOrgnztn(String ldm54wm1UserOrgnztn) {
this.ldm54wm1UserOrgnztn = ldm54wm1UserOrgnztn;
}

/**
* JOB STANDARD NUMBER
*
*/
@JsonProperty("ldm54wm1_job_std_nr")
public String getLdm54wm1JobStdNr() {
return ldm54wm1JobStdNr;
}

/**
* JOB STANDARD NUMBER
*
*/
@JsonProperty("ldm54wm1_job_std_nr")
public void setLdm54wm1JobStdNr(String ldm54wm1JobStdNr) {
this.ldm54wm1JobStdNr = ldm54wm1JobStdNr;
}

/**
* JOB STANDARD DESCRIPTION
*
*/
@JsonProperty("ldm54wm1_job_std_dscrptn")
public String getLdm54wm1JobStdDscrptn() {
return ldm54wm1JobStdDscrptn;
}

/**
* JOB STANDARD DESCRIPTION
*
*/
@JsonProperty("ldm54wm1_job_std_dscrptn")
public void setLdm54wm1JobStdDscrptn(String ldm54wm1JobStdDscrptn) {
this.ldm54wm1JobStdDscrptn = ldm54wm1JobStdDscrptn;
}

/**
* TYPE MAINTENANCE CODE
*
*/
@JsonProperty("ldm54wm1_type_maint_code")
public String getLdm54wm1TypeMaintCode() {
return ldm54wm1TypeMaintCode;
}

/**
* TYPE MAINTENANCE CODE
*
*/
@JsonProperty("ldm54wm1_type_maint_code")
public void setLdm54wm1TypeMaintCode(String ldm54wm1TypeMaintCode) {
this.ldm54wm1TypeMaintCode = ldm54wm1TypeMaintCode;
}

/**
* JOB DESIGNATOR CODE
*
*/
@JsonProperty("ldm54wm1_job_dsgntr_code")
public String getLdm54wm1JobDsgntrCode() {
return ldm54wm1JobDsgntrCode;
}

/**
* JOB DESIGNATOR CODE
*
*/
@JsonProperty("ldm54wm1_job_dsgntr_code")
public void setLdm54wm1JobDsgntrCode(String ldm54wm1JobDsgntrCode) {
this.ldm54wm1JobDsgntrCode = ldm54wm1JobDsgntrCode;
}

/**
* LEVEL OF MAINTENANCE
*
*/
@JsonProperty("ldm54wm1_lvl_maint")
public String getLdm54wm1LvlMaint() {
return ldm54wm1LvlMaint;
}

/**
* LEVEL OF MAINTENANCE
*
*/
@JsonProperty("ldm54wm1_lvl_maint")
public void setLdm54wm1LvlMaint(String ldm54wm1LvlMaint) {
this.ldm54wm1LvlMaint = ldm54wm1LvlMaint;
}

/**
* TCTO NUMBER
*
*/
@JsonProperty("ldm54wm1_tcto_nr")
public String getLdm54wm1TctoNr() {
return ldm54wm1TctoNr;
}

/**
* TCTO NUMBER
*
*/
@JsonProperty("ldm54wm1_tcto_nr")
public void setLdm54wm1TctoNr(String ldm54wm1TctoNr) {
this.ldm54wm1TctoNr = ldm54wm1TctoNr;
}

/**
* OPERATING INTERVAL CODE
*
*/
@JsonProperty("ldm54wm1_oprtg_intvl_code")
public List<String> getLdm54wm1OprtgIntvlCode() {
return ldm54wm1OprtgIntvlCode;
}

/**
* OPERATING INTERVAL CODE
*
*/
@JsonProperty("ldm54wm1_oprtg_intvl_code")
public void setLdm54wm1OprtgIntvlCode(List<String> ldm54wm1OprtgIntvlCode) {
this.ldm54wm1OprtgIntvlCode = ldm54wm1OprtgIntvlCode;
}

/**
* OPERATING INTERVAL BASE VALUE
*
*/
@JsonProperty("ldm54wm1_oprtg_intvl_base_val")
public List<Double> getLdm54wm1OprtgIntvlBaseVal() {
return ldm54wm1OprtgIntvlBaseVal;
}

/**
* OPERATING INTERVAL BASE VALUE
*
*/
@JsonProperty("ldm54wm1_oprtg_intvl_base_val")
public void setLdm54wm1OprtgIntvlBaseVal(List<Double> ldm54wm1OprtgIntvlBaseVal) {
this.ldm54wm1OprtgIntvlBaseVal = ldm54wm1OprtgIntvlBaseVal;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_base_val_lw_tolr")
public List<Integer> getLdm54wm1BaseValLwTolr() {
return ldm54wm1BaseValLwTolr;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_base_val_lw_tolr")
public void setLdm54wm1BaseValLwTolr(List<Integer> ldm54wm1BaseValLwTolr) {
this.ldm54wm1BaseValLwTolr = ldm54wm1BaseValLwTolr;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_base_val_up_tolr")
public List<Integer> getLdm54wm1BaseValUpTolr() {
return ldm54wm1BaseValUpTolr;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_base_val_up_tolr")
public void setLdm54wm1BaseValUpTolr(List<Integer> ldm54wm1BaseValUpTolr) {
this.ldm54wm1BaseValUpTolr = ldm54wm1BaseValUpTolr;
}

/**
* INTERVAL FREQUENCY
*
*/
@JsonProperty("ldm54wm1_intvl_freq")
public List<Double> getLdm54wm1IntvlFreq() {
return ldm54wm1IntvlFreq;
}

/**
* INTERVAL FREQUENCY
*
*/
@JsonProperty("ldm54wm1_intvl_freq")
public void setLdm54wm1IntvlFreq(List<Double> ldm54wm1IntvlFreq) {
this.ldm54wm1IntvlFreq = ldm54wm1IntvlFreq;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_freq_lw_tolr")
public List<Integer> getLdm54wm1FreqLwTolr() {
return ldm54wm1FreqLwTolr;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_freq_lw_tolr")
public void setLdm54wm1FreqLwTolr(List<Integer> ldm54wm1FreqLwTolr) {
this.ldm54wm1FreqLwTolr = ldm54wm1FreqLwTolr;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_freq_up_tolr")
public List<Integer> getLdm54wm1FreqUpTolr() {
return ldm54wm1FreqUpTolr;
}

/**
* CALENDAR DAY
*
*/
@JsonProperty("ldm54wm1_freq_up_tolr")
public void setLdm54wm1FreqUpTolr(List<Integer> ldm54wm1FreqUpTolr) {
this.ldm54wm1FreqUpTolr = ldm54wm1FreqUpTolr;
}

/**
* BASIS FOR ALGORITHM
*
*/
@JsonProperty("ldm54wm1_bas_for_algor")
public List<String> getLdm54wm1BasForAlgor() {
return ldm54wm1BasForAlgor;
}

/**
* BASIS FOR ALGORITHM
*
*/
@JsonProperty("ldm54wm1_bas_for_algor")
public void setLdm54wm1BasForAlgor(List<String> ldm54wm1BasForAlgor) {
this.ldm54wm1BasForAlgor = ldm54wm1BasForAlgor;
}

/**
* EQUIPMENT DESIGNATOR
*
*/
@JsonProperty("ldm54wm1_eqpmt_dsgntr_aff")
public List<String> getLdm54wm1EqpmtDsgntrAff() {
return ldm54wm1EqpmtDsgntrAff;
}

/**
* EQUIPMENT DESIGNATOR
*
*/
@JsonProperty("ldm54wm1_eqpmt_dsgntr_aff")
public void setLdm54wm1EqpmtDsgntrAff(List<String> ldm54wm1EqpmtDsgntrAff) {
this.ldm54wm1EqpmtDsgntrAff = ldm54wm1EqpmtDsgntrAff;
}

/**
* WORK UNIT CODE
*
*/
@JsonProperty("ldm54wm1_wrk_unt_code")
public List<String> getLdm54wm1WrkUntCode() {
return ldm54wm1WrkUntCode;
}

/**
* WORK UNIT CODE
*
*/
@JsonProperty("ldm54wm1_wrk_unt_code")
public void setLdm54wm1WrkUntCode(List<String> ldm54wm1WrkUntCode) {
this.ldm54wm1WrkUntCode = ldm54wm1WrkUntCode;
}

/**
* EQUIPMENT DESIGNATOR
*
*/
@JsonProperty("ldm54wm1_eqpmt_dsgntr_tbm")
public List<String> getLdm54wm1EqpmtDsgntrTbm() {
return ldm54wm1EqpmtDsgntrTbm;
}

/**
* EQUIPMENT DESIGNATOR
*
*/
@JsonProperty("ldm54wm1_eqpmt_dsgntr_tbm")
public void setLdm54wm1EqpmtDsgntrTbm(List<String> ldm54wm1EqpmtDsgntrTbm) {
this.ldm54wm1EqpmtDsgntrTbm = ldm54wm1EqpmtDsgntrTbm;
}

/**
* FEDERAL SUPPLY CODE FOR MANUFACTURER (FSCM)
*
*/
@JsonProperty("ldm54wm1_fscm")
public List<String> getLdm54wm1Fscm() {
return ldm54wm1Fscm;
}

/**
* FEDERAL SUPPLY CODE FOR MANUFACTURER (FSCM)
*
*/
@JsonProperty("ldm54wm1_fscm")
public void setLdm54wm1Fscm(List<String> ldm54wm1Fscm) {
this.ldm54wm1Fscm = ldm54wm1Fscm;
}

/**
* PART NUMBER
*
*/
@JsonProperty("ldm54wm1_prt_nr")
public List<String> getLdm54wm1PrtNr() {
return ldm54wm1PrtNr;
}

/**
* PART NUMBER
*
*/
@JsonProperty("ldm54wm1_prt_nr")
public void setLdm54wm1PrtNr(List<String> ldm54wm1PrtNr) {
this.ldm54wm1PrtNr = ldm54wm1PrtNr;
}

/**
* WORK AREA CODE
*
*/
@JsonProperty("ldm54wm1_wrk_ar_code")
public List<String> getLdm54wm1WrkArCode() {
return ldm54wm1WrkArCode;
}

/**
* WORK AREA CODE
*
*/
@JsonProperty("ldm54wm1_wrk_ar_code")
public void setLdm54wm1WrkArCode(List<String> ldm54wm1WrkArCode) {
this.ldm54wm1WrkArCode = ldm54wm1WrkArCode;
}

/**
* ORGANIZATION CODE
*
*/
@JsonProperty("ldm54wm1_orgnztn_code")
public List<String> getLdm54wm1OrgnztnCode() {
return ldm54wm1OrgnztnCode;
}

/**
* ORGANIZATION CODE
*
*/
@JsonProperty("ldm54wm1_orgnztn_code")
public void setLdm54wm1OrgnztnCode(List<String> ldm54wm1OrgnztnCode) {
this.ldm54wm1OrgnztnCode = ldm54wm1OrgnztnCode;
}

/**
* Desc
*
*/
@JsonProperty("ldm54wm1_tci_indctr")
public String getLdm54wm1TciIndctr() {
return ldm54wm1TciIndctr;
}

/**
* Desc
*
*/
@JsonProperty("ldm54wm1_tci_indctr")
public void setLdm54wm1TciIndctr(String ldm54wm1TciIndctr) {
this.ldm54wm1TciIndctr = ldm54wm1TciIndctr;
}

 

/**
* ldm54wm1_phase_ind
*
*/
@JsonProperty("ldm54wm1_phase_ind")
public void setLdm54wm1PhaseInd(String ldm54wm1PhaseInd) {
this.ldm54wm1PhaseInd = ldm54wm1PhaseInd;
}

 
/**
* ldm54wm1_prdcty_chng_ind
*
*/
@JsonProperty("ldm54wm1_prdcty_chng_ind")
public void setLdm54wm1PrdctyChngInd(String ldm54wm1PrdctyChngInd) {
this.ldm54wm1PrdctyChngInd = ldm54wm1PrdctyChngInd;
}

/**
* Desc
*
*/
@JsonProperty("ldm54wm1_oil_consumption_jsn")
public String getLdm54wm1OilConsumptionJsn() {
return ldm54wm1OilConsumptionJsn;
}

/**
* ldm54wm1_oil_consumption_jsn
*
*/
@JsonProperty("ldm54wm1_oil_consumption_jsn")
public void setLdm54wm1OilConsumptionJsn(String ldm54wm1OilConsumptionJsn) {
this.ldm54wm1OilConsumptionJsn = ldm54wm1OilConsumptionJsn;
}

@JsonAnyGetter
public Map<String, Object> getAdditionalProperties() {
return this.additionalProperties;
}

@JsonAnySetter
public void setAdditionalProperty(String name, Object value) {
this.additionalProperties.put(name, value);
}

}