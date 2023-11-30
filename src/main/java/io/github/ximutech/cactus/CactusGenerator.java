package io.github.ximutech.cactus;

import com.baomidou.mybatisplus.annotation.DbType;
import com.baomidou.mybatisplus.core.toolkit.StringPool;
import com.baomidou.mybatisplus.generator.AutoGenerator;
import com.baomidou.mybatisplus.generator.InjectionConfig;
import com.baomidou.mybatisplus.generator.config.*;
import com.baomidou.mybatisplus.generator.config.po.TableInfo;
import com.baomidou.mybatisplus.generator.config.rules.DateType;
import com.baomidou.mybatisplus.generator.config.rules.NamingStrategy;
import com.baomidou.mybatisplus.generator.engine.FreemarkerTemplateEngine;
import io.github.ximutech.cactus.config.CactusConfigBean;
import io.github.ximutech.cactus.config.CactusProperties;
import io.github.ximutech.cactus.config.DatasourceProperty;
import io.github.ximutech.cactus.config.TableProperty;
import io.github.ximutech.cactus.util.SpringContextHolder;

import java.util.*;

/**
 * @author ximu
 */
public class CactusGenerator  {

    private CactusConfigBean cactusConfigBean;

    public void execute(){
        cactusConfigBean = SpringContextHolder.getBean(CactusConfigBean.class);

        // 代码生成器
        AutoGenerator mpg = new AutoGenerator();

        // 全局配置
        buildGlobalConfig(mpg);

        // 配置数据库
        buildDatasource(mpg);

        // 策略配置
        buildStrategyConfig(mpg);

        // 模板配置
        buildTemplate(mpg);

        // 模板引擎 选择 freemarker 引擎需要指定如下加，注意 pom 依赖必须有！
        mpg.setTemplateEngine(new FreemarkerTemplateEngine());

        // 模板路径配置
        TemplateConfig tc = new TemplateConfig();
        tc.setController("/default/simple/controller.java")
                .setService("/default/simple/service.java")
                .setServiceImpl("/default/simple/serviceImpl.java")
                .setEntity("/default/simple/entity.java")
                .setXml("")
                .setMapper("/default/simple/mapper.java");
        mpg.setTemplate(tc);

        mpg.execute();
    }

    // 构建全局配置
    private void buildGlobalConfig(AutoGenerator mpg) {
        CactusProperties cactusProperties = cactusConfigBean.getCactusProperties();

        GlobalConfig gc = new GlobalConfig()
                // 是否覆盖已有文件
                .setFileOverride(cactusProperties.isFileOverride())
                //开启 BaseResultMap
                .setBaseResultMap(true)
                //开启 baseColumnList
                .setBaseColumnList(true)
                // 是否打开输出目录
                .setOpen(cactusProperties.isOpen())
                // 时间类型对应策略
                .setDateType(DateType.ONLY_DATE)
                .setMapperName("%sMapper")
                // 修改service名称
                .setServiceName("%sService")
                // 修改serviceImpl名称
                .setServiceImplName("%sServiceImpl")
                // 生成文件的输出目录
                .setOutputDir(getOutputFile(cactusProperties.getOutputDir()))
                // 作者名称
                .setAuthor(cactusProperties.getAuthor());

        mpg.setGlobalConfig(gc);
    }

    // 构建数据库配置
    private void buildDatasource(AutoGenerator mpg) {
        DatasourceProperty datasource = cactusConfigBean.getCactusProperties().getDatasource();

        DataSourceConfig dsc = new DataSourceConfig();
        dsc.setUrl(datasource.getUrl())
                .setDbType(DbType.getDbType(datasource.getType()))
                .setDriverName(datasource.getDriverName())
                .setUsername(datasource.getUsername())
                .setPassword(datasource.getPassword());
        mpg.setDataSource(dsc);
    }

    // 构建策略配置
    private void buildStrategyConfig(AutoGenerator mpg){
        TableProperty table = cactusConfigBean.getCactusProperties().getTable();

        // 包配置
        PackageConfig pc = new PackageConfig();
        String packages = table.getPackages();
        String models = Optional.ofNullable(table.getModules()).orElse("");

        pc.setParent(packages) //包名
                .setModuleName(models) //父包模块名
                .setController("controller")
                .setEntity("model")
                .setService("service")
                .setServiceImpl("service.impl")
                .setMapper("mapper")
                .setXml("xml");
        mpg.setPackageInfo(pc);


        // 策略配置
        StrategyConfig strategy = new StrategyConfig();
        //下划线转驼峰命名
        strategy.setNaming(NamingStrategy.underline_to_camel)
                // 是否为lombok模型
                .setEntityLombokModel(true)
                // 自定义继承的Controller类全称
//                .setSuperControllerClass(BaseController.class)
//                // 自定义继承的Entity类全称
//                .setSuperEntityClass(PageModel.class)
//                // 自定义基础的Entity类，公共字段
////                .setSuperEntityColumns("create_by","create_date","update_by","update_date","del_flag","remark")
//                //自定义继承的ServiceImpl类全称
//                .setSuperServiceImplClass(BaseService.class)
                // 需要包含的表名，允许正则表达式
                .setInclude(table.getTableName().split(","))
                //驼峰转连字符
                .setControllerMappingHyphenStyle(true)
                // 生成 <code>@RestController</code> 控制器
                .setRestControllerStyle(true)
                // 表前缀
                .setTablePrefix(table.getPrefix().split(","));
        mpg.setStrategy(strategy);
    }

