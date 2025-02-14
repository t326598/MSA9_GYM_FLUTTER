package com.gym.gym.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.Reservation;

public interface ReservationService {
    
    // 예약 목록
    public Map<String, Object> list(Option option, Page page) throws Exception;

    // 캘린더 예약 목록
    public Map<String, Object> getCalendarData(String keyword, int code) throws Exception;

    // 예약 등록 페이지 조회
    public Map<String, Object> getMyTrainer(int trainerNo, Long userNo, Page page) throws Exception; 

    // 회원 내 예약 목록
    public Map<String, Object> getMyReservation(Long userNo, Page page) throws Exception;

    // 예약 등록
    public int insert(Reservation reservation, Long userNo) throws Exception;

    // 예약 완료(수정)
    public int complete(int no, String action) throws Exception;

    // 예약 취소(수정)
    public int cancel(int no) throws Exception;

    public List<Reservation> selectByStartEnd (int userNo, Date startTime, Date endTime) throws Exception;

}