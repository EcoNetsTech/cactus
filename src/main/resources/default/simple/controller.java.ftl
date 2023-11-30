package ${cfg.controllerPackage};


import com.baomidou.mybatisplus.core.conditions.query.QueryWrapper;
import com.baomidou.mybatisplus.core.metadata.IPage;
import com.ximu.common.enums.BusinessTypeEnum;
import com.ximu.service.core.annotation.Log;
import io.swagger.annotations.Api;
import io.swagger.annotations.ApiImplicitParam;
import io.swagger.annotations.ApiOperation;
import io.swagger.annotations.ApiParam;
import com.ximu.common.model.Result;
import com.ximu.common.enums.StatusEnum;
import ${package.Entity}.${entity};
import ${package.Entity}.${entity}Request;
import ${package.Service}.${table.serviceName};
import org.springframework.web.bind.annotation.*;
<#if superControllerClassPackage??>
import ${superControllerClassPackage};
</#if>

import javax.annotation.Resource;
import java.util.List;

/**
 * <p>
 * ${table.comment!}
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
<#if restControllerStyle>
@RestController
<#else>
@Controller
</#if>
<#--@RequestMapping("<#if package.ModuleName?? && package.ModuleName != "">/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${controllerMappingHyphen}<#else>${table.entityPath}</#if>")-->
@RequestMapping("<#if package.ModuleName?? && package.ModuleName != "">/${package.ModuleName}</#if>/<#if controllerMappingHyphenStyle??>${cfg.superTableName}<#else>${table.entityPath}</#if>")
@Api(value = "${table.controllerName}", tags = {"${table.comment!}操作接口"})
<#if superControllerClass??>
public class ${table.controllerName} extends ${superControllerClass}<${table.serviceImplName},${entity}> {
<#else>
public class ${table.controllerName} {
</#if>

    @Resource
    ${table.serviceName} ${table.serviceName?uncap_first};

    @PostMapping("/save")
    @ApiOperation("添加或编辑")
    public Result save(@RequestBody ${entity} ${entity?uncap_first}){
        ${table.serviceName?uncap_first}.saveOrUpdate(${entity?uncap_first});
        return Result.success();
    }

    @GetMapping("/delete/{id}")
    @ApiOperation("删除系统参数")
    @Log(title = "删除登录记录", businessType = BusinessTypeEnum.DELETE)
    public Result delete(@PathVariable("id") Long id){
        ${table.serviceName?uncap_first}.removeById(id);
        return Result.success();
    }

    @PostMapping("/page")
    @ApiOperation(value = "${table.comment!}分页查询")
    public Result pageList(@RequestBody ${entity}Request ${entity?uncap_first}Request) {
        IPage<${entity}> page = ${table.serviceName?uncap_first}.page(${entity?uncap_first}Request.getPageParam().getPage());
        return Result.success(page);
    }

    @PostMapping("/list")
    @ApiOperation(value = "${table.comment!}列表")
    public Result list(@RequestBody ${entity} ${entity?uncap_first}){
        List<${entity}> list = ${table.serviceName?uncap_first}.list(new QueryWrapper<${entity}>(${entity?uncap_first}));
        return Result.success(list);
    }

}
