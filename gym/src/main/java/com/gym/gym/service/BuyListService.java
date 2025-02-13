package com.gym.gym.service;

import java.util.List;

import com.gym.gym.domain.BuyList;
import com.gym.gym.domain.Page;

public interface BuyListService {
    
    public List<BuyList> list(String keyword, Page page) throws Exception;

    public int insert(BuyList buyList) throws Exception;

    public int cancel(int no) throws Exception;

    public List<BuyList> listByUser(Long no, Page page) throws Exception;

    public BuyList lastBuyList(Long no) throws Exception;

    public int count(String keyword) throws Exception;
    public int countByUser(Long no) throws Exception;
    

    // 매출 내역
    public List<BuyList> salesList(Integer trainerName, String startDate, String endDate) throws Exception;

    public List<BuyList> ticketByUser(Long no) throws Exception;

}
