package com.gym.gym.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import lombok.Data;

@Data
public class Plan {
    
    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSX")
    private Date planTime;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSX")
    private Date planEnd;
    
    private int no;
    private int userNo;
    private String planName;
    private String planContent;
}
