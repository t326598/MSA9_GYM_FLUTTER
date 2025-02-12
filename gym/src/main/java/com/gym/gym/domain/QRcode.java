package com.gym.gym.domain;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("QRcode")
public class QRcode {
    
    private long no;
    private Long userNo;
    private String uuid;
    private Date createdAt;
    
}
