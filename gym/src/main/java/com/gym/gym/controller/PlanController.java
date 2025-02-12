package com.gym.gym.controller;

import java.text.SimpleDateFormat;
import java.util.ArrayList;
import java.util.Calendar;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Locale;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gym.gym.domain.Comment;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Plan;
import com.gym.gym.domain.Reservation;
import com.gym.gym.domain.UserAuth;
import com.gym.gym.domain.Users;
import com.gym.gym.service.CommentService;
import com.gym.gym.service.PlanService;
import com.gym.gym.service.ReservationService;
import com.gym.gym.service.UserService;
import com.gym.gym.util.DateUtils;

import lombok.extern.slf4j.Slf4j;



@Slf4j
@RestController
@EnableMethodSecurity(securedEnabled = true, prePostEnabled = true)
@RequestMapping("/user/schedule")
public class PlanController {
    
    @Autowired
    PlanService planService;

    @Autowired
    CommentService commentService;

    @Autowired
    ReservationService reservationService;

    @Autowired
    UserService userService;

    @Autowired
    private DateUtils dateUtils;

    
    @GetMapping()
    @PreAuthorize(" hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")
    public ResponseEntity<?> getAll(
            @AuthenticationPrincipal CustomUser userDetails,
            @RequestParam(value = "userNo", required = false) Long userNo
    ) {
        try {
            Date currentDate = new Date();

            Date commentDate = dateUtils.DayFirst(currentDate);
            List<Date> dates = dateUtils.MonthFirstLast(currentDate);

            Date startDate = dates.get(0);
            Date endDate = dates.get(1);

            System.out.println("userDetails: " + userDetails);
            Users user = userDetails.getUser();
            System.out.println("user: " + user);
            System.out.println("userNo: " + user.getNo());
            UserAuth userAuth = userService.selectAuth(user.getNo());
            System.out.println("userAuth: " + userAuth);
            String userAuthAuth = userAuth.getAuth();
            System.out.println("userAuthAuth getPlans: " + userAuthAuth);
            System.out.println("userNo: " + userNo);

            int iNo;

            if (userNo != null && (userAuthAuth.equals("ROLE_ADMIN") || userAuthAuth.equals("ROLE_TRAINER"))) {
                iNo = userNo.intValue();
            } 
            // ADMIN 또는 USER 역할인 경우 userNo 파라미터가 없을 때만 접근
            else if (userNo == null && (userAuthAuth.equals("ROLE_ADMIN") || userAuthAuth.equals("ROLE_USER"))) {
                iNo = userDetails.getNo().intValue();
                log.info("userDetails.getNo().intValue(): " + iNo);
            } 
            // 위의 조건에 맞지 않으면 403 오류 처리
            else {
                log.info("UNAUTHORIZED getPlans");
                return new ResponseEntity<>("UNAUTHORIZED getPlans", HttpStatus.UNAUTHORIZED);
            }

            List<Plan> planList = planService.selectByStartEnd(iNo, startDate, endDate);
            Comment comment = commentService.selectByDate(commentDate, iNo);
            List<Reservation> reservationList = reservationService.selectByStartEnd(iNo, startDate, endDate);

            List<Map<String, Object>> planEvents = new ArrayList<>();
            for (Plan plan : planList) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", plan.getNo());
                event.put("title", plan.getPlanName());
                event.put("start", plan.getPlanTime());
                event.put("end", plan.getPlanEnd());
                event.put("description", plan.getPlanContent());
                event.put("color","#FEBC6E");
                event.put("type", "plan");
                
                planEvents.add(event);
            }

            List<Map<String, Object>> reservationEvents = new ArrayList<>();
            for (Reservation rv : reservationList) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", rv.getNo());
                event.put("title", rv.getTrainerName() + "PT");
                event.put("start", rv.getRvDate());
                event.put("end", dateUtils.CalcOneHourLater(rv.getRvDate()));
                event.put("description", rv.getTrainerName());
                event.put("type", "reservation");
                if (rv.getEnabled() == 2){
                    event.put("color","#64FF98");
                } else {
                    event.put("color","#64CBFF");
                }

                reservationEvents.add(event);
            }

            if(comment == null){
                comment = new Comment();
                comment.setCommentDate(commentDate);
                comment.setUserNo(iNo);
            }

