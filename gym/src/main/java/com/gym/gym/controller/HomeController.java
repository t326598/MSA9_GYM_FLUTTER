package com.gym.gym.controller;

import java.util.ArrayList;
import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.core.annotation.AuthenticationPrincipal;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.CrossOrigin;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.gym.gym.domain.AuthenticationRequest;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Users;
import com.gym.gym.security.constants.SecurityConstants;
import com.gym.gym.security.props.JwtProps;
import com.gym.gym.service.AttendanceService;
import com.gym.gym.service.UserService;

import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.security.Keys;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import lombok.extern.slf4j.Slf4j;

@CrossOrigin("*")
@Slf4j
@RestController
@RequestMapping("")
public class HomeController {

    @Autowired
    private UserService userService;

    @Autowired
    private AttendanceService attendanceService;

    @Autowired
    private JwtProps jwtProps;


    /**
     * 메인 화면
     * 🔗 [GET] - /
     * 📄 index.html
     */
    @GetMapping("/")
    public String home(
            @AuthenticationPrincipal CustomUser authuser,
            Model model) throws Exception {
                
        // 출석 인원 조회 추가
        int result = attendanceService.listCount();
        model.addAttribute("result", result);

        if(authuser != null){
        
            log.info(":::::::::: 메인 화면 ::::::::::");
                Users user = authuser.getUser();
                model.addAttribute("user", user);

        }


            return "index";
    }

    /**
     * 로그인 화면
     * 🔗 [GET] - /login
     * 📄 login.html
     */
    // @GetMapping("/login")
    // public String login(
    //         @CookieValue(value = "remember-id", required = false) Cookie cookie,
    //         Model model,
    //         HttpServletRequest request,@AuthenticationPrincipal CustomUser user ) {

    //            if(user == null){
    //     String username = "";
    //     boolean rememberId = false;
    //     if (cookie != null) {
    //         username = cookie.getValue();
    //         rememberId = true;
    //     }
    //     model.addAttribute("username", username);
    //     model.addAttribute("rememberId", rememberId);
    //     return "login";
    // }
    // return "redirect:/";
    // }

    
    @PostMapping("/login")
    public ResponseEntity<?> login(@RequestBody AuthenticationRequest authReq) {
        log.info("넘어옴?");
        // 아이디 비밀번호
        String username = authReq.getId();
        String password = authReq.getPassword();

        log.info("username : " + username);
        log.info("password : " + password);

        // 사용자 권한 정보 세팅
        List<String> roles = new ArrayList<String>();
        roles.add("ROLE_USER");
        roles.add("ROLE_ADMIN");
        roles.add("ROLE_TRAINER");

        // 서명에 사용할 키 생성
        String secretKey = jwtProps.getSecretKey();
        byte[] signingKey = secretKey.getBytes();

        log.info("시크릿키"+ signingKey);

        // JWT 토큰 생성
        // 만료시간 : ms 단위
        //  - 5일 : 1000 * 60 * 60 * 24 * 5
        int day5 = 1000 * 60 * 60 * 24 * 5;

        String jwt = Jwts.builder()
                        .signWith(Keys.hmacShaKeyFor(signingKey), Jwts.SIG.HS512 )  // 알고리즘 설정
                        .header()                                                   // 헤더 설정
                            .add("typ", SecurityConstants.TOKEN_TYPE)           // typ : "jwt"
                        .and()                                                      // 페이로드 설정
                        .claim("uid", username)                                // 사용자 아이디
                        .claim("rol", roles)                                   // 권한 정보
                        .expiration( new Date(System.currentTimeMillis() + day5) )  // 만료시간
                        .compact();                                                 // 토큰 생성


        log.info("jwt : "  + jwt);



                        
        return new ResponseEntity<>(jwt, HttpStatus.OK);
    }
    


    /**
     * 회원 가입 화면
     * 🔗 [GET] - /join
     * 📄 join.html
     */
    @GetMapping("/join")
    public String join() {
        log.info(":::::::::: 회원 가입 화면 ::::::::::");

        return "join";
    }

    /**
     * 회원 가입 처리
     * 🔗 [POST] - /join
     */
    @PostMapping("/join")
    public String joinPro(Users user, HttpServletRequest request,  RedirectAttributes redirectAttributes) throws Exception {
        log.info(":::::::::: 회원 가입 처리 ::::::::::");
        String plainPassword = user.getPassword();

        // 회원 가입 요청
        int result = userService.join(user);

        // 회원 가입 성공 시, 바로 로그인 처리
        if (result > 0) {
            user.setPassword(plainPassword); // 암호화 전 비밀번호로 로그인 처리
            boolean loginResult = userService.login(user, request);
            if (loginResult) {
                return "redirect:/";
            }
        }
        redirectAttributes.addFlashAttribute("message", "회원가입에 실패했습니다..");
        // 회원 가입 실패 시
        return "redirect:/join?error";
    }

    /**
     * 아이디 중복 검사
     * 🔗 [GET] - /check/{id}
     */
    @GetMapping("/check/{id}")
    public ResponseEntity<Boolean> userCheck(@PathVariable("id") String id) throws Exception {
        log.info("아이디 중복 확인: " + id);
        Users user = userService.selectId(id);

        if (user != null) {
            log.info("중복된 아이디입니다: " + id);
            return new ResponseEntity<>(false, HttpStatus.CREATED);
        }
        return new ResponseEntity<>(true, HttpStatus.OK);
    }


// @GetMapping("error/403")
//     public String error403() {
//         return "error/403";
//     }
    

}
