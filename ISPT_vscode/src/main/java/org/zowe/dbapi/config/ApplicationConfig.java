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

import org.springdoc.core.SpringDocConfigProperties;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.beans.factory.annotation.Value;
import org.springframework.boot.context.event.ApplicationReadyEvent;
import org.springframework.context.ApplicationListener;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.ComponentScan;
import org.springframework.context.annotation.Configuration;
import com.broadcom.restapi.sdk.lifecycle.ServiceStartupEventHandler;
import org.springframework.context.annotation.Primary;

import java.util.ArrayList;
import java.util.List;
import java.util.Optional;
import java.util.stream.Collectors;

@Configuration
@ComponentScan({"com.broadcom.restapi.sdk","com.broadcom.dbapi"})
public class ApplicationConfig implements ApplicationListener<ApplicationReadyEvent> {

    @Value("${apiml.service.title}")
    private String serviceTitle;

    @Autowired
    private Optional<ServiceStartupEventHandler> serviceStartupEventHandler;

    @Override
    public void onApplicationEvent(final ApplicationReadyEvent event) {
        serviceStartupEventHandler.ifPresent(startupEventHandler -> startupEventHandler.onServiceStartup(serviceTitle, ServiceStartupEventHandler.DEFAULT_DELAY_FACTOR));
    }

    @Bean
    @Primary
    public SpringDocConfigProperties addPackagesToScan(SpringDocConfigProperties properties, List<PackageConfiguration> packageConfigurationList) {
        properties.setPackagesToScan(packageConfigurationList.stream().map(PackageConfiguration::getPackageName).collect(Collectors.toCollection(ArrayList::new)));
        properties.getPackagesToScan().add("com.broadcom");
        return properties;
    }
}
