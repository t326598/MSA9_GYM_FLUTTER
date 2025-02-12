package com.gym.gym.domain;

import java.util.Date;
import java.util.List;

import lombok.Data;

@Data
public class Users {
    
    private Long no;
    private String id;
    private String password;
    private String name;
    private String phone;
    private String email;
    private String birth;
    private String gender;
    private int enabled;
    private int trainerNo;
    private String code;

    private String question;
    private String answer;
    private Date createdAt;
    private Date updatedAt;

    
    private String  userAuth;
    private List<UserAuth> authList;

    private String trainerName;

    

}
