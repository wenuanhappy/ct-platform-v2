import request from '@/utils/request'

export function getModuleList() {
  return request({
    url: '/api/modules',
    method: 'get'
  })
}

export function getModuleDetail(id) {
  return request({
    url: `/api/modules/${id}`,
    method: 'get'
  })
}