    // 构建模板配置
    private void buildTemplate(AutoGenerator mpg) {
        TableProperty table = cactusConfigBean.getCactusProperties().getTable();
        // 注入自定义配置，可以在 VM 中使用 cfg.abc 【可无】  ${cfg.abc}
        final String parent = mpg.getPackageInfo().getParent();

        InjectionConfig config = new InjectionConfig() {
            @Override
            public void initMap() {
                Map<String, Object> map = new HashMap<String, Object>();
                map.put("swagger2", true);
                // 支持mybatis-plus
                map.put("mybatisPlus", true);
                map.put("controllerPackage", parent + StringPool.DOT + "api");
                map.put("requestDtoPackage", parent + StringPool.DOT + "model");
                map.put("superTableName", convertToCamelCase(table.getTableName()));
                this.setMap(map);
            }
        };

        List<FileOutConfig> focList = new ArrayList<>();

        // 重写xml
        generXml(focList);

        // 生成DTO
        generDTO(focList);

        // 生成Request
        generRequest(focList);

        config.setFileOutConfigList(focList);
        mpg.setCfg(config);
    }
    private void generDTO(List<FileOutConfig> focList) {
        CactusProperties cactusProperties = cactusConfigBean.getCactusProperties();
        TableProperty table = cactusProperties.getTable();

        String modules = Optional.ofNullable(table.getModules()).orElse("");
        StringBuffer stringBuffer = new StringBuffer();
        String requestPackage = stringBuffer
                .append(getOutputFile(cactusProperties.getOutputDir()))
                .append(table.getPackages())
                .append(StringPool.DOT)
                .append(modules)
                .append(StringPool.DOT)
                .append("model")
                .append(StringPool.DOT).toString().replace(StringPool.DOT, StringPool.SLASH);

        focList.add(new FileOutConfig("/default/dto/dto.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return requestPackage + tableInfo.getEntityName() + "DTO.java";
            }
        });
    }

    private void generRequest(List<FileOutConfig> focList) {
        CactusProperties cactusProperties = cactusConfigBean.getCactusProperties();
        TableProperty table = cactusProperties.getTable();

        String modules = Optional.ofNullable(table.getModules()).orElse("");
        StringBuffer stringBuffer = new StringBuffer();
        String requestPackage = stringBuffer
                .append(getOutputFile(cactusProperties.getOutputDir()))
                .append(table.getPackages())
                .append(StringPool.DOT)
                .append(modules)
                .append(StringPool.DOT)
                .append("model")
                .append(StringPool.DOT).toString().replace(StringPool.DOT, StringPool.SLASH);

        focList.add(new FileOutConfig("/default/dto/list-request.java.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                return requestPackage + tableInfo.getEntityName() + "Request.java";
            }
        });
    }

    private void generXml(List<FileOutConfig> focList) {
        CactusProperties cactusProperties = cactusConfigBean.getCactusProperties();
        TableProperty table = cactusProperties.getTable();

        focList.add(new FileOutConfig("/default/simple/mapper.xml.ftl") {
            @Override
            public String outputFile(TableInfo tableInfo) {
                StringBuffer stringBuffer = new StringBuffer();
                return stringBuffer.append(getOutputFile(cactusProperties.getOutputDir()))
                        .append("xml/").append(table.getModules())
                        .append(StringPool.SLASH).append(tableInfo.getEntityName())
                        .append("Mapper.xml").toString();
            }
        });
    }

    // 下划线变驼峰
    public static String convertToCamelCase(String input) {
        StringBuilder result = new StringBuilder();
        String[] words = input.split("_");

        for (int i = 0; i < words.length; i++) {
            String word = words[i];
            if (i == 0) {
                result.append(word.toLowerCase());
            } else {
                result.append(Character.toUpperCase(word.charAt(0)));
                result.append(word.substring(1).toLowerCase());
            }
        }

        return result.toString();
    }

    // 获取文件输出目录
    private String getOutputFile(String outputFile){
        return outputFile.endsWith("/") ? outputFile : outputFile + "/";
    }

}
