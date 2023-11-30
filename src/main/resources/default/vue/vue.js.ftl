import request from '@/utils/request'

// 查询${table.comment}列表
export function list${entity}(query) {
    return request({
        url: '/${entity?uncap_first}/page',
        method: 'post',
        data: query
    })
}

// 查询${table.comment}详细
export function get${entity}(id) {
    return request({
        url: '/${entity?uncap_first}/' + id,
        method: 'get'
    })
}

// 新增${table.comment}
export function saveOrUpdate(data) {
    return request({
        url: '/${entity?uncap_first}/save',
        method: 'post',
        data: data
    })
}

// 删除${table.comment}
export function del${entity}(id) {
    return request({
        url: '/${entity?uncap_first}/delete/' + id,
        method: 'get'
    })
}

// 导出参数
export function export${entity}(query) {
    return request({
        url: '/${entity?uncap_first}/export',
        method: 'post',
        data: query
    })
}
