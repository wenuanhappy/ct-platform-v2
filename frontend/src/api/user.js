import request from '@/utils/request'

export function getUserProfile() {
  return request({
    url: '/api/user/profile',
    method: 'get'
  })
}

export function updateUserProfile(data) {
  return request({
    url: '/api/user/profile',
    method: 'put',
    data
  })
}

export function changePassword(data) {
  return request({
    url: '/api/user/password',
    method: 'put',
    data
  })
}
