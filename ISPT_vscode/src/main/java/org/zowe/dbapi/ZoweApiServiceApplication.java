/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */
package org.zowe.dbapi;

import com.broadcom.restapi.sdk.SdkApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.FilterType;
import org.zowe.dbapi.config.PackageConfiguration;

@SpringBootApplication
@ComponentScan("com.broadcom.dbapi")
@ComponentScan
@ComponentScan(
    basePackages = {"org.zowe.dbapi.config"},
    includeFilters = @ComponentScan.Filter(
        value = PackageConfiguration.class, type = FilterType.ASSIGNABLE_TYPE
    )
)
public class ZoweApiServiceApplication {

    public static void main(String[] args) {  // NOSONAR
        SdkApplication.builder()
        .applicationName("Database API Sample Project Application v 1.0.1")
        .applicationClass(ZoweApiServiceApplication.class)
        .defaultMessageService().useDefault().useSdkMessages().usePrefix("BRSA").and()
        .args(args)
        .start();
        }
    }
