package ${package.Service};

import com.baomidou.mybatisplus.extension.service.IService;
import ${package.Entity}.${entity};
import ${superServiceClassPackage};

/**
 * <p>
 * ${table.comment!} 服务类
 * </p>
 *
 * @author ${author}
 * @since ${date}
 */
<#if cfg.mybatisPlus>
public interface ${table.serviceName} extends IService<${entity}> {

}
<#else>
public interface ${table.serviceName} extends ${superServiceClass}<${entity}> {

}
</#if>
