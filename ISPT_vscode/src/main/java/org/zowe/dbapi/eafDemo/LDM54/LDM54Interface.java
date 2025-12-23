package org.zowe.dbapi.eafDemo.LDM54;
import com.fasterxml.jackson.annotation.JsonProperty;
import io.swagger.v3.oas.annotations.media.Schema;
import java.math.*;    // for data types
 

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
@Schema(name="LDM54 Interface",description = "Map work record  ")

 

 
public class LDM54Interface {
    @Schema(description="cscrnw01 work record",example = "null", nullable = true)
    @JsonProperty("cscrnw01")
 Cscrnw01 cscrnw01;
 @Schema(description="ldm54wm1 map record",example = " { \"user_orgnztn\" : \"00000000\",\"job_std_nr\" : \"00075\",\"job_std_dscrptn\" : \"job desc\",\"tcto_nr\" : \"000000000000000000000000\",\"tci_indctr\"  [\"00000000\",\"00000001\"]}" , nullable = false)
 @JsonProperty("ldm54wm1")
Ldm54wm1 ldm54wm1;
}
