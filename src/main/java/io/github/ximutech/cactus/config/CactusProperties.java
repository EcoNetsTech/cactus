package io.github.ximutech.cactus.config;

import io.github.ximutech.cactus.Constants;
import lombok.Data;
import org.springframework.boot.context.properties.ConfigurationProperties;
import org.springframework.boot.context.properties.NestedConfigurationProperty;
import org.springframework.stereotype.Component;

/**
 * @author ximu
 */
@ConfigurationProperties(prefix = Constants.CACTUS)
@Data
public class CactusProperties {

    // 文件输出路径
    private String outputDir = "generate";

    // 作者名称
    private String author = "author";

    // 覆盖已有文件
    private boolean fileOverride = false;

    private boolean open = false;

    @NestedConfigurationProperty
    private DatasourceProperty datasource = new DatasourceProperty();

    @NestedConfigurationProperty
    private TableProperty table = new TableProperty();
}
