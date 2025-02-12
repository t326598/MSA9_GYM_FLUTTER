package com.gym.gym.service;

import java.util.Date;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.Reservation;
import com.gym.gym.domain.Users;
import com.gym.gym.mapper.ReservationMapper;

@Service
public class ReservationServiceImpl implements ReservationService {

    @Autowired
    private ReservationMapper reservationMapper;

    // 예약 등록
    @Override
    public int insert(Reservation reservation) throws Exception {
        int result = reservationMapper.insert(reservation);
        return result;
    }

    // 예약 목록
    @Override
    public List<Reservation> list(Option option, Page page) throws Exception {
        int total = count(option, option.getKeyword());
        page.setTotal(total);

        // reservationMapper.ptComplete();
        List<Reservation> reservationList = reservationMapper.list(option, page);
        return reservationList;
    }
    
    // 예약 조회
    @Override
    public Reservation findByNo(int no) throws Exception {
        Reservation reservation = reservationMapper.findByNo(no);
        return reservation;
    }
    
    // 예약 완료(수정)
    @Override
    public int complete(Reservation reservation) throws Exception {
        int result = reservationMapper.complete(reservation);
        return result;
    }

    // 예약 취소(수정)
    @Override
    public int cancel(Reservation reservation) throws Exception {
        int result = reservationMapper.cancel(reservation);
        return result;
    }
    
    // 트레이너 리스트
    @Override
    public List<Users> trainerUsers() throws Exception {
        List<Users> trainerUsers = reservationMapper.trainerUsers();
        return trainerUsers;
    }

    // 트레이너별 예약 목록
    @Override
    public List<Reservation> sortByTrainer(String keyword, int code) throws Exception {
        List<Reservation> sortByTrainer = reservationMapper.sortByTrainer(keyword, code);
        return sortByTrainer;
    }
    
    @Override
    public List<Map<String, Object>> countByDate(Option option) throws Exception {
        return reservationMapper.countByDate(option);
    }

    @Override
    public int count(Option option, String keyword) throws Exception {
        return reservationMapper.count(option,keyword);
    }

    @Override
    public List<Reservation> selectByStartEnd(int userNo, Date startTime, Date endTime) throws Exception {
        return reservationMapper.selectByStartEnd(userNo, startTime, endTime);
    }

    @Override
    public List<Reservation> userByList(Long no, Page page) throws Exception {
        
        int total = reservationMapper.countByUser(no);
        page.setTotal(total);

        // reservationMapper.ptComplete();

        return reservationMapper.userByList(no, page);
    }

    @Override
    public int disabledCount(Long no) throws Exception {
        return reservationMapper.disabledCount(no);
    }


}