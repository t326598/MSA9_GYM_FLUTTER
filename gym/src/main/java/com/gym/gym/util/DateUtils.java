package com.gym.gym.util;

import java.time.LocalDate;
import java.time.ZoneId;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Component;

@Component
public class DateUtils {
    
    // 날짜를 0시 0분 0초로 초기화
    public Date DayFirst(Date currentDate){
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(currentDate); // 현재 날짜 설정
        
        // 시간을 0시 0분으로 설정
        calendar.set(Calendar.HOUR_OF_DAY, 0); // 0시
        calendar.set(Calendar.MINUTE, 0);       // 0분
        calendar.set(Calendar.SECOND, 0);       // 0초
        calendar.set(Calendar.MILLISECOND, 0);  // 0밀리초
        
        // 0시 0분으로 설정된 Date 객체 가져오기
        Date resetDate = calendar.getTime();

        return resetDate;
    }

    // 인자 날짜의 한 시간 후의 Date 객체를 반환
    public Date CalcOneHourLater(Date date) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);

        calendar.add(Calendar.HOUR, 1);

        Date oneHourLater = calendar.getTime();

        return oneHourLater;
    }

    // 이번 달의 첫째 날과 마지막 날을 구하는 메소드
    public List<Date> MonthFirstLast(Date date) {
        LocalDate localDate = date.toInstant().atZone(ZoneId.systemDefault()).toLocalDate();
    
        int year = localDate.getYear();
        int month = localDate.getMonthValue();
    
        // YearMonth yearMonth = YearMonth.of(year, month);
        LocalDate firstDayOfMonth = LocalDate.of(year, month, 1);
        // LocalDate lastDayOfMonth = yearMonth.atEndOfMonth();
    
        // 이번 달의 첫째 날의 요일 (일요일 = 0, 월요일 = 1, ...)
        int firstDayOfWeek = firstDayOfMonth.getDayOfWeek().getValue() % 7;
    
        // 캘린더 시작 날짜: 이번 달 첫째 주의 일요일
        LocalDate calendarStartDate = firstDayOfMonth.minusDays(firstDayOfWeek);
    
        // 캘린더 종료 날짜: 마지막 주의 토요일
        LocalDate calendarEndDate = calendarStartDate.plusDays(41);
    
        Date startDate = Date.from(calendarStartDate.atStartOfDay().atZone(ZoneId.systemDefault()).toInstant()); // 00:00:00
        Date endDate = Date.from(calendarEndDate.atTime(23, 59, 59).atZone(ZoneId.systemDefault()).toInstant()); 
    
        List<Date> dates = new ArrayList<>();
        dates.add(startDate);
        dates.add(endDate);
    
        return dates;
    }
}
