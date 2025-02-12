package com.gym.gym.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gym.gym.domain.Attendance;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.QRcode;
import com.gym.gym.service.AttendanceService;

import io.swagger.v3.oas.annotations.parameters.RequestBody;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/")
@CrossOrigin("*")
public class AttendanceController {

    @Autowired
    private AttendanceService attendanceService;

    /**
     * 출석 내역 조회 (페이징 기능 포함)
     * 
     * @param option
     * @param page
     * @return
     */
    @GetMapping("admin/attendance/list")
    public ResponseEntity<?> list(Option option, Page page) throws Exception {
        log.info("아무거나 ");
        List<Attendance> attendanceList = attendanceService.list(option, page);
        int result = attendanceService.listCount();

        // 페이지 URL 생성
        String pageUrl = String.format("/api/admin/attendance/list?keyword=%s&code=%s&rows=%d&orderCode=%s",
                option.getKeyword(), option.getCode(), page.getRows(), option.getOrderCode());

        // 응답 객체에 데이터를 담아서 반환
        return ResponseEntity.ok(new AttendanceListResponse(attendanceList, option, page, result, pageUrl));
    }

    // 실시간 이용자 수
    @GetMapping("/admin/attendance/userCount")
    public ResponseEntity<?> getUserCount() throws Exception {
        // 사용자 수 가져오기
        int userCount = attendanceService.listCount();

        // 응답을 JSON 형태로 반환
        Map<String, Object> response = new HashMap<>();
        response.put("userCount", userCount);

        return ResponseEntity.ok(response); // JSON 응답 반환
    }

    // 출석 체크 페이지를 이동
    @GetMapping("user/attendance/check/{qrNo}/{uuid}")
    public ResponseEntity<?> showAttendancePage(@PathVariable("uuid") String uuid, @PathVariable("qrNo") Long no ) throws Exception {

   
        log.info("sdfsdf"+ uuid);
        log.info("fdsgfdg"+ no);

        if (no == 0) {
       
            return ResponseEntity.badRequest().body(new AttendanceResponse("사용자 번호가 제공되지 않았습니다."));
        }
        
        // QR 코드가 제공되지 않았을 때 처리
        if (uuid == null || uuid.isEmpty()) {

            return ResponseEntity.badRequest().body(new AttendanceResponse("QR 코드가 제공되지 않았습니다."));
        }
        Attendance attendance = new Attendance();
        attendance.setQrId(uuid);
        attendance.setUserNo(no);
        attendanceService.insertAttendance(attendance);

        QRcode qRcode = attendanceService.selectQRcode(null);

        if (qRcode != null && qRcode.getUuid().equals(uuid)) {
            return ResponseEntity.ok(new AttendanceResponse("출석 체크가 완료되었습니다."));
        }

         return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
    }
    
    // 출석 체크 (등록)
    // @PostMapping("user/attendance/check")
    // public ResponseEntity<?> insertAttendance(@RequestBody QRcode qrcode)
    // throws Exception {
    

    //     // 새로운 UUID 생성
    //     log.info("zzzz" + qrcode);


    //     // user_no가 null일 경우 처리
    //     if (userNo == null) {
    //         return ResponseEntity.badRequest().body(new AttendanceResponse("사용자 번호가 제공되지 않았습니다."));
    //     }

    //     QR 코드가 제공되지 않았을 때 처리
    //     if (qrId == null || qrId.isEmpty()) {
    //         return ResponseEntity.badRequest().body(new AttendanceResponse("QR 코드가 제공되지 않았습니다."));
    //     }

    //     Attendance attendance = new Attendance();
    //     attendance.setQrId(qrId);
    //     attendance.setUserNo(userNo);
    //     attendanceService.insertAttendance(attendance);

    //     QRcode qRcode = attendanceService.selectQRcode(null);

    //     if (qRcode != null && qRcode.getUuid().equals(qrId)) {
    //         return ResponseEntity.ok(new AttendanceResponse("출석 체크가 완료되었습니다."));
    //     }

    //     return ResponseEntity.badRequest().body(new AttendanceResponse("유효하지 않은 QR 코드입니다."));
    // }


    // 출석 내역 조회 응답 클래스
    public static class AttendanceListResponse {
        private List<Attendance> attendanceList;
        private Option option;
        private Page page;
        private int result;
        private String pageUrl;

        public AttendanceListResponse(List<Attendance> attendanceList, Option option, Page page, int result,
                String pageUrl) {
            this.attendanceList = attendanceList;
            this.option = option;
            this.page = page;
            this.result = result;
            this.pageUrl = pageUrl;
        }

        public List<Attendance> getAttendanceList() {
            return attendanceList;
        }

        public Option getOption() {
            return option;
        }

        public Page getPage() {
            return page;
        }

        public int getResult() {
            return result;
        }

        public String getPageUrl() {
            return pageUrl;
        }
    }

    // 출석 체크 페이지 응답 클래스
    public static class AttendanceCheckPageResponse {
        private String uuid;

        public AttendanceCheckPageResponse(String uuid) {
            this.uuid = uuid;
        }

        public String getUuid() {
            return uuid;
        }
    }

    // 출석 체크 응답 클래스
    public static class AttendanceResponse {
        private String message;

        public AttendanceResponse(String message) {
            this.message = message;
        }

        public String getMessage() {
            return message;
        }
    }
}