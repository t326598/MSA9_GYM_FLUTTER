package com.gym.gym.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.Ranking;

@Service
public interface RankingService {

    // 전체 목록
    public List<Ranking> list() throws Exception;

    // 검색
    public List<Ranking> list(String keyword) throws Exception;

    // 검색+옵션
    public List<Ranking> list(Option option) throws Exception;

    // 검색+옵션 + 필터(개수)
    public List<Ranking> list(Option option, int rows) throws Exception;

    // 검색+옵션 + 페이징
    public List<Ranking> list(Option option, Page page) throws Exception;

    // 데이터 개수
    public int count(Option option) throws Exception;

    // 출석 랭킹 조회
    public List<Ranking> getAttendanceRanking() throws Exception;

    // 출석 페이징
    public List<Ranking> getAttendanceRanking(Option option, Page page) throws Exception;

    List<Ranking> getAttendanceRanking(Option option, Page page, int lastRank) throws Exception;

}
