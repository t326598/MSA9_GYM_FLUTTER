package com.gym.gym.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.util.UriComponentsBuilder;

import com.gym.gym.controller.AttendanceController.AttendanceListResponse;
import com.gym.gym.domain.Answer;
import com.gym.gym.domain.Attendance;
import com.gym.gym.domain.Board;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.Users;
import com.gym.gym.service.AnswerService;
import com.gym.gym.service.BoardService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@CrossOrigin("*")
@RequestMapping("/board")
public class BoardController {

    @Autowired
   private BoardService boardService;

    @Autowired
   private AnswerService answerService;

    // 목록

      @GetMapping()
    public ResponseEntity<?> list( Option option, Page page) throws Exception {

    
        List<Board> boardList = boardService.boardlist(option, page);

        // 페이지 URL 생성
        String pageUrl = String.format("/api/boardList?keyword=%s&code=%s&rows=%d&orderCode=%s",
                option.getKeyword(), option.getCode(), page.getRows(), option.getOrderCode());

                Map<String, Object> response = new HashMap<String, Object>();
                response.put("boardList", boardList);
                response.put("pageUrl", pageUrl);
                response.put("option",option);
                response.put("page",page);

                
        // 응답 객체에 데이터를 담아서 반환
        return new ResponseEntity<> (response, HttpStatus.OK);
    }
    

    @GetMapping("/{no}")
    public ResponseEntity<?> select(@PathVariable("no") Long no)
            throws Exception {
        // 게시글 조회
        log.info(no+"no");
        Board board = boardService.select(no);
        List<Answer> answerList = answerService.listByParent(no);
        Map<String, Object> response = new HashMap<String, Object>();
        response.put("board", board);
        response.put("answer", answerList);      
        return new ResponseEntity<>(response,HttpStatus.OK);
    }

    // 등록처리
    // @PreAuthorize(" hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")
    @PostMapping()
    public ResponseEntity<?> insertPost(@RequestBody Board board, @AuthenticationPrincipal CustomUser authuser ) throws Exception {

        board.setUserNo(authuser.getUser().getNo());
        int result = boardService.insert(board);

        if (result > 0) {
            log.info("등록 성공");
            return new ResponseEntity<>("SUCCESS",HttpStatus.OK);
        }
        return new ResponseEntity<>("FAIL",HttpStatus.BAD_REQUEST);
    }


    @GetMapping("/answerUpdate")
    public String answerUpdate(@RequestParam("no") Long no, Model model) throws Exception {
        Answer answer = answerService.select(no);
        model.addAttribute("answer", answer);
        return "user/board/answerUpdate";
    }
    

    // 수정 처리
    // @PreAuthorize("hasRole('ADMIN') or (#p0 != null and
    // @BoardService.isOwner(#p0, authentication.principal.user.no))")
    @PutMapping()
    public ResponseEntity<?> updatePost(@RequestBody Board board) throws Exception {
        
        int result = boardService.update(board);

        if (result > 0) {

            return new ResponseEntity<>("SUCCESS",HttpStatus.OK);
        }
        return new ResponseEntity<>("FAIL",HttpStatus.BAD_REQUEST);
    }

    // 삭제 처리
    // @PreAuthorize("hasRole('ADMIN') or (#p0 != null and
    // @BoardService.isOwner(#p0, .principal.user.no))")
    @DeleteMapping("/{no}")
    public ResponseEntity<?> delete(@PathVariable("no") Long no) throws Exception {
        log.info(no+"sdfdgs");

        
            answerService.deleteByParent(no);
        int result = boardService.delete(no);
            
                if (result > 0) {

                    return new ResponseEntity<>("SUCCESS",HttpStatus.OK);
                }
            
            return new ResponseEntity<>("FAIL",HttpStatus.BAD_REQUEST);
    }
   

   @PutMapping("/answerUpdate")
    public String updateAnswer( Answer answer) throws Exception {
        int result = answerService.update(answer);
        if(result > 0){
            return  "redirect:user/board/read";

        }
        return "redirect:user/board/read";

    }


}