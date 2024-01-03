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

    @Bean
    public CactusGenerator cactusGenerator(CactusProperties cactusProperties){
        return new CactusGenerator(cactusProperties);
    }


}
