package com.ctplatform.dto;

import lombok.Data;

@Data
public class UpdateProfileRequest {
    private String email;
    private String avatar;
}
