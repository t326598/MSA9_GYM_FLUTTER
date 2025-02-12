package com.gym.gym.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gym.gym.domain.Ticket;
import com.gym.gym.service.TicketService;

import lombok.extern.slf4j.Slf4j;

@CrossOrigin("*")
@RestController
@RequestMapping("/admin/ticket")
@Slf4j
public class TicketController {

    @Autowired
    private TicketService ticketService;

    // 티켓 목록 조회
    @GetMapping("/list")
    public ResponseEntity<List<Ticket>> list(@RequestParam(name = "keyword", defaultValue = "") String keyword) {
        log.info("keyword : " + keyword);
        try {
            List<Ticket> ticketList = ticketService.allList(keyword);
            return new ResponseEntity<>(ticketList, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error retrieving ticket list", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 티켓 단일 조회
    @GetMapping("/select")
    public ResponseEntity<Ticket> select(@RequestParam("ticketNo") int ticketNo) {
        try {
            Ticket ticket = ticketService.select(ticketNo);
            return new ResponseEntity<>(ticket, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error retrieving ticket", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 티켓 추가
    @PostMapping("/insert")
    public ResponseEntity<String> insert(Ticket ticket) {
        try {
            String ptCount = ticket.getPtCount() + ""; // int를 String으로 변환
            if (ptCount.startsWith("custom,")) {
                // "custom,"이 포함된 경우, "custom,"을 제거하고 나머지 부분을 int로 변환
                String countStr = ptCount.split(",")[1]; // "custom," 이후의 값 (2)
                int count = Integer.parseInt(countStr); // 2를 int로 변환
                ticket.setPtCount(count); // ticket 객체에 새 값 설정
            }
            int result = ticketService.insert(ticket);
            if (result == 0) {
                return new ResponseEntity<>("Error inserting ticket", HttpStatus.BAD_REQUEST);
            }
            return new ResponseEntity<>("Ticket inserted successfully", HttpStatus.CREATED);
        } catch (Exception e) {
            log.error("Error inserting ticket", e);
            return new ResponseEntity<>("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 티켓 수정
    @PutMapping("/update")
    public ResponseEntity<String> update(Ticket ticket) {
        try {
            int result = ticketService.update(ticket);
            if (result == 0) {
                return new ResponseEntity<>("Error updating ticket", HttpStatus.BAD_REQUEST);
            }
            return new ResponseEntity<>("Ticket updated successfully", HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error updating ticket", e);
            return new ResponseEntity<>("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    // 티켓 삭제
    @DeleteMapping("/delete")
    public ResponseEntity<String> delete(@RequestParam("ticketNos") List<Integer> ticketNos) {
        try {
            int result = 0;
            for (int ticketNo : ticketNos) {
                result = ticketService.delete(ticketNo);
            }
            if (result == 0) {
                return new ResponseEntity<>("Error deleting tickets", HttpStatus.BAD_REQUEST);
            }
            return new ResponseEntity<>("Tickets deleted successfully", HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error deleting ticket", e);
            return new ResponseEntity<>("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

}
