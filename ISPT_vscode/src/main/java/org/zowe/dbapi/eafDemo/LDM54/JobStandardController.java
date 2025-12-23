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
import io.swagger.v3.oas.annotations.parameters.RequestBody;

//import io.swagger.v3.oas.annotations.media.ArraySchema;
import org.springframework.http.MediaType;

import java.math.*; // for parameter types
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
import java.util.List;
import java.util.ArrayList;

/**
 * Defines the REST API for the dialog EMPINQD
 *
 * @author Zowe Database API Generator + manual
 * @since 1.0
 */
@RestController("EAFDemoJobStandardController")
@RequestMapping("/api/v1")
@Slf4j
@Tag(name = "EAFDemo JobStandard(LDM54)", description = "REST API example showcasing ADS Dialog data Retrieval and Update")
public class JobStandardController {

    @Autowired
    private JobStandardService service;

    @GetMapping("/eafDemo/jobStandard/info/{datasource}/{jobStdNr}")
    @Operation(summary = "Use LDM54D04 dialog to retrieve Job Standard info for a specific job_std_nr", security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
    })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "OK", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = String.class))),
            @ApiResponse(responseCode = "400", description = "Bad request", content = @Content),
            @ApiResponse(responseCode = "401", description = "Authentication is required", content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden", content = @Content),
            @ApiResponse(responseCode = "404", description = "Not Found", content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
    })
    public String getJobStandardInfo(
            @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO") @PathVariable("datasource") String datasource,
            @Parameter(name = "jobStdNr", description = "EMPLOYEE EMP_ID", required = true, example = "1234") @PathVariable("jobStdNr") String job_std_nr)
            throws Exception {
        log.debug("getEmployeeInfo({}, {})", datasource, job_std_nr);
        datasource = datasource.toUpperCase();
        String jobStdJson = service.getJobStandardInfo(datasource, job_std_nr);
        return jobStdJson;
    }

    @GetMapping("/eafDemo/jobStandard/{datasource}/{jobStdNr}")
    @Operation(summary = "Use LDM54d04 dialog to retrieve JobStandard for modification", security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
    })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "OK", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = String.class))),
            @ApiResponse(responseCode = "400", description = "Bad request", content = @Content),
            @ApiResponse(responseCode = "401", description = "Authentication is required", content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden", content = @Content),
            @ApiResponse(responseCode = "404", description = "Not Found", content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
    })
    public String getJobStd(
            @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO") @PathVariable("datasource") String datasource,

            @Parameter(name = "job_std_nr", description = "JOB STANDARD NUMBER", required = true, example = "00012") @PathVariable("job_std_nr") String ldm54wm1_job_std_nr)
            throws Exception {
        log.debug("getjob_std({}, {})", datasource, ldm54wm1_job_std_nr);
        datasource = datasource.toUpperCase();
        String jobStdJson = service.get(datasource, ldm54wm1_job_std_nr);
        return jobStdJson;
    }

    @PostMapping("/eafDemo/jobStandard/{datasource}")
    @Operation(summary = "Use LDM54D01/02/03 to insert a new Job Standard, applicability and related work centers  ", security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
    })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "OK", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = String.class))),
            @ApiResponse(responseCode = "400", description = "Bad request", content = @Content),
            @ApiResponse(responseCode = "401", description = "Authentication is required", content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden", content = @Content),
            @ApiResponse(responseCode = "404", description = "Not Found", content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
    })
    public String postJobStandard(
            @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO") @PathVariable("datasource") String datasource,
            @Parameter(name = "ldm54wm1_user_orgnztn", description = "ORGANIZATION CODE", required = false, example = "") @RequestParam(value = "ldm54wm1_user_orgnztn", defaultValue = "", required = true) String ldm54wm1_user_orgnztn,
            @Parameter(name = "ldm54wm1_job_std_nr", description = "JOB STANDARD NUMBER", required = true, example = "00012") @RequestParam(value = "ldm54wm1_job_std_nr", defaultValue = "", required = false) String ldm54wm1_job_std_nr,
            @Parameter(name = "ldm54wm1_job_std_dscrptn", description = "JOB STANDARD DESCRIPTION", required = true, example = "") @RequestParam(value = "ldm54wm1_job_std_dscrptn", defaultValue = "", required = false) String ldm54wm1_job_std_dscrptn,
            @Parameter(name = "ldm54wm1_type_maint_code", description = "TYPE MAINTENANCE CODE", required = false, example = "") @RequestParam(value = "ldm54wm1_type_maint_code", defaultValue = "", required = false) String ldm54wm1_type_maint_code,
            @Parameter(name = "ldm54wm1_job_dsgntr_code", description = "JOB DESIGNATOR CODE", required = false, example = "") @RequestParam(value = "ldm54wm1_job_dsgntr_code", defaultValue = "", required = false) String ldm54wm1_job_dsgntr_code,
            @Parameter(name = "ldm54wm1_lvl_maint", description = "LEVEL OF MAINTENANCE", required = false, example = "") @RequestParam(value = "ldm54wm1_lvl_maint", defaultValue = "", required = false) String ldm54wm1_lvl_maint,
            @Parameter(name = "ldm54wm1_tcto_nr", description = "TCTO NUMBER", required = true, example = "000000000000000000000000") @RequestParam(value = "ldm54wm1_tcto_nr", defaultValue = "", required = false) String ldm54wm1_tcto_nr,
            @Parameter(name = "ldm54wm1_oprtg_intvl_code", description = "OPERATING INTERVAL CODE", required = false, example = "") @RequestParam(value = "ldm54wm1_oprtg_intvl_code", defaultValue = "", required = false) String ldm54wm1_oprtg_intvl_code,
            @Parameter(name = "ldm54wm1_oprtg_intvl_base_val", description = "OPERATING INTERVAL BASE VALUE", required = false, example = "") @RequestParam(value = "ldm54wm1_oprtg_intvl_base_val", defaultValue = "", required = false) BigDecimal ldm54wm1_oprtg_intvl_base_val,
            @Parameter(name = "ldm54wm1_base_val_lw_tolr", description = "CALENDAR DAY", required = false, example = "") @RequestParam(value = "ldm54wm1_base_val_lw_tolr", defaultValue = "", required = false) BigDecimal ldm54wm1_base_val_lw_tolr,
            @Parameter(name = "ldm54wm1_base_val_up_tolr", description = "CALENDAR DAY", required = false, example = "") @RequestParam(value = "ldm54wm1_base_val_up_tolr", defaultValue = "", required = false) BigDecimal ldm54wm1_base_val_up_tolr,
            @Parameter(name = "ldm54wm1_intvl_freq", description = "INTERVAL FREQUENCY", required = false, example = "") @RequestParam(value = "ldm54wm1_intvl_freq", defaultValue = "", required = false) BigDecimal ldm54wm1_intvl_freq,
            @Parameter(name = "ldm54wm1_freq_lw_tolr", description = "CALENDAR DAY", required = false, example = "") @RequestParam(value = "ldm54wm1_freq_lw_tolr", defaultValue = "", required = false) BigDecimal ldm54wm1_freq_lw_tolr,
            @Parameter(name = "ldm54wm1_freq_up_tolr", description = "CALENDAR DAY", required = false, example = "") @RequestParam(value = "ldm54wm1_freq_up_tolr", defaultValue = "", required = false) BigDecimal ldm54wm1_freq_up_tolr,
            @Parameter(name = "ldm54wm1_bas_for_algor", description = "BASIS FOR ALGORITHM", required = false, example = "") @RequestParam(value = "ldm54wm1_bas_for_algor", defaultValue = "", required = false) String ldm54wm1_bas_for_algor,
            @Parameter(name = "ldm54wm1_eqpmt_dsgntr_aff", description = "EQUIPMENT DESIGNATOR", required = false, example = "") @RequestParam(value = "ldm54wm1_eqpmt_dsgntr_aff", defaultValue = "", required = false) String ldm54wm1_eqpmt_dsgntr_aff,
            @Parameter(name = "ldm54wm1_wrk_unt_code", description = "WORK UNIT CODE", required = false, example = "") @RequestParam(value = "ldm54wm1_wrk_unt_code", defaultValue = "", required = false) String ldm54wm1_wrk_unt_code,
            @Parameter(name = "ldm54wm1_eqpmt_dsgntr_tbm", description = "EQUIPMENT DESIGNATOR", required = false, example = "") @RequestParam(value = "ldm54wm1_eqpmt_dsgntr_tbm", defaultValue = "", required = false) String ldm54wm1_eqpmt_dsgntr_tbm,
            @Parameter(name = "ldm54wm1_fscm", description = "FEDERAL SUPPLY CODE FOR MANUFACTURER (FSCM)", required = false, example = "") @RequestParam(value = "ldm54wm1_fscm", defaultValue = "", required = false) String ldm54wm1_fscm,
            @Parameter(name = "ldm54wm1_prt_nr", description = "PART NUMBER", required = false, example = "") @RequestParam(value = "ldm54wm1_prt_nr", defaultValue = "", required = false) String ldm54wm1_prt_nr,
            @Parameter(name = "ldm54wm1_wrk_ar_code", description = "WORK AREA CODE", required = false, example = "") @RequestParam(value = "ldm54wm1_wrk_ar_code", defaultValue = "", required = false) String ldm54wm1_wrk_ar_code,
            @Parameter(name = "ldm54wm1_orgnztn_code", description = "ORGANIZATION CODE", required = false, example = "") @RequestParam(value = "ldm54wm1_orgnztn_code", defaultValue = "", required = true) String ldm54wm1_orgnztn_code,
            @Parameter(name = "ldm54wm1_tci_indctr", description = "", required = false, example = "00000000") @RequestParam(value = "ldm54wm1_tci_indctr", defaultValue = "", required = false) String ldm54wm1_tci_indctr,
            @Parameter(name = "ldm54wm1_phase_ind", description = "", required = false, example = "") @RequestParam(value = "ldm54wm1_phase_ind", defaultValue = "", required = false) String ldm54wm1_phase_ind,
            @Parameter(name = "ldm54wm1_prdcty_chng_ind", description = "", required = false, example = "") @RequestParam(value = "ldm54wm1_prdcty_chng_ind", defaultValue = "", required = false) String ldm54wm1_prdcty_chng_ind,
            @Parameter(name = "ldm54wm1_oil_consumption_jsn", description = "", required = false, example = "") @RequestParam(value = "ldm54wm1_oil_consumption_jsn", defaultValue = "", required = false) String ldm54wm1_oil_consumption_jsn)
            throws Exception {
        log.debug("postEmployee({}, {} - {} {} {} )", datasource, ldm54wm1_job_std_nr, ldm54wm1_job_std_dscrptn,
                ldm54wm1_tcto_nr, ldm54wm1_orgnztn_code);
        datasource = datasource.toUpperCase();
        // JobStandardInfo jobstd = new JobStandardInfo();
        Ldm54wm1 jobstd = new Ldm54wm1();
        jobstd.setLdm54wm1JobStdNr(ldm54wm1_job_std_nr);

        if (ldm54wm1_job_std_dscrptn != null) {
            jobstd.setLdm54wm1JobStdDscrptn(ldm54wm1_job_std_dscrptn);
        }
        if (ldm54wm1_tcto_nr != null) {
            jobstd.setLdm54wm1TctoNr(ldm54wm1_tcto_nr);
        }

        List<String> orgs = new ArrayList<String>();
        if (ldm54wm1_orgnztn_code != null) {
            orgs.add(ldm54wm1_orgnztn_code);
        }
        jobstd.setLdm54wm1OrgnztnCode(orgs);

        List<String> prts = new ArrayList<String>();
        if (ldm54wm1_prt_nr != null) {
            prts.add(ldm54wm1_prt_nr);
        }
        jobstd.setLdm54wm1PrtNr(prts);

        /*
         * if (ldm54wm1_job_std_dscrptn != null) {
         * jobstd.setLdm54wm1_job_std_dscrptn(ldm54wm1_job_std_dscrptn);
         * }
         * if (ldm54wm1_tcto_nr != null) {
         * jobstd.setLdm54wm1_tcto_nr(ldm54wm1_tcto_nr);
         * }
         * if (ldm54wm1_orgnztn_code!= null) {
         * jobstd.setLdm54wm1_orgnztn_code(ldm54wm1_orgnztn_code);
         * }
         * if (ldm54wm1_prt_nr != null) {
         * jobstd.setLdm54wm1_prt_nr(ldm54wm1_prt_nr) ;
         * }
         */
        LDM54Interface ldm54Map = new LDM54Interface();
        ldm54Map.ldm54wm1 = jobstd;
        String jobStdJson = service.post(datasource, ldm54Map);
        return jobStdJson;
    }

    @PostMapping("/eafDemo/jobStandard/UseRequestBody/{datasource}")
    @Operation(summary = "Use LDM54D01/02/03 to insert a new Job Standard, applicability and related work centers  ", security = {
            @SecurityRequirement(name = DOC_SCHEME_BASIC_AUTH)
    })
    @ApiResponses(value = {
            @ApiResponse(responseCode = "200", description = "OK", content = @Content(mediaType = MediaType.APPLICATION_JSON_VALUE, schema = @Schema(implementation = String.class))),
            @ApiResponse(responseCode = "400", description = "Bad request", content = @Content),
            @ApiResponse(responseCode = "401", description = "Authentication is required", content = @Content),
            @ApiResponse(responseCode = "403", description = "Forbidden", content = @Content),
            @ApiResponse(responseCode = "404", description = "Not Found", content = @Content),
            @ApiResponse(responseCode = "500", description = "Internal server error", content = @Content)
    })
    /*
     * @PostMapping("/reports")
     * ResponseEntity<ApiResponse> generateReports(
     * 
     * @RequestParam(value = 'campaignId', required = true) Integer campaignId,
     * 
     * @RequestBody (required = false) RegionsRequest regions,
     * HttpServletRequest request,
     * HttpServletResponse response) {
     * 
     * 
     */
    public String postJobStandardnew(
            @Parameter(name = "datasource", description = "Data source name", required = true, example = "SYSDEMO") @PathVariable("datasource") String datasource,
            @RequestBody(required = true) LDM54Interface ldm54Map) throws Exception {
        // log.debug("postEmployee({}, {} - {} {} {} )", datasource,
        // ldm54Map.ldm54wm1.getLdm54wm1JobStdNr(),ldm54Map.ldm54wm1.getLdm54wm1JobStdDscrptn(),ldm54Map.ldm54wm1.getLdm54wm1TctoNr(),ldm54Map.ldm54wm1.getLdm54wm1OrgnztnCode());
        log.debug("postJobStandard({}, {} - {}   )", datasource, ldm54Map);
        datasource = datasource.toUpperCase();
        JobStandardInfo jobstd = new JobStandardInfo();
        log.debug("postJobStandardController({}, {} - {}   )", datasource, ldm54Map);
        String jobStdJson = service.post(datasource, ldm54Map);
        return jobStdJson;
    }

}
