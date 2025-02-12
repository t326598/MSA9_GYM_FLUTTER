package com.gym.gym.service;

import java.util.Comparator;
import java.util.List;
import java.util.stream.Collectors;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.Ranking;
import com.gym.gym.mapper.RankingMapper;

@Service
public class RankingServiceImpl implements RankingService {

    @Autowired
    private RankingMapper rankingMapper;

    @Override
    public List<Ranking> list() throws Exception {
        return rankingMapper.list(new Option(), new Page());
    }

    @Override
    public List<Ranking> list(String keyword) throws Exception {
        Option option = new Option();
        option.setKeyword(keyword);
        return rankingMapper.list(option, new Page());
    }

    @Override
    public List<Ranking> list(Option option) throws Exception {
        return rankingMapper.list(option, new Page());
    }

    @Override
    public List<Ranking> list(Option option, int rows) throws Exception {
        Page page = new Page();
        page.setRows(rows);
        return rankingMapper.list(option, page);
    }

    @Override
    public List<Ranking> list(Option option, Page page) throws Exception {
        int total = count(option);
        page.setTotal(total);
        return rankingMapper.list(option, page);
    }

    @Override
    public int count(Option option) throws Exception {
        return rankingMapper.count(option);
    }

    @Override
    public List<Ranking> getAttendanceRanking() throws Exception {
        List<Ranking> rankingList = rankingMapper.getAttendanceRanking();
        return setRanking(rankingList);
    }

    @Override
    public List<Ranking> getAttendanceRanking(Option option, Page page) throws Exception {
        List<Ranking> rankingList = rankingMapper.getAttendanceRanking(option, page);
        return setRanking(rankingList);
    }

    @Override
    public List<Ranking> getAttendanceRanking(Option option, Page page, int lastRank) throws Exception {
        List<Ranking> rankingList = rankingMapper.getAttendanceRanking(option, page);
        return setRanking(rankingList, lastRank);
    }

    private List<Ranking> setRanking(List<Ranking> rankingList) {
        List<Ranking> sortedList = rankingList.stream()
                .sorted(Comparator.comparingInt(Ranking::getAttendanceCount).reversed())
                .collect(Collectors.toList());

        for (int i = 0; i < sortedList.size(); i++) {
            sortedList.get(i).setRank(i + 1);
        }

        return sortedList;
    }

    private List<Ranking> setRanking(List<Ranking> rankingList, int lastRank) {
        List<Ranking> sortedList = rankingList.stream()
                .sorted(Comparator.comparingInt(Ranking::getAttendanceCount).reversed())
                .collect(Collectors.toList());

        for (int i = 0; i < sortedList.size(); i++) {
            sortedList.get(i).setRank(lastRank + i + 1);
        }

        return sortedList;
    }
}
