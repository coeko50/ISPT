/*
 * This program and the accompanying materials are made available and may be used, at your option, under either:
 * * Eclipse Public License v2.0, available at https://www.eclipse.org/legal/epl-v20.html, OR
 * * Apache License, version 2.0, available at http://www.apache.org/licenses/LICENSE-2.0
 *
 * SPDX-License-Identifier: EPL-2.0 OR Apache-2.0
 *
 * Copyright Contributors to the Zowe Project.
 */

package org.zowe.dbapi.config;

import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;

/**
 * Configuration class to load controllers from this package.
 *
 * @author Broadcom Database API Generator
 * @since 1.0
 */
@Configuration
@ComponentScan("org.zowe.dbapi")
public class OrgZoweDbapiPackageConfiguration implements PackageConfiguration {
    @Bean
    public PackageConfiguration packageConfiguration() {
        return new OrgZoweDbapiPackageConfiguration();
    }

    public String getPackageName() {
        return "org.zowe.dbapi";
    }
}
