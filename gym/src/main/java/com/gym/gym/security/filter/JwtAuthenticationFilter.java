package com.gym.gym.security.filter;

import java.io.IOException;
import java.io.PrintWriter;
import java.util.List;
import java.util.stream.Collectors;

import javax.management.RuntimeErrorException;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.core.GrantedAuthority;
import org.springframework.security.web.authentication.UsernamePasswordAuthenticationFilter;

import com.fasterxml.jackson.databind.ObjectMapper;
import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.Users;
import com.gym.gym.security.constants.SecurityConstants;
import com.gym.gym.security.provider.JwtProvider;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class JwtAuthenticationFilter extends UsernamePasswordAuthenticationFilter {
    
    private final AuthenticationManager authenticationManager;

    private final JwtProvider jwtProvider;

    public JwtAuthenticationFilter (AuthenticationManager authenticationManager, JwtProvider jwtProvider){
        this.authenticationManager = authenticationManager;
        this.jwtProvider = jwtProvider;
        // 필터 URL 경로 설정 : /login
        setFilterProcessesUrl((SecurityConstants.LOGIN_URL));
    }

    /*
     * 인증 시도 메소드
     * :/login 경로로(username, password) 요청하면 이 필터에서 로그인 인증을 시도합니다.
     */

    @Override
    public Authentication attemptAuthentication(HttpServletRequest request, HttpServletResponse response)
            throws AuthenticationException {
            
               // POST 토큰 생성 방식
                String id = "";
                String password = "";

                try{
                    ObjectMapper objectMapper = new ObjectMapper();
                    Users loginRequest = objectMapper.readValue(request.getInputStream(), Users.class);
                    id = loginRequest.getId();
                    password = loginRequest.getPassword();
                }catch(Exception e){
                    log.error("실패함", e);
                    throw new RuntimeException(e);
                }


                // 인증토큰 객체 생성
                Authentication authentication = new UsernamePasswordAuthenticationToken(id, password);
            
                log.info(authentication + "이거 왜 안됨?");
                // 인증(로그인)
                authentication = authenticationManager.authenticate(authentication);

                // 인증 실패
                if( authentication != null && !authentication.isAuthenticated() ){
                    log.info("인증 실패 : 아이디 또는 비밀번호가 일치하지 않습니다.");
                    response.setStatus(401); //401 Unauthorized: 인증실패
                }
                return authentication;

    }

    /*
     *  인증 성공 메소드
     * : attemptAuthentication() 호출 후, 반환된 Authentication 객체가 인증된 것이 확인되면 호출되는 메소드
     * 
     * 성공시 jwt 토큰 발행
     * : 로그인 인증에 성공, JWT 토큰 생성
        Authorization 응답헤더에 jwt 토큰을 담아 응답
     * {Authorization : Bearer + {jwt}}
     */
    @Override
    protected void successfulAuthentication(HttpServletRequest request, HttpServletResponse response, FilterChain chain,
            Authentication authentication) throws IOException, ServletException {

                log.info("인증 성공");

                CustomUser customUser = (CustomUser) authentication.getPrincipal();

                Users user = customUser.getUser();
                String id = user.getId();
                Long no = user.getNo();

    

                List<String> roles =customUser.getAuthorities()
                                                .stream()
                                                .map(GrantedAuthority::getAuthority)
                                                .collect(Collectors.toList());

                                                
                // JWT 생성
                String jwt = jwtProvider.creteToken(no, id,  roles);

                

                // Authorization 응답 헤더 세팅
                response.addHeader("Authorization", SecurityConstants.TOKEN_PREFIX + jwt);
                response.setStatus(200);

                // 사용자 정보 body 세팅
                ObjectMapper ObjectMapper = new ObjectMapper();
                String jsonString = ObjectMapper.writeValueAsString(user);

                response.setContentType("application/json");
                response.setCharacterEncoding("UTF-8");
                
                // jsonStirng : "{'id' : 'aloha', 'name' : '사용자', ....}"
                PrintWriter printWriter = response.getWriter();
                printWriter.write(jsonString);
                printWriter.flush();
    }

    


    
    
}
