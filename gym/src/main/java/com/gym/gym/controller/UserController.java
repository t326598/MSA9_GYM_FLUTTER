package com.gym.gym.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.access.prepost.PreAuthorize;
import org.springframework.security.config.annotation.method.configuration.EnableMethodSecurity;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.security.web.authentication.logout.SecurityContextLogoutHandler;
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
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import org.springframework.web.util.UriComponentsBuilder;

import com.gym.gym.domain.Board;
import com.gym.gym.domain.ChangePwRequest;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.UserAuth;
import com.gym.gym.domain.Users;
import com.gym.gym.service.BoardService;
import com.gym.gym.service.UserService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@CrossOrigin("*")
@EnableMethodSecurity(securedEnabled = true, prePostEnabled = true)
@RequestMapping()
public class UserController {

    @Autowired
    private UserService userService;

    @Autowired
    private BoardService boardService;

    // 사용자 정보
        @GetMapping("/user/info")
    public ResponseEntity<?> userInfo(@AuthenticationPrincipal CustomUser customUser) {
        log.info(":::::::사용자 정보::::::::::"+ customUser);

    
        if(customUser == null){
            return new ResponseEntity<>("UNAUTHORIZED", HttpStatus.UNAUTHORIZED);
        }
        
        log.info("customUser" + customUser);
        
        Users user = customUser.getUser();
        log.info("user : " + user);
        
        if(user != null){
            return new ResponseEntity<>(user, HttpStatus.OK);
        }
    
        // 인증 되지 않은 경우


        return new ResponseEntity<>("UNAUTHORIZED", HttpStatus.UNAUTHORIZED);
    }
 

    @PostMapping("/user")
    public ResponseEntity<?> join(@RequestBody Users user) throws Exception {
            log.info("회원 가입 요청");
            int result = userService.join(user);
            if(result > 0 ){
                log.info("회원가입 성공");
                return new ResponseEntity<>("SUCCESS", HttpStatus.OK);

            }
            else{
                log.info("회원가입 실패!");
                return new ResponseEntity<>("FAIL", HttpStatus.BAD_REQUEST);
            }
        
    }


    // 회원 정보 수정 처리
    // @PreAuthorize("hasRole('ROLE_ADMIN') or #p0.id == authentication.name") // 관리자 + 작성자 본인 
    @PutMapping("/user")
    public ResponseEntity<?> update(@RequestBody Users user) throws Exception {
        log.info("회원 정보 수정" + user + "뭐임?");
        boolean result = userService.update(user);
        
        if(result ){
            log.info("회원 수정 성공");
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        }
        else{
            log.info("회원 수정 실패");
            return new ResponseEntity<>("FAIL", HttpStatus.BAD_REQUEST);
        }
        
    }
    

    //  @PreAuthorize("hasRole('ROLE_ADMIN') or #p0 == authentication.no") // 관리자 + 작성자 본인 
    @DeleteMapping("/user/{no}")
    public ResponseEntity<?> delete(@PathVariable("no") Long no) throws Exception{
     log.info("여기옴?" + no);
        int result = userService.deleteAuth(no);

        if(result > 0){
            log.info("여기안옴?");
            result = userService.delete(no);
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        }
        else{
            log.info("회원 삭제 실패");
            return new ResponseEntity<>("FAIL", HttpStatus.BAD_REQUEST);
        }
    }



    // 유저리스트
    // @PreAuthorize(" hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")
    @GetMapping("/user/list")
    public ResponseEntity<?> userlist( @ModelAttribute Option option,  @RequestParam(name = "pageNumber", defaultValue = "1") int pageNumber, @ModelAttribute Page page) throws Exception {
        page.setPage(pageNumber);
        
        List<Users> userList = userService.list(option,page);

            String pageUrl = UriComponentsBuilder.fromPath("user/board/boardList")
                .queryParam("keyword", option.getKeyword())
                .queryParam("code", option.getCode())
                .queryParam("rows", page.getRows())
                .queryParam("orderCode", option.getOrderCode())
                .queryParam("page", page)
                .build()
                .toUriString();
        Map<String, Object> response = new HashMap<String, Object>();
        response.put("pagination", pageUrl);
        response.put("page", page);
        response.put("list",userList);

        return new ResponseEntity<>(response, HttpStatus.OK);

    }

    // 관리자 : 회원 정보 수정 이동
    // @PreAuthorize(" hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")

    @GetMapping("/admin/update/{no}")
    public ResponseEntity<?> getMethodName(@PathVariable("no") Long no) throws Exception {

        Users user = userService.select(no);

        Map<String, Object> response = new HashMap<String, Object>();
        response.put("user", user);

        return new ResponseEntity<>(response, HttpStatus.OK);
    }
    


    // 관리자 : 회원 정보 수정 처리
    // @PreAuthorize(" hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")
    @PutMapping("/admin/update")
    public ResponseEntity<?> adminupdate(@RequestBody Users user)
            throws Exception {
        boolean result = userService.update(user);
        String auth = user.getUserAuth();
        UserAuth userAuth = userService.selectAuth(user.getNo());
        userAuth.setAuth(auth);
        userService.updateAuth(userAuth);

        if (result) {
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        }
        return new ResponseEntity<>( "FAIL",HttpStatus.BAD_REQUEST);
    }

