<template>
  <div class="app-container">
    <!-- 查询条件 -->
    <el-form :model="queryParams" ref="queryForm" :inline="true" v-show="showSearch" label-width="68px">
<#list table.fields as field>
<#if !field.keyFlag>
      <el-form-item label="${field.comment}"  prop="${field.propertyName}">
        <el-input v-model="queryParams.${field.propertyName}" placeholder="请输入${field.comment}" clearable size="small" style="width: 240px" @keyup.enter.native="handleQuery" />
      </el-form-item>
</#if>
</#list>
      <el-form-item>
        <el-button type="primary" icon="el-icon-search" size="mini" @click="handleQuery">搜索</el-button>
        <el-button icon="el-icon-refresh" size="mini" @click="resetQuery">重置</el-button>
      </el-form-item>
    </el-form>

    <!-- 操作 -->
    <el-row :gutter="10" class="mb8">
      <el-col :span="1.5">
        <el-button
          type="primary"
          plain
          icon="el-icon-plus"
          size="mini"
          @click="handleAdd"
          v-hasPermi="['system:config:add']"
        >新增</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
          type="success"
          plain
          icon="el-icon-edit"
          size="mini"
          :disabled="single"
          @click="handleUpdate"
          v-hasPermi="['system:config:edit']"
        >修改</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="danger"
            plain
            icon="el-icon-delete"
            size="mini"
            :disabled="multiple"
            @click="handleDelete"
            v-hasPermi="['system:config:remove']"
        >删除</el-button>
      </el-col>
      <el-col :span="1.5">
        <el-button
            type="warning"
            plain
            icon="el-icon-download"
            size="mini"
            :loading="exportLoading"
            @click="handleExport"
            v-hasPermi="['system:config:export']"
        >导出</el-button>
      </el-col>
      <right-toolbar :showSearch.sync="showSearch" @queryTable="getList"></right-toolbar>
    </el-row>

    <!-- 表格 -->
    <el-table v-loading="loading" :data="tableList" @selection-change="handleSelectionChange">
      <el-table-column type="selection" width="50" align="center" />
  <#list table.fields as field>
    <#if !field.keyFlag>
    <#if field.propertyName=="createTime" || field.propertyName=="updateTime" >
      <el-table-column label="${field.comment}" align="center" prop="${field.propertyName}" width="180">
        <template slot-scope="scope">
          <span>{{ parseTime(scope.row.${field.propertyName}) }}</span>
        </template>
      </el-table-column>
    <#elseif field.propertyName == "status" >
      <el-table-column label="状态" align="center" width="80" key="status">
        <template slot-scope="scope">
          <el-tag v-if="scope.row.status==1">正常</el-tag>
          <el-tag v-else-if="scope.row.status==0" type="danger">失效</el-tag>
          <el-tag v-else type="info">未知</el-tag>
        </template>
      </el-table-column>
    <#else >
      <el-table-column label="${field.comment}" align="center" prop="${field.propertyName}" :show-overflow-tooltip="true" />
    </#if>
    </#if>
  </#list>
      <el-table-column label="操作" align="center" class-name="small-padding fixed-width">
        <template slot-scope="scope">
          <el-button
            size="mini"
            type="text"
            icon="el-icon-edit"
            @click="handleUpdate(scope.row)"
            v-hasPermi="['system:config:edit']"
          >修改</el-button>
          <el-button
            size="mini"
            type="text"
            icon="el-icon-delete"
            @click="handleDelete(scope.row)"
            v-hasPermi="['system:config:remove']"
          >删除</el-button>
        </template>
      </el-table-column>
    </el-table>
    <pagination
      v-show="total>0"
      :total="total"
      :page.sync="queryParams.pageParam.current"
      :limit.sync="queryParams.pageParam.size"
      @pagination="getList"
    />

    <!-- 添加表单 -->
    <el-dialog :title="title" :visible.sync="open" width="500px" append-to-body>
      <el-form ref="form" :model="form" :rules="rules" label-width="80px">
          <#list table.fields as field>
          <#if !field.keyFlag>
          <el-form-item label="${field.comment}" prop="${field.propertyName}">
              <el-input v-model="form.${field.propertyName}" placeholder="请输入${field.comment}" @input="change($event)"/>
          </el-form-item>
        <#if field.propertyName=='status'>
          <el-form-item label="状态" prop="status">
            <el-radio-group v-model="form.status">
              <el-radio
                v-for="dict in statusOptions"
                :key="dict.dictValue"
                :label="dict.dictValue"
              >{{dict.dictLabel}}</el-radio>
            </el-radio-group>
          </el-form-item>
        <#else >
          <el-form-item label="${field.comment}" prop="${field.propertyName}">
            <el-input v-model="form.${field.propertyName}" placeholder="请输入${field.comment}" />
          </el-form-item>
        </#if>
          </#if>
          </#list>
      </el-form>
      <!-- 自定义按钮组 -->
      <div slot="footer" class="dialog-footer">
        <el-button type="primary" @click="submitForm">确 定</el-button>
        <el-button @click="cancel">取 消</el-button>
      </div>
    </el-dialog>
  </div>
