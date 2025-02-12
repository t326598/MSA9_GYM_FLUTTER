package com.gym.gym.domain;


import java.util.Date;

import lombok.Data;

@Data
public class Answer {
    
    private Long no;
    private Long boardNo;
    private Long userNo;
    private String content;
    private Date createdAt;
    private Date updatedAt;
    
    private String name;
    private Board board;
}
