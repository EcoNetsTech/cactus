package io.github.ximutech.cactus.config;

import lombok.Data;

/**
 * @author ximu
 */
@Data
public class CactusConfigBean {

    private final CactusProperties cactusProperties;

    public CactusConfigBean(CactusProperties cactusProperties) {
        this.cactusProperties = cactusProperties;
    }
}
