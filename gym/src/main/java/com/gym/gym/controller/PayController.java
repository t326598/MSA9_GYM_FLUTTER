package com.gym.gym.controller;

import java.util.Calendar;
import java.util.Comparator;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import org.apache.ibatis.annotations.Param;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gym.gym.domain.BuyList;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Ticket;
import com.gym.gym.domain.TrainerProfile;
import com.gym.gym.domain.Users;
import com.gym.gym.service.BuyListService;
import com.gym.gym.service.TicketService;
import com.gym.gym.service.TrainerProfileService;
import com.gym.gym.service.UserService;

import lombok.extern.slf4j.Slf4j;

@RestController
@Slf4j
@RequestMapping("/user")
public class PayController {

    @Autowired
    private BuyListService buyListService;
    @Autowired
    private TrainerProfileService trainerProfileService;
    @Autowired
    private TicketService ticketService;
    @Autowired
    private UserService userService;

    // 이용권 선택 (REST API)
    @GetMapping("/ticketDate")
    public ResponseEntity<Map<String, Object>> ticketDate(@AuthenticationPrincipal CustomUser userDetails) throws Exception {

        Long no = userDetails != null ? userDetails.getNo() : 0L;
        List<BuyList> buyList = buyListService.ticketByUser(no);

        // 최근 구매내역 전달
        BuyList lastBuy = buyListService.lastBuyList(no);
        Date startDate = new Date();
        if (lastBuy != null && !"만료".equals(lastBuy.getStatus())) {
            startDate = lastBuy.getEndDate(); // 마지막 구매 날짜
            startDate = addDays(startDate, 1); // 1일 추가
        }
        
        // 정상이면서 제일 오래된 이용권
        List<BuyList> filteredList = buyList.stream()
        .sorted(Comparator.comparing(BuyList::getStartDate))
        .collect(Collectors.toList());
        BuyList oldTicket = filteredList.isEmpty() ? null : filteredList.get(0);
        
        Map<String, Object> response = new HashMap<>();
        response.put("buyList", buyList);
        response.put("startDate", startDate);
        response.put("oldTicket", oldTicket);
        
        return ResponseEntity.ok(response);
    }
    // 이용권 선택 (REST API)
    @GetMapping("/ticketDateTEST")
    public ResponseEntity<Map<String, Object>> ticketDateTES(@RequestParam("userNo") Long no) throws Exception {

        List<BuyList> buyList = buyListService.ticketByUser(no);

        // 최근 구매내역 전달
        BuyList lastBuy = buyListService.lastBuyList(no);
        Date startDate = new Date();
        if (lastBuy != null && !"만료".equals(lastBuy.getStatus())) {
            startDate = lastBuy.getEndDate(); // 마지막 구매 날짜
            startDate = addDays(startDate, 1); // 1일 추가
        }
        
        // 정상이면서 제일 오래된 이용권
        List<BuyList> filteredList = buyList.stream()
        .sorted(Comparator.comparing(BuyList::getStartDate))
        .collect(Collectors.toList());
        BuyList oldTicket = filteredList.isEmpty() ? null : filteredList.get(0);
        
        Map<String, Object> response = new HashMap<>();
        response.put("buyList", buyList);
        response.put("startDate", startDate);
        response.put("oldTicket", oldTicket);
        
        return ResponseEntity.ok(response);
    }

    // 트레이너 목록 (REST API)
    @GetMapping("/ticket/trainerList")
    public ResponseEntity<List<TrainerProfile>> trainerList() throws Exception {
        List<TrainerProfile> trainerList = trainerProfileService.list();
        return ResponseEntity.ok(trainerList);
    }

    // 일반 이용권 목록 (REST API)
    @GetMapping("/ticket/normal")
    public ResponseEntity<Map<String, Object>> normal(@AuthenticationPrincipal CustomUser userDetails) throws Exception {
        List<Ticket> ticketList = ticketService.normalList();
        
        Map<String, Object> response = new HashMap<>();
        response.put("ticketList", ticketList);
        
        if (userDetails != null) {
            Users user = userService.select(userDetails.getNo());
            response.put("user", user);
            
            // 최근 구매내역 전달
            BuyList lastBuy = buyListService.lastBuyList(userDetails.getNo());
            Date startDate = lastBuy != null && !"만료".equals(lastBuy.getStatus()) ? addDays(lastBuy.getEndDate(), 1) : new Date();
            
            response.put("startDate", startDate);
        }

        Long no = userDetails != null ? userDetails.getNo() : 0L;
        List<BuyList> buyList = buyListService.ticketByUser(no);
        List<BuyList> filteredList = buyList.stream()
            .sorted(Comparator.comparing(BuyList::getStartDate))
            .collect(Collectors.toList());
        BuyList startedTicket = filteredList.isEmpty() ? null : filteredList.get(0);
        
        response.put("buyList", buyList);
        response.put("startedTicket", startedTicket);

        return ResponseEntity.ok(response);
    }

    // 결제 (REST API)
    @PreAuthorize("hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")
    @PostMapping("/pay/paying")
    public ResponseEntity<Map<String, Object>> paying(@AuthenticationPrincipal CustomUser userDetails, @RequestBody BuyList buyList) throws Exception {
        buyList.setUserNo(userDetails.getNo());
        buyListService.insert(buyList);
        log.info("buyList : " + buyList);

        Map<String, Object> response = new HashMap<>();
        response.put("success", true);

        if (userDetails != null) {
            userDetails.getUser().setTrainerNo(buyList.getTrainerNo());
            log.info("트레이너 넘버 확인 : " + userDetails.getUser().getTrainerNo());
        }

        return ResponseEntity.ok(response);
    }

    // 결제 결과 페이지 (REST API)
    @GetMapping("/pay/payResult")
    public ResponseEntity<Map<String, Object>> payResult(@AuthenticationPrincipal CustomUser userDetails) throws Exception {

        Long no = userDetails != null ? userDetails.getNo() : 0L;
        List<BuyList> buyList = buyListService.ticketByUser(no);
        
        List<BuyList> filteredList = buyList.stream()
            .sorted(Comparator.comparing(BuyList::getStartDate))
            .collect(Collectors.toList());
        BuyList startedTicket = filteredList.isEmpty() ? null : filteredList.get(0);
        
        Map<String, Object> response = new HashMap<>();
        response.put("buyList", filteredList);
        response.put("startedTicket", startedTicket);

        return ResponseEntity.ok(response);
    }

    // 날짜에 일수를 더하는 메서드
    private Date addDays(Date date, int days) {
        Calendar calendar = Calendar.getInstance();
        calendar.setTime(date);
        calendar.add(Calendar.DAY_OF_MONTH, days); // 날짜에 일수를 더함
        return calendar.getTime(); // 수정된 날짜 반환
    }
}
