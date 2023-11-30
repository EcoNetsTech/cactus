package ${cfg.requestDtoPackage};

import io.swagger.annotations.ApiModel;
import io.swagger.annotations.ApiModelProperty;
import lombok.Getter;
import lombok.Setter;
import org.springframework.beans.BeanUtils;
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
@ApiModel(value="${entity}DTO", description="${table.comment!}查询表单")
</#if>
public class ${entity}DTO implements Serializable {

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
    public ${entity} convertBO(${entity}DTO ${entity?uncap_first}DTO) {
        ${entity} ${entity?uncap_first} = new ${entity}();
        BeanUtils.copyProperties(${entity?uncap_first}DTO, ${entity?uncap_first});
        return ${entity?uncap_first};
    }
}
