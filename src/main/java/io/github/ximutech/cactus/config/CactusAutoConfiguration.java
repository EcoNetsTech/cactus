package io.github.ximutech.cactus.config;

import io.github.ximutech.cactus.CactusGenerator;
import io.github.ximutech.cactus.util.SpringContextHolder;
import org.springframework.boot.autoconfigure.AutoConfiguration;
import org.springframework.boot.autoconfigure.condition.ConditionalOnMissingBean;
import org.springframework.boot.context.properties.EnableConfigurationProperties;
import org.springframework.context.annotation.Bean;

/**
 * @author ximu
 */
@AutoConfiguration
@EnableConfigurationProperties(CactusProperties.class)
public class CactusAutoConfiguration {

    private final CactusProperties cactusProperties;

    public CactusAutoConfiguration(CactusProperties cactusProperties) {
        this.cactusProperties = cactusProperties;
    }

    @Bean
    public SpringContextHolder springContextHolder(){
        return new SpringContextHolder();
    }

    @Bean
    public CactusConfigBean cactusConfigBean(){
        CactusConfigBean cactusConfigBean = new CactusConfigBean(cactusProperties);

        return cactusConfigBean;
    }

    @Bean
    public CactusGenerator cactusGenerator(){
        return new CactusGenerator();
    }


}
