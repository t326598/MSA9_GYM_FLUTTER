package com.gym.gym.domain;

import lombok.Data;

@Data
public class PersistenceLogins {
    
    private String userName;
    private String series;
    private String token;
    private String lastUsed;
    
}
