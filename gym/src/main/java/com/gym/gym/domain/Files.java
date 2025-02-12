package com.gym.gym.domain;

import java.util.Date;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class Files {
    
    private int no;
    private int profileNo;
    private String type;
    private String name;
    private String path;
    private Long size;
    private Date createdAt;
    private Date updatedAt;

    private MultipartFile file;
    
}
