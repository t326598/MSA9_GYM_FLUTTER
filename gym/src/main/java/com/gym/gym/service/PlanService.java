package com.gym.gym.service;

import java.util.Date;
import java.util.List;

import com.gym.gym.domain.Plan;

public interface PlanService {
    public List<Plan> listAll() throws Exception;

    public List<Plan> selectByUser(int userNo) throws Exception;

    public List<Plan> selectByUserMonth(int userNo, Date startTime) throws Exception;

    public List<Plan> selectByUserMonthDate(int userNo, Date startTime) throws Exception;
    
    public List<Plan> selectByUserDay(int userNo, Date startTime) throws Exception;
    
    public List<Plan> selectByStartEnd(int userNo, Date startTime, Date endTime) throws Exception;

    public Plan selectByNo(int no) throws Exception;

    public int insert(Plan plan) throws Exception;

    public int update(Plan plan) throws Exception;

    public int delete(int no) throws Exception;
}
