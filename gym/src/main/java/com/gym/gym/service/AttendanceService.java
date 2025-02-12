package com.gym.gym.service;

import java.util.List;

import org.springframework.stereotype.Service;

import com.gym.gym.domain.Attendance;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.QRcode;


@Service
public interface AttendanceService {

    // 출석 내역 조회
    List<Attendance> list() throws Exception;

    // 검색
    public List<Attendance> list(String keyword) throws Exception;

    // 검색+옵션
    public List<Attendance> list(Option option) throws Exception;

    // 검색+옵션 + 필터(개수)
    public List<Attendance> list(Option option, int rows) throws Exception;

    // 검색+옵션 + 페이징
    public List<Attendance> list(Option option, Page page) throws Exception;

    // 데이터 개수
    public int count(Option option) throws Exception;

    // 출석 체크 ( 등록 )
    int insertAttendance(Attendance attendance) throws Exception;

    // 유저 출석 내역 조회
    List<Attendance> getAttendanceByUserNo(int userNo) throws Exception;

    // 출석 내역 검색 (유저 번호와 키워드로)
    List<Attendance> searchAttendance(String searchKeyword) throws Exception;

    // 유저별 출석 횟수 조회
    int getAttendanceCountByUserNo(int userNo) throws Exception; // 여기에 추가

    // 출석 인원수 조회
    public int listCount() throws Exception;

    // UUID 체크
    public QRcode selectQRcode(Long userNo) throws Exception;

}
