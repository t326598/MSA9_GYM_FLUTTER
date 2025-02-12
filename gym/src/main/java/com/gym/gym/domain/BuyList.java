package com.gym.gym.domain;

import java.util.Date;

import lombok.Data;

@Data
public class BuyList {
    
    private int no;
    private int ticketNo;
    private Long userNo;
    private int trainerNo;
    private Date buyDate;
    private Date startDate;
    private Date endDate;
    private Date canceledAt;
    private String status;

    private String userName;     // 사용자 이름
    private String trainerName;  // 트레이너 이름
    private String ticketName;   // 티켓 이름
    private int ticketPrice;    // 티켓 가격
    private int salesCount;     // 판매 수량
}
