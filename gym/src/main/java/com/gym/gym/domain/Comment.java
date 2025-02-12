package com.gym.gym.domain;

import java.util.Date;

import org.springframework.format.annotation.DateTimeFormat;

import com.fasterxml.jackson.annotation.JsonFormat;

import lombok.Data;

@Data
public class Comment {

    private int no;

    @DateTimeFormat(pattern = "yyyy-MM-dd'T'HH:mm:ss.SSSX")
    private Date commentDate;
    private int trainerNo;
    private int userNo;
    private String cContent;
    private String fContent;
    
}
