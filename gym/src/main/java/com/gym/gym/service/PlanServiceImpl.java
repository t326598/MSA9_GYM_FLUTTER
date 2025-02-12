package com.gym.gym.service;

import java.time.DayOfWeek;
import java.time.LocalDateTime;
import java.time.ZoneId;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Plan;
import com.gym.gym.mapper.PlanMapper;

@Service
public class PlanServiceImpl implements PlanService {
    
    @Autowired
    PlanMapper planMapper;
    
    @Override
    public List<Plan> listAll() throws Exception {
        List<Plan> planList = planMapper.listAll(); 
        return planList;
    }
    
    @Override
    public List<Plan> selectByUser(int userNo) throws Exception {
        List<Plan> planList = planMapper.selectByUser(userNo);
        return planList;
    }

    @Override
    public List<Plan> selectByUserMonth(int userNo, Date startTime) throws Exception {

        LocalDateTime localDateTime = startTime.toInstant()
                                            .atZone(ZoneId.systemDefault())
                                            .toLocalDateTime();

        // Initialize startTime to the first day of the month at 00:00:00
        LocalDateTime startOfMonth = localDateTime.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0);

        // Initialize endTime to the last day of the month at 23:59:59
        LocalDateTime endOfMonth = localDateTime.withDayOfMonth(localDateTime.toLocalDate().lengthOfMonth())
                                                .withHour(23).withMinute(59).withSecond(59);

        // Convert LocalDateTime back to Date
        startTime = Date.from(startOfMonth.atZone(ZoneId.systemDefault()).toInstant());
        Date endTime = Date.from(endOfMonth.atZone(ZoneId.systemDefault()).
        toInstant());

        List<Plan> planList = planMapper.selectByUserDate(userNo, startTime, endTime);

        return planList;
    }

    @Override
    public List<Plan> selectByUserMonthDate(int userNo, Date startTime) throws Exception {
       LocalDateTime localDateTime = startTime.toInstant()
                                            .atZone(ZoneId.systemDefault())
                                            .toLocalDateTime();

        // Initialize startTime to the first day of the month at 00:00:00
        LocalDateTime startOfMonth = localDateTime.withDayOfMonth(1).withHour(0).withMinute(0).withSecond(0).withNano(0);

        // Adjust startTime to the Sunday of the first week
        LocalDateTime startOfWeek = startOfMonth.with(DayOfWeek.SUNDAY);
        if (startOfWeek.isAfter(startOfMonth)) {
            // If the first day is after Sunday, move to the previous Sunday
            startOfWeek = startOfWeek.minusWeeks(1);
        }

        // Calculate endTime as 5 weeks later on Saturday
        LocalDateTime endOfWeek = startOfWeek.plusWeeks(5).with(DayOfWeek.SATURDAY)
                                            .withHour(23).withMinute(59).withSecond(59);

        // Convert LocalDateTime back to Date
        startTime = Date.from(startOfWeek.atZone(ZoneId.systemDefault()).toInstant());
        Date endTime = Date.from(endOfWeek.atZone(ZoneId.systemDefault()).toInstant());

        // Retrieve the plans
        List<Plan> planList = planMapper.selectByUserDate(userNo, startTime, endTime);

        return planList;
    }
    
    @Override
    public List<Plan> selectByUserDay(int userNo, Date startTime) throws Exception {
        LocalDateTime localDateTime = startTime.toInstant()
                                            .atZone(ZoneId.systemDefault())
                                            .toLocalDateTime();

        LocalDateTime startLocal = localDateTime.withHour(0).withMinute(0).withSecond(0).withNano(0);

        LocalDateTime endLocal = localDateTime.withHour(23).withMinute(59).withSecond(59);

        // Convert LocalDateTime back to Date
        startTime = Date.from(startLocal.atZone(ZoneId.systemDefault()).toInstant());
        Date endTime = Date.from(endLocal.atZone(ZoneId.systemDefault()).toInstant());

        // Retrieve the plans
        List<Plan> planList = planMapper.selectByUserDate(userNo, startTime, endTime);

        return planList;
    }

    @Override
    public List<Plan> selectByStartEnd(int userNo, Date startTime, Date endTime) throws Exception {
        List<Plan> planList = planMapper.selectByUserDate(userNo, startTime, endTime);
        return planList;
    }

    @Override
    public Plan selectByNo(int no) throws Exception {
        Plan plan = planMapper.selectByNo(no);
        return plan;
    }

    @Override
    public int insert(Plan plan) throws Exception {
        int result = planMapper.insert(plan);
        return result;
    }

    @Override
    public int update(Plan plan) throws Exception {
        int result = planMapper.update(plan);
        return result;
    }

    @Override
    public int delete(int no) throws Exception {
        int result = planMapper.delete(no);
        return result;
    }
    
}