</template>
<#-- 驼峰转换命名 -->
<#assign entityLow='${entity?replace("([a-z])([A-Z]+)","$1-$2","r")?lower_case}'/>
<script>
  import { list${entity}, get${entity}, del${entity}, saveOrUpdate, export${entity} } from "@/api/system/${entityLow}";

  export default {
    name: '${entity}',
    data() {
      return {
        // 遮罩层
        loading: true,
        // 导出遮罩层
        exportLoading: false,
        // 选中数组
        ids: [],
        // 非单个禁用
        single: true,
        // 非多个禁用
        multiple: true,
        // 显示搜索条件
        showSearch: true,
        // 总条数
        total: 0,
        // 参数表格数据
        tableList: [],
        // 弹出层标题
        title: "",
        // 是否显示弹出层
        open: false,
        // 类型数据字典
        typeOptions: [],
        // 日期范围
        dateRange: [],
        // 表单参数
        form: {},
        // 查询参数
        queryParams: {
          pageParam:{
            current: 1,
            size: 10
          },
      <#list table.fields as field>
      <#if !field.keyFlag>
          ${field.propertyName}: undefined,
      </#if>
      </#list>
        },
        // 表单校验
        rules: {
          <#list table.fields as field>
          <#if !field.keyFlag>
          ${field.propertyName}: [
            { required: true, message: "${field.comment}", trigger: "blur" }
          ],
          </#if>
          </#list>
        }
      }
    },
    created() {
      this.getList();
    },

    methods: {
      /** 查询参数列表 */
      getList() {
        this.loading = true;
        list${entity}(this.addDateRange(this.queryParams, this.dateRange)).then(response => {
          this.tableList = response.data.records;
          this.total = parseInt(response.data.total);
          this.loading = false;
        }
        );
      },
      // 取消按钮
      cancel() {
        this.open = false;
        this.reset();
      },
      // 表单重置
      reset() {
        this.form = {
        <#list table.fields as field>
        <#if !field.keyFlag>
          ${field.propertyName}: undefined,
        </#if>
        </#list>
        };
        this.resetForm("form");
      },
      /** 搜索按钮操作 */
      handleQuery() {
        this.queryParams.pageParam.current = 1;
        this.getList();
      },
      /** 重置按钮操作 */
      resetQuery() {
        this.dateRange = [];
        this.resetForm("queryForm");
        this.handleQuery();
      },
      /** 新增按钮操作 */
      handleAdd() {
        this.reset();
        this.open = true;
        this.title = "添加参数";
      },
      // 多选框选中数据
      handleSelectionChange(selection) {
        this.ids = selection.map(item => item.id)
        this.single = selection.length!=1
        this.multiple = !selection.length
      },
      /** 修改按钮操作 */
      handleUpdate(row) {
        this.reset();
        const ${entityLow}Id = row.id || this.ids
        get${entity}(${entityLow}Id).then(response => {
          this.form = response.data;
          this.open = true;
          this.title = "修改参数";
        });
      },
      /** 提交按钮 */
      submitForm: function() {
        this.$refs["form"].validate(valid => {
          if (valid) {
            saveOrUpdate(this.form).then(response => {
              this.msgSuccess("修改成功");
              this.open = false;
              this.getList();
            });
          }
        });
      },
      /** 删除按钮操作 */
      handleDelete(row) {
        const ${entityLow}Ids = row.id || this.ids;
        this.$confirm('是否确认删除编号为"' + ${entityLow}Ids + '"的数据项?', "警告", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(function() {
          return del${entity}(${entityLow}Ids);
        }).then(() => {
          this.getList();
          this.msgSuccess("删除成功");
        }).catch(() => {});
      },
      /** 导出按钮操作 */
      handleExport() {
        const queryParams = this.queryParams;
        this.$confirm('是否确认导出所有参数数据项?', "警告", {
          confirmButtonText: "确定",
          cancelButtonText: "取消",
          type: "warning"
        }).then(() => {
          this.exportLoading = true;
          return export${entity}(queryParams);
        }).then(response => {
          this.download(response.msg);
          this.exportLoading = false;
        }).catch(() => {});
      }
    }
  }
</script>

<style scoped lang="scss">

</style>
