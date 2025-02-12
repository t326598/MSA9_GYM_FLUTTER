package com.gym.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.BuyList;
import com.gym.gym.domain.Page;

@Mapper
public interface BuyListMapper {

    // public List<BuyList> list() throws Exception;
    public List<BuyList> list(@Param("keyword") String keyword, @Param("page") Page page) throws Exception;
    
    public int insert(BuyList buyList) throws Exception;
    public int updateTrainer(@Param("trainerNo") int trainerNo, @Param("userNo") Long userNo) throws Exception;
    
    public int cancel(int no) throws Exception;

    public List<BuyList> listByUser(@Param("userNo") Long no, @Param("page") Page page) throws Exception;

    public BuyList lastBuyList(Long no) throws Exception;
    

    public int statusUpdate() throws Exception;

    public int count(@Param("keyword") String keyword) throws Exception;
    public int countByUser(Long no) throws Exception;

    // 매출 내역
    public List<BuyList> salesList(@Param("trainerNo") Integer trainerNo, 
                                   @Param("startDate") String startDate, 
                                   @Param("endDate") String endDate 
                                   ) throws Exception;

    public List<BuyList> ticketByUser(Long no) throws Exception;
}
