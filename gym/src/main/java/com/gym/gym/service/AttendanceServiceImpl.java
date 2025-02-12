package com.gym.gym.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Attendance;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.QRcode;
import com.gym.gym.mapper.AttendanceMapper;
import com.gym.gym.mapper.QRcodeMapper;

@Service
public class AttendanceServiceImpl implements AttendanceService {

    @Autowired
    private AttendanceMapper attendanceMapper;

    @Autowired
    private QRcodeMapper qRcodeMapper;

    // 유저 출석 내역 조회
    @Override
    public List<Attendance> list() throws Exception {
        return attendanceMapper.list();
    }

    // 출석 체크 ( 등록 )
    @Override
    public int insertAttendance(Attendance attendance) throws Exception {
        return attendanceMapper.insertAttendance(attendance);
    }

    // 유저 출석 내역 조회
    @Override
    public List<Attendance> getAttendanceByUserNo(int userNo) throws Exception {
        return attendanceMapper.getAttendanceByUserNo(userNo);
    }

    // AttendanceServiceImpl.java 수정
    @Override
    public List<Attendance> searchAttendance(String searchKeyword) throws Exception {
        return attendanceMapper.searchAttendance(searchKeyword);
    }

    // 검색
    @Override
    public List<Attendance> list(String keyword) throws Exception {
        Option option = new Option();
        option.setKeyword(keyword);
        List<Attendance> attendanceList = attendanceMapper.list(new Option(), new Page());
        return attendanceList;
    }

    // 검색 + 옵션
    @Override
    public List<Attendance> list(Option option) throws Exception {
        List<Attendance> attendanceList = attendanceMapper.list(option, new Page());
        return attendanceList;
    }

    @Override
    public List<Attendance> list(Option option, int rows) throws Exception {
        List<Attendance> attendanceList = attendanceMapper.list(option, new Page());
        return attendanceList;
    }

    @Override
    public List<Attendance> list(Option option, Page page) throws Exception {
        int total = count(option); // 전체 게시글 개수
        page.setTotal(total); // 페이징 정보 설정

        List<Attendance> attendanceList = attendanceMapper.list(option, page);
        return attendanceList;
    }

    @Override
    public int count(Option option) throws Exception {
        return attendanceMapper.count(option);
    }

    @Override
    public int getAttendanceCountByUserNo(int userNo) throws Exception {
        return attendanceMapper.getAttendanceCountByUserNo(userNo);
    }

    @Override
    public int listCount() throws Exception {
        return attendanceMapper.listCount();
    }

    @Override
    public QRcode selectQRcode(Long userNo) throws Exception {
        QRcode qrCode = qRcodeMapper.selectQRcode(userNo);
        return qrCode;

    }
}
