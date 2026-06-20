package com.ctplatform.dto;

import lombok.AllArgsConstructor;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
public class ModuleInfo {
    private String id;
    private String name;
    private String description;
    private String color;
    private String icon;
    private String content;
}
