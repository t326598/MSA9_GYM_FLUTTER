package com.gym.gym.domain;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class TrainerProfile {
    
    private int no;
    private int trainerNo;
    private String name;
    private String simpleInfo;
    private String detailInfo;

    private List<MultipartFile> FileList;
    
    private int FileNo;
    private int userCount;
    private String userId;
    private String userName;
    private Long userNo;
}