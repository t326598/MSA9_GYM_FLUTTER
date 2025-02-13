package com.gym.gym.domain;

import java.util.Date;

import org.apache.ibatis.type.Alias;

import lombok.Data;

@Data
@Alias("Attendance")
public class Attendance {

    private String qrId; // QR 코드 ID
    private Long userNo; // 회원 번호
    private Date checkTime; // 출석 시간
    private Users users; // Users 객체 (회원 정보)
    private int attendanceCount; // 출석 횟수
    private int rank; // 순위
    private String userId;
}
