package com.gym.gym.domain;

import lombok.Data;

@Data
public class Ticket {
    
    private int no;
    private String name;
    private int price;
    private String info;
    private String type;
    private int months;
    private int ptCount;
    
}
