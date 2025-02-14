package com.gym.gym.service;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.Reservation;
import com.gym.gym.domain.TrainerProfile;
import com.gym.gym.domain.Users;
import com.gym.gym.mapper.ReservationMapper;

import lombok.extern.slf4j.Slf4j;


@Slf4j
@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    @Autowired
    private TrainerProfileService trainerProfileService;

    // 관리자 예약 목록
    @Override
    public Map<String, Object> list(Option option, Page page) throws Exception {
        int total = reservationMapper.count(option, option.getKeyword());
        page.setTotal(total);

        String pageUrl = String.format("/api/admin/reservation/list?keyword=%s&code=%s&rows=%d&orderCode=%s",
                    option.getKeyword(), option.getCode(), page.getRows(), option.getOrderCode());

        List<Reservation> reservationList = reservationMapper.list(option, page);
        
        return Map.of(
            "reservationList", reservationList,
            "pageUrl", pageUrl,
            "option", option,
            "page", page
            );
    }

    // 캘린더 예약 조회
    @Override
    public Map<String, Object> getCalendarData(String keyword, int code) throws Exception {

        List<Users> trainerUsers = reservationMapper.trainerUsers();
        
        List<Map<String, Object>> reservationResponse = new ArrayList<>();
        SimpleDateFormat timeFormat = new SimpleDateFormat("HH:mm");
        List<Reservation> sortByTrainer = reservationMapper.sortByTrainer(keyword, code);

            for (Reservation rv : sortByTrainer) {
                Map<String, Object> response = new HashMap<>();
                String formattedTime = timeFormat.format(rv.getRvDate());

                response.put("start", rv.getRvDate());
                response.put("end", "");
                response.put("description", "");
                response.put("textColor", "white");
                response.put("user_no", rv.getUserNo());

                if (rv.getEnabled() == 0) {
                    continue;
                }
                if (rv.getEnabled() == 2) {
                    response.put("title", formattedTime + " " + rv.getUserName() + "님 완료");
                    response.put("color", "#2a9c1b");
                    response.put("type", "completed");
                } else if (rv.getEnabled() == 1) {
                    response.put("title", formattedTime + " " + rv.getUserName() + "님 예약");
                    response.put("color", "cornflowerblue");
                    response.put("type", "reservation");
                }
                reservationResponse.add(response);
            }

        return Map.of(
            "trainerUserList", trainerUsers,
            "reservationList", reservationResponse
            );
    }

    // 회원 예약 데이터 구하는 공통 메서드
    private Map<String, Object> getMyReservationData(Long userNo, Page page) throws Exception {
        Option option = new Option();
        int total = reservationMapper.count(option, option.getKeyword());
        page.setTotal(total);

        List<Reservation> reservationList = reservationMapper.userByList(userNo, page);
        int disabledCount = reservationMapper.disabledCount(userNo);

        Reservation lastReservation = reservationList.get(reservationList.size() - 1);
        int ptCount = lastReservation.getPtCount();
        ptCount -= disabledCount;
        
        log.info("남은 PT횟수 : " + ptCount);
        log.info("완료 PT횟수 : " + disabledCount);

        return Map.of(
            "ptCount", ptCount,
            "disabledCount", disabledCount,
            "reservationList", reservationList,
            "page", page
        );
    }

    // 회원 예약 목록
    @Override
    public Map<String, Object> getMyReservation(Long userNo, Page page) throws Exception {
        return getMyReservationData(userNo, page);
    }

    // 예약 등록 정보 조회
    @Override
    public Map<String, Object> getMyTrainer(int trainerNo, Long userNo, Page page) throws Exception {

        TrainerProfile trainerProfile = trainerProfileService.selectTrainer(trainerNo);
        int code = 1;
        log.info("담당 트레이너 번호 : " + trainerNo);

        List<Reservation> reservationListByTrainer = reservationMapper.sortByTrainer(String.valueOf(trainerNo), code);
        log.info("담당 트레이너 예약 데이터 확인 : " + reservationListByTrainer);

        return Map.of(
            "myReservation", getMyReservationData(userNo, page),
            "trainerProfile", trainerProfile,
            "reservationListByTrainer", reservationListByTrainer
        );

    }

    // 예약 등록 처리
    @Override
    public int insert(Reservation reservation, Long userNo) throws Exception {
        reservation.setUserNo(userNo);
        return reservationMapper.insert(reservation);
    }
    
    // 예약 완료(수정)
    @Override
    public int complete(int no, String action) throws Exception {
        Reservation reservation = reservationMapper.findByNo(no);
        int result = 0;

        if ("complete".equals(action)) {
            reservation.setCanceledAt(new Date());
            reservation.setEnabled(2);
            result = reservationMapper.complete(reservation);

            
        } else {
            reservation.setCanceledAt(new Date());
            reservation.setEnabled(0);
            result = reservationMapper.cancel(reservation);
        }
        return result;
    }

    // 예약 취소(수정)
    @Override
    public int cancel(int no) throws Exception {
        Reservation reservation = reservationMapper.findByNo(no);
        reservation.setCanceledAt(new Date());
        reservation.setEnabled(0);

        return reservationMapper.cancel(reservation);
    }

    @Override
    public List<Reservation> selectByStartEnd(int userNo, Date startTime, Date endTime) throws Exception {
        return reservationMapper.selectByStartEnd(userNo, startTime, endTime);
    }

}