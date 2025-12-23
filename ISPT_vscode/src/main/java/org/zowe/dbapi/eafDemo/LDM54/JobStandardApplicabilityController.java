/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi.eafDemo.LDM54;

import static com.broadcom.restapi.sdk.apidoc.ApiDocConstants.DOC_SCHEME_BASIC_AUTH;

import io.swagger.v3.oas.annotations.tags.Tag;
import io.swagger.v3.oas.annotations.security.SecurityRequirement;
import io.swagger.v3.oas.annotations.Operation;
import io.swagger.v3.oas.annotations.Parameter;
import io.swagger.v3.oas.annotations.responses.ApiResponse;
import io.swagger.v3.oas.annotations.responses.ApiResponses;
import io.swagger.v3.oas.annotations.media.Content;
import io.swagger.v3.oas.annotations.media.Schema;
//import io.swagger.v3.oas.annotations.media.ArraySchema;
import org.springframework.http.MediaType;

import java.math.*;    // for parameter types
//import java.sql.*;     // for parameter types
//import org.springframework.format.annotation.DateTimeFormat;
//import java.time.LocalDate;
//import java.time.LocalDateTime;
//import java.time.LocalTime;
//import java.util.List;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
//import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.bind.annotation.GetMapping;

/**
 * Defines the REST API for the dialog LDM54d08
 *
 * @author Zowe Database API Generator + manual
 * @since 1.0
 */
@RestController("EafDemoJobStandardApplicabilityController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(
   name = "eafDemo JobStandardApplicability",
   description = "REST API example showcasing ADS Dialog data Retrieval and Update"
)
public class JobStandardApplicabilityController  {

    @Autowired
    private JobStandardApplicabilityService service;

 
    @GetMapping("/eafDemo/jobStandard/Applicability/{datasource}/{jobStdNr}")
    @Operation(
        summary = "Use LDM54d08 dialog to retrieve  jobStandard Applicability info for a specific job std nr",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = String.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public String get(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "jobStdNr", description = "Job Std Nr", required = true, example = "000012")
        @PathVariable("jobStdNr") String jobStdNr) throws Exception {
        log.debug("get eafDemo/jobStandard/Applicability({}, {})", datasource, jobStdNr);
        datasource = datasource.toUpperCase();
        String jobStdApplJson = service.get(datasource, jobStdNr);
        return jobStdApplJson;
    }
    

