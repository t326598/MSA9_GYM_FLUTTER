package com.gym.gym.domain;

import lombok.Data;

@Data
public class ChangePwRequest {
    private String password;
    private String newPassword;
}
