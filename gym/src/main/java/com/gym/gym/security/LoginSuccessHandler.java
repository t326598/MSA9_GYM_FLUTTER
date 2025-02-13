package com.gym.gym.security;

import java.io.IOException;

import org.springframework.security.core.Authentication;
import org.springframework.security.web.authentication.SavedRequestAwareAuthenticationSuccessHandler;
import org.springframework.stereotype.Component;

import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Users;

import jakarta.servlet.ServletException;
import jakarta.servlet.http.Cookie;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

/**
 * 로그인 성공 처리 이벤트 핸들러
    아이디 저장 쿠키 생성
    로그인 후 이전 페이지로 리다이렉트
 */

@Slf4j
@Component
public class LoginSuccessHandler extends SavedRequestAwareAuthenticationSuccessHandler {
    
    
    /**
     *  로그인 성공 시 호출되는 메소드
     *   아이디 저장 쿠키 생성
     *  */    
    @Override
    public void onAuthenticationSuccess(HttpServletRequest request
                                        , HttpServletResponse response
                                        , Authentication authentication) throws ServletException, IOException {
        log.info("로그인 성공....");  
        // 아이디 저장
        String rememberId = request.getParameter("remember-id");    // 아이디 저장 여부
        String username = request.getParameter("id");               // 아이디

        // 아이디 저장 체크 여부 확인
        if( rememberId != null && rememberId.equals("on")) {
            Cookie cookie = new Cookie("remember-id", username); //쿠키에 아이디 등록
            cookie.setMaxAge(60 * 60 * 24 * 7);  // 유효기간 7일
            cookie.setPath("/");
            response.addCookie(cookie);
        }
        else{
            Cookie cookie = new Cookie("remember-id", username); // 쿠키에 아이디 등록
            cookie.setMaxAge(0);  // 유효기간 0일 (삭제)
            cookie.setPath("/");
            response.addCookie(cookie);
        }

         // 인증된 사용자 정보  
         CustomUser customUser = (CustomUser) authentication.getPrincipal();
         Users user = customUser.getUser();


        

        super.onAuthenticationSuccess(request, response, authentication);
    }
  

    

    
}
