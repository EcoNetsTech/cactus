package ${cfg.requestDtoPackage};

<#--import com.ximu.common.model.PageParam;-->
import com.baomidou.mybatisplus.annotation.TableField;
import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import java.time.LocalDateTime;
import java.io.Serializable;

/**
 * <p>
 * ${table.comment!}
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
@Getter
@Setter
<#if cfg.swagger2>
@ApiModel(value="${entity}Request", description="${table.comment!}查询表单")
</#if>
public class ${entity}Request implements Serializable {

    private static final long serialVersionUID = 1L;

<#-- ----------  BEGIN 字段循环遍历  ---------->
<#list table.fields as field>
    <#if !field.keyFlag>
        <#if field.comment!?length gt 0>
            <#if cfg.swagger2>
    @ApiModelProperty(value = "${field.comment}")
            </#if>
        </#if>
<#if field.propertyType == "Date">
    private LocalDateTime ${field.propertyName};
<#else >
    private ${field.propertyType} ${field.propertyName};
</#if>

    </#if>
</#list>
<#------------  END 字段循环遍历  ---------->
<#--    @ApiModelProperty(value = "分页")-->
<#--    @TableField(exist = false)-->
<#--    private PageParam pageParam;-->
}
