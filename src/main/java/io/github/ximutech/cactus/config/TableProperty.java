package io.github.ximutech.cactus.config;

import lombok.Data;

/**
 * @author ximu
 */
@Data
public class TableProperty {

    // 包名
    private String packages = "com.example";

    // 模块名称
    private String modules;

    // 表名称
    private String tableName;

    // 表前缀
    private String prefix;
}
