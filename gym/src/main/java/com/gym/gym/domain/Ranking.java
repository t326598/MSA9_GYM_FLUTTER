package com.gym.gym.domain;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Alias("Ranking")
@Data
public class Ranking {

    private String userId;
    private int attendanceCount;
    private int rank;
}