    // 관리자 : 회원 탈퇴
    // @PreAuthorize(" hasRole('ADMIN') or hasRole('USER') or hasRole('TRAINER')")
    @PostMapping("/admin/user/delete")
    public String postMethodName(@RequestParam("no") Long no, HttpServletRequest request, HttpServletResponse response, RedirectAttributes redirectAttributes)
            throws Exception {
        int result = userService.deleteAuth(no);
        result = userService.delete(no);

        if (result > 0) {
            redirectAttributes.addFlashAttribute("message", "회원 탈퇴 했습니다..");
            return "redirect:list";
        }
        redirectAttributes.addFlashAttribute("message", "회원 탈퇴 실패..");
        // 실패한 경우
        return "redirect:/admin/user/update";
    }

    @PostMapping("/findId")
    public ResponseEntity<?> findId(@RequestBody Users user) throws Exception {

        
        String name = user.getName();
        String phone = user.getPhone();
        String question = user.getQuestion();
        String answer = user.getAnswer();
        // 이름, 전화번호, 질문, 답변을 기준으로 사용자 찾기
        Users foundUser = userService.findUserByDetails(name, phone, question, answer);

        if (foundUser != null && foundUser.getId() != null) {
            return new ResponseEntity<>(foundUser.getId(), HttpStatus.OK);
        } else {
       log.info("사용자를 찾을 수 없습니다.");
            return new ResponseEntity<>("FAIL", HttpStatus.CREATED);
        }
    }

    // 비밀번호 찾기페이지 처리
    @PostMapping("/findPw")
    public ResponseEntity<?> findPassword(@RequestBody Users user) throws Exception {
 // 메롱이다
        String id = user.getId();
        String name = user.getName();
        String phone = user.getPhone();
        String question = user.getQuestion();
        String answer = user.getAnswer();

        // 이름, 전화번호, 질문, 답변을 기준으로 사용자 찾기
        Users foundUser = userService.findUserByPassword(name, phone, question, answer, id);

        if (foundUser != null && foundUser.getId() != null) {
            String code = UUID.randomUUID().toString().substring(0, 6);
            foundUser.setCode(code);
            userService.codeInsert(foundUser);

            // 생성한 uuid정보 전달해야함

             return new ResponseEntity<>(code, HttpStatus.OK);
        } else {
            log.info("사용자를 찾을 수 없습니다.");
            return new ResponseEntity<>("FAIL", HttpStatus.BAD_REQUEST);
        }

    }

    // 비밀번호 변경 페이지 처리
    @PostMapping("/newPw")
    public ResponseEntity<?> changePassword(@RequestBody Users user ) throws Exception {
        String password = user.getPassword();
              user = userService.selectCode(user.getCode());
        BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();

        String encodedNewPassword = encoder.encode(password);

        user.setPassword(encodedNewPassword);
        int result = userService.passwordUpdate(user);

        if (result > 0) {
            user.setCode(null);
            userService.codeInsert(user);
            return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
        }
        user.setCode(null);
        userService.codeInsert(user);
        log.info("사용자를 찾을 수 없습니다.");
        return new ResponseEntity<>("FAIL", HttpStatus.BAD_REQUEST);
    }



   // 회원정보 수정 비밀번호 변경 처리
   @PostMapping("/changePw")
   public ResponseEntity<?> changePw(@RequestBody ChangePwRequest request,
                          @AuthenticationPrincipal CustomUser authuser,
                          RedirectAttributes redirectAttributes, Model model) throws Exception {
       String code = UUID.randomUUID().toString().substring(0, 6);
   
       Users user = userService.select(authuser.getNo());
       user.setCode(code);
       userService.codeInsert(user);
       BCryptPasswordEncoder encoder = new BCryptPasswordEncoder();
   
       if (encoder.matches(request.getPassword(), user.getPassword())) {
           String encodedNewPassword = encoder.encode(request.getNewPassword());
           user.setPassword(encodedNewPassword);
           
           int result = userService.passwordUpdate(user);
           if (result > 0) {
               user.setCode(null);
               userService.codeInsert(user);
               redirectAttributes.addFlashAttribute("message", "비밀번호 변경이 완료됐습니다.");
               return new ResponseEntity<>("SUCCESS", HttpStatus.OK);
           }
       }
   
       user.setCode(null);
       userService.codeInsert(user);
       redirectAttributes.addFlashAttribute("message", "비밀번호 변경 실패!");
       return new ResponseEntity<>(null, HttpStatus.BAD_REQUEST);
   }
   

   @GetMapping("/user/myBoardList/{no}")
   public ResponseEntity<?> boardList(
    @PathVariable("no") Long no,
     Option option, Page page) {
        log.info(no + "이거 나와 안나와");
         List<Board> boardList;
        try {
            boardList = boardService.myBoardlist(option, page, no);
      
         
         String pageUrl = String.format("/api/myPage/boardList?keyword=%s&code=%s&rows=%d&orderCode=%s",
         option.getKeyword(), option.getCode(), page.getRows(), option.getOrderCode());
         
         Map<String, Object> response = new HashMap<String, Object>();
         response.put("boardList", boardList);
         response.put("pageUrl", pageUrl);
         response.put("option",option);
         response.put("page",page);

         log.info("보드나옴??" + response);
       
         return new ResponseEntity<> (response, HttpStatus.OK);
         
        } catch (Exception e) {
            log.error("Error while fetching board list: " + e.getMessage());
            return new ResponseEntity<>("서버 오류가 발생했습니다.", HttpStatus.INTERNAL_SERVER_ERROR);
        }
        

}
}




