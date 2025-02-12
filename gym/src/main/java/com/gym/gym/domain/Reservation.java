package com.gym.gym.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Reservation {
    
    @DateTimeFormat(pattern = "yyyy-MM-dd HH:mm")
    private Date rvDate;
    
    private int no;
    private Long userNo;
    private int trainerNo;
    private Date createdAt;
    private Date canceledAt;
    private int enabled;
    
    private String userName;
    private String userId;
    private String trainerName;
    private int count;
    private int ptCount;
}