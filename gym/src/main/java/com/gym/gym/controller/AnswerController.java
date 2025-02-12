package com.gym.gym.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;

import com.gym.gym.domain.Answer;
import com.gym.gym.domain.Board;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Users;
import com.gym.gym.service.AnswerService;
import com.gym.gym.service.BoardService;

import lombok.extern.slf4j.Slf4j;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.PutMapping;





@RestController
@Slf4j
@RequestMapping("/answer")

public class AnswerController {
    
    @Autowired
    private AnswerService answerService;
    @Autowired
    private BoardService boardService;



    
    @ResponseBody
    @PostMapping()
    public ResponseEntity<?> answerInsert( @AuthenticationPrincipal CustomUser authuser,@RequestBody Answer answer) throws Exception {
        Users user = authuser.getUser();
        answer.setUserNo(user.getNo());
        int result = answerService.insert(answer);
            if (result > 0) {

                    return new ResponseEntity<>("SUCCESS",HttpStatus.OK);
                }
            
            return new ResponseEntity<>("FAIL",HttpStatus.BAD_REQUEST);
    }
   
    

    @GetMapping
    public String answerList(Model model, @RequestParam("boardNo") Long boardNo) throws Exception {
        log.info(boardNo + " 번호");
        List<Answer> answerList = answerService.listByParent(boardNo);
        model.addAttribute("answerList", answerList);
        Board board = boardService.select(boardNo);
        model.addAttribute("board", board);
        return "user/answer/list";
    }
    

    @DeleteMapping("/{no}")
    public ResponseEntity<?> deleteAnswer(@PathVariable("no") Long no) throws Exception{
      
        int result = answerService.deleteByParent(no);

        if (result > 0) {

            return new ResponseEntity<>("SUCCESS",HttpStatus.OK);
        }
    
            return new ResponseEntity<>("FAIL",HttpStatus.BAD_REQUEST);
    }


    @GetMapping("/{no}")
    public String editAnswer(Answer answer) throws Exception {
        int result = answerService.update(answer);
        if(result > 0){
            return "SUCCESS";
        }
        return "FAIL";
    }

    @PutMapping
    public ResponseEntity<?> updateAnswer(@RequestBody Answer answer) throws Exception {
        int result = answerService.update(answer);
        if (result > 0) {

            return new ResponseEntity<>("SUCCESS",HttpStatus.OK);
        }
    
            return new ResponseEntity<>("FAIL",HttpStatus.BAD_REQUEST);
    }



}