            Map<String, Object> response = new HashMap<>();
            response.put("comment", comment);
            response.put("planEvents", planEvents);
            response.put("reservationEvents", reservationEvents);
            response.put("userAuthAuth", userAuthAuth);

            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @GetMapping("/{year}/{month}/{day}")
    @PreAuthorize(" hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")
    public ResponseEntity<?> listByDate(
        @PathVariable("year") int year, 
        @PathVariable("month") int month, 
        @PathVariable("day") int day,
        @RequestParam(value = "userNo", required = false) Long userNo,
        @AuthenticationPrincipal CustomUser userDetails
    ) {
        try {
            Calendar calendar = Calendar.getInstance();
            calendar.set(year, month - 1, day); // 월은 0부터 시작하므로 -1 필요
            Date date = calendar.getTime();
            System.out.println("선택날짜(date): "+date);

            Date commentDate = dateUtils.DayFirst(date);
            System.out.println("선택날짜 0시0분(commentDate): " + commentDate);

            List<Date> dates = dateUtils.MonthFirstLast(date);
            System.out.println("선택날짜의 달 첫, 마지막 날: "+ dates);

            Date startDate = dates.get(0);
            Date endDate = dates.get(1);

            Users user = userDetails.getUser();
            UserAuth userAuth = userService.selectAuth(user.getNo());
            System.out.println("userAuth: " + userAuth);
            String userAuthAuth = userAuth.getAuth();
            System.out.println("userAuthAuth: " + userAuthAuth);
            System.out.println("userNo: " + userNo);

            int iNo;
            
            if (userNo != null && (userAuthAuth.equals("ROLE_ADMIN") || userAuthAuth.equals("ROLE_TRAINER"))) {
                iNo = userNo.intValue();
            } 
            // ADMIN 또는 USER 역할인 경우 userNo 파라미터가 없을 때만 접근
            else if (userNo == null && (userAuthAuth.equals("ROLE_ADMIN") || userAuthAuth.equals("ROLE_USER"))) {
                iNo = userDetails.getNo().intValue();
            } 
            else {
                return new ResponseEntity<>("UNAUTHORIZED", HttpStatus.UNAUTHORIZED);
            }

            System.out.println("iNo : " + iNo);
            List<Plan> planList = planService.selectByStartEnd(iNo, startDate, endDate);
            Comment comment = commentService.selectByDate(commentDate, iNo);
            List<Reservation> reservationList = reservationService.selectByStartEnd(iNo, startDate, endDate);
            
            System.out.println("planList: " + planList);
            System.out.println("comment: " + comment);
            System.out.println("reservationList: "+ reservationList);

            List<Map<String, Object>> planEvents = new ArrayList<>();
            for (Plan plan : planList) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", plan.getNo());
                event.put("title", plan.getPlanName());
                event.put("start", plan.getPlanTime());
                event.put("end", plan.getPlanEnd());
                event.put("description", plan.getPlanContent());
                event.put("color","#FEBC6E");
                event.put("type", "plan");
                
                planEvents.add(event);
            }

            List<Map<String, Object>> reservationEvents = new ArrayList<>();
            for (Reservation rv : reservationList) {
                Map<String, Object> event = new HashMap<>();
                event.put("id", rv.getNo());
                event.put("title", rv.getTrainerName() + "PT");
                event.put("start", rv.getRvDate());
                event.put("end", dateUtils.CalcOneHourLater(rv.getRvDate()));
                event.put("description", rv.getTrainerName());
                event.put("color","#64CBFF");
                event.put("type", "reservation");

                reservationEvents.add(event);
            }

            Map<String,Object> response = new HashMap<>();

            if(comment == null){
                comment = new Comment();
                comment.setCommentDate(commentDate);
                comment.setUserNo(iNo);
            }

            response.put("comment", comment);
            response.put("planEvents", planEvents);
            response.put("reservationEvents", reservationEvents);
            return new ResponseEntity<>(response, HttpStatus.OK);
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @PostMapping()
    @PreAuthorize(" hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> insert(@RequestBody Plan plan, @AuthenticationPrincipal CustomUser userDetails) {
        try {
            plan.setUserNo(userDetails.getNo().intValue());
            int result = planService.insert(plan);
            if (result > 0) {
                return new ResponseEntity<>("INSERT SUCCESS", HttpStatus.OK);
                
            } else {
                return new ResponseEntity<>("INSERT FAIL", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PostMapping("/comment")
    @PreAuthorize("hasRole('TRAINER')")
    public ResponseEntity<?> insertComment(@RequestBody Comment comment, @AuthenticationPrincipal CustomUser userDetails) {
        System.out.println("insert comment: " + comment);
        try {
            comment.setTrainerNo(userDetails.getNo().intValue());
            int result = commentService.insert(comment);
            if (result > 0) {
                return new ResponseEntity<>("INSERT SUCCESS", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("INSERT FAIL", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @PutMapping()
    @PreAuthorize(" hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> update(@RequestBody Plan plan) {
        try {
            System.out.println(plan);
            int result = planService.update(plan);
            if (result > 0) {
                return new ResponseEntity<>("UPDATE SUCCESS", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("UPDATE FAIL", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    @PutMapping("/comment")
    @PreAuthorize("hasRole('TRAINER')")
    public ResponseEntity<?> updateComment(@RequestBody Comment comment, @AuthenticationPrincipal CustomUser userDetails) {
        try {
            comment.setTrainerNo(userDetails.getNo().intValue());
            int result = commentService.updateByNo(comment);
            if (result > 0) {
                return new ResponseEntity<>("UPDATE SUCCESS", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("UPDATE FAIL", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    
    @DeleteMapping()
    @PreAuthorize(" hasRole('ADMIN') or hasRole('USER')")
    public ResponseEntity<?> delete(@RequestParam("no") String no) {
        try {
            int iNo = Integer.parseInt(no); // String을 int로 변환
            int result = planService.delete(iNo);
            if (result > 0) {
                return new ResponseEntity<>("DELETE SUCCESS", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("DELETE FAIL", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}