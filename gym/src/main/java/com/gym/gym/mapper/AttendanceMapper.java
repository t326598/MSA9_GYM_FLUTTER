package com.gym.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.Attendance;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;

@Mapper
public interface AttendanceMapper {

    public List<Attendance> list(@Param("option") Option option, @Param("page") Page page) throws Exception;

    // 데이터 개수
    public int count(@Param("option") Option option) throws Exception;

    // 출석 내역 조회
    List<Attendance> list() throws Exception;

    // 출석 체크 ( 등록 )
    int insertAttendance(Attendance attendance) throws Exception;

    // 유저 검색
    List<Attendance> getAttendanceByUserNo(int userNo) throws Exception;

    // AttendanceMapper.java 수정
    List<Attendance> searchAttendance(String searchKeyword) throws Exception;

    // 출석 랭킹
    int getAttendanceCountByUserNo(int userNo);

    // 출석 인원
    public int listCount() throws Exception;

    public boolean insertAttendance(String qrId, int userNo);

    // UUID 존재 확인 ㅋ
    public int checkUuidExists(@Param("userNo") Long userNo);
}
