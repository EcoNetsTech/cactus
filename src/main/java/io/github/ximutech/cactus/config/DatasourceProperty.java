package io.github.ximutech.cactus.config;

import com.baomidou.mybatisplus.annotation.DbType;
import lombok.Data;

/**
 * @author ximu
 */
@Data
public class DatasourceProperty {

    /**
     * 数据库类型
     * {@link DbType}
     *
     * return 数据库类型
     */
    private String type = "mysql";

    private String url;

    private String driverName;

    private String username;

    private String password;
}