    @PostMapping("/eafDemo/jobStandard/Applicability/{datasource}")
    @Operation(
        summary = "Use LDM54D08 dialog to update  jobStandard Applicabilityinfo for a specific jobStdNr",
        security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
        }
    )
    @ApiResponses(value = {
        @ApiResponse(responseCode = "200", description = "OK", content = @Content(
            mediaType = MediaType.APPLICATION_JSON_VALUE,
            schema = @Schema(implementation = String.class))),
        @ApiResponse(responseCode = "400", description = "Bad request",content = @Content),
        @ApiResponse(responseCode = "401", description = "Authentication is required",content = @Content),
        @ApiResponse(responseCode = "403", description = "Forbidden",content = @Content),
        @ApiResponse(responseCode = "404", description = "Not Found",content = @Content),
        @ApiResponse(responseCode = "500", description = "Internal server error",content = @Content)
    })
    public String postJobStandardApplicability(
        @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO")
        @PathVariable("datasource") String datasource,
        @Parameter(name = "ldm54wm1_user_orgnztn", description = "ORGANIZATION CODE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_user_orgnztn",defaultValue = "",required = true) String ldm54wm1_user_orgnztn,
        @Parameter(name = "ldm54wm1_job_std_nr", description = "JOB STANDARD NUMBER", required = true, example = "00012")
        @RequestParam (value ="ldm54wm1_job_std_nr",defaultValue = "",required = false) String ldm54wm1_job_std_nr,
        @Parameter(name = "ldm54wm1_job_std_dscrptn", description = "JOB STANDARD DESCRIPTION", required = true, example = "")
        @RequestParam (value ="ldm54wm1_job_std_dscrptn",defaultValue = "",required = false) String ldm54wm1_job_std_dscrptn,
        @Parameter(name = "ldm54wm1_type_maint_code", description = "TYPE MAINTENANCE CODE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_type_maint_code",defaultValue = "",required = false) String ldm54wm1_type_maint_code,
        @Parameter(name = "ldm54wm1_job_dsgntr_code", description = "JOB DESIGNATOR CODE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_job_dsgntr_code",defaultValue = "",required = false) String ldm54wm1_job_dsgntr_code,
        @Parameter(name = "ldm54wm1_lvl_maint", description = "LEVEL OF MAINTENANCE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_lvl_maint",defaultValue = "",required = false) String ldm54wm1_lvl_maint,
        @Parameter(name = "ldm54wm1_tcto_nr", description = "TCTO NUMBER", required = true, example = "000000000000000000000000")
        @RequestParam (value ="ldm54wm1_tcto_nr",defaultValue = "",required = false) String ldm54wm1_tcto_nr,
        @Parameter(name = "ldm54wm1_oprtg_intvl_code", description = "OPERATING INTERVAL CODE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_oprtg_intvl_code",defaultValue = "",required = false) String ldm54wm1_oprtg_intvl_code,
        @Parameter(name = "ldm54wm1_oprtg_intvl_base_val", description = "OPERATING INTERVAL BASE VALUE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_oprtg_intvl_base_val",defaultValue = "",required = false) BigDecimal ldm54wm1_oprtg_intvl_base_val,
        @Parameter(name = "ldm54wm1_base_val_lw_tolr", description = "CALENDAR DAY", required = false, example = "")
        @RequestParam (value ="ldm54wm1_base_val_lw_tolr",defaultValue = "",required = false) BigDecimal ldm54wm1_base_val_lw_tolr,
        @Parameter(name = "ldm54wm1_base_val_up_tolr", description = "CALENDAR DAY", required = false, example = "")
        @RequestParam (value ="ldm54wm1_base_val_up_tolr",defaultValue = "",required = false) BigDecimal ldm54wm1_base_val_up_tolr,
        @Parameter(name = "ldm54wm1_intvl_freq", description = "INTERVAL FREQUENCY", required = false, example = "")
        @RequestParam (value ="ldm54wm1_intvl_freq",defaultValue = "",required = false) BigDecimal ldm54wm1_intvl_freq,
        @Parameter(name = "ldm54wm1_freq_lw_tolr", description = "CALENDAR DAY", required = false, example = "")
        @RequestParam (value ="ldm54wm1_freq_lw_tolr",defaultValue = "",required = false) BigDecimal ldm54wm1_freq_lw_tolr,
        @Parameter(name = "ldm54wm1_freq_up_tolr", description = "CALENDAR DAY", required = false, example = "")
        @RequestParam (value ="ldm54wm1_freq_up_tolr",defaultValue = "",required = false) BigDecimal ldm54wm1_freq_up_tolr,
        @Parameter(name = "ldm54wm1_bas_for_algor", description = "BASIS FOR ALGORITHM", required = false, example = "")
        @RequestParam (value ="ldm54wm1_bas_for_algor",defaultValue = "",required = false) String ldm54wm1_bas_for_algor,
        @Parameter(name = "ldm54wm1_eqpmt_dsgntr_aff", description = "EQUIPMENT DESIGNATOR", required = false, example = "")
        @RequestParam (value ="ldm54wm1_eqpmt_dsgntr_aff",defaultValue = "",required = false) String ldm54wm1_eqpmt_dsgntr_aff,
        @Parameter(name = "ldm54wm1_wrk_unt_code", description = "WORK UNIT CODE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_wrk_unt_code",defaultValue = "",required = false) String ldm54wm1_wrk_unt_code,
        @Parameter(name = "ldm54wm1_eqpmt_dsgntr_tbm", description = "EQUIPMENT DESIGNATOR", required = false, example = "")
        @RequestParam (value ="ldm54wm1_eqpmt_dsgntr_tbm",defaultValue = "",required = false) String ldm54wm1_eqpmt_dsgntr_tbm,
        @Parameter(name = "ldm54wm1_fscm", description = "FEDERAL SUPPLY CODE FOR MANUFACTURER (FSCM)", required = false, example = "")
        @RequestParam (value ="ldm54wm1_fscm",defaultValue = "",required = false) String ldm54wm1_fscm,
        @Parameter(name = "ldm54wm1_prt_nr", description = "PART NUMBER", required = false, example = "")
        @RequestParam (value ="ldm54wm1_prt_nr",defaultValue = "",required = false) String ldm54wm1_prt_nr,
        @Parameter(name = "ldm54wm1_wrk_ar_code", description = "WORK AREA CODE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_wrk_ar_code",defaultValue = "",required = false) String ldm54wm1_wrk_ar_code,
        @Parameter(name = "ldm54wm1_orgnztn_code", description = "ORGANIZATION CODE", required = false, example = "")
        @RequestParam (value ="ldm54wm1_orgnztn_code",defaultValue = "",required = true) String ldm54wm1_orgnztn_code,
        @Parameter(name = "ldm54wm1_tci_indctr", description = "", required = false, example = "00000000")
        @RequestParam (value ="ldm54wm1_tci_indctr",defaultValue = "",required = false) String ldm54wm1_tci_indctr,
        @Parameter(name = "ldm54wm1_phase_ind", description = "", required = false, example = "")
        @RequestParam (value ="ldm54wm1_phase_ind",defaultValue = "",required = false) String ldm54wm1_phase_ind,
        @Parameter(name = "ldm54wm1_prdcty_chng_ind", description = "", required = false, example = "")
        @RequestParam (value ="ldm54wm1_prdcty_chng_ind",defaultValue = "",required = false) String ldm54wm1_prdcty_chng_ind,
        @Parameter(name = "ldm54wm1_oil_consumption_jsn", description = "", required = false, example = "")
        @RequestParam (value ="ldm54wm1_oil_consumption_jsn",defaultValue = "",required = false) String ldm54wm1_oil_consumption_jsn      
      
        ) throws Exception {
   //     log.debug("postjobStdAppl({}, {} - {} {} {} {})", datasource, empId,empStreet,empCity,empState,empZip);
        datasource = datasource.toUpperCase();
        JobStandardInfo jobStdInfo = new JobStandardInfo();
     /*
        employee.setEmpId(empId);
        if (empStreet != null) {
            employee.setStreet(empStreet);
        }
        if (empCity != null) {
            employee.setCity (empCity );
        }
        if (empState != null) {
            employee.setState(empState);
        }
        if (empZip != null) {
            employee.setZipCode(empZip) ;
        }
            */
        String jobStdJson = service.post(datasource,  jobStdInfo);
        return jobStdJson;
    }

    
}
