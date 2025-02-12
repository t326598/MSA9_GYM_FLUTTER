package com.gym.gym.security.filter;

import java.io.IOException;

import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.web.filter.OncePerRequestFilter;

import com.gym.gym.security.constants.SecurityConstants;
import com.gym.gym.security.provider.JwtProvider;

import jakarta.servlet.FilterChain;
import jakarta.servlet.ServletException;
import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpServletResponse;
import lombok.extern.slf4j.Slf4j;

@Slf4j
public class JwtRequestFilter extends OncePerRequestFilter {
    
    private final AuthenticationManager authenticationManager;
    private final JwtProvider jwtProvider;
  
    public JwtRequestFilter(AuthenticationManager authenticationManager, JwtProvider jwtProvider){
        this.authenticationManager = authenticationManager;
        this.jwtProvider = jwtProvider;
    }


    /*
     * 요청 필터 작업
     * 1. JWT 추출
     * 2. 인증 시도
     * 3. JWT 검증
     *  유효시: 토큰이 유효하면, 인증 처리 완료
     *  유효하지 않을시 : 토큰 만료되면, (-)
     * 4. 다음 필터로 진행
     */
    @Override
    protected void doFilterInternal(HttpServletRequest request, HttpServletResponse response, FilterChain filterChain)
            throws ServletException, IOException {

                // 1. JWT 추출
                String authorization = request.getHeader(SecurityConstants.TOKEN_HEADER); // Authorization
                // log.info("authorization : " + authorization);

                // "Berer {jwt}" 체크
                if(authorization == null || authorization.length() == 0 || !authorization.startsWith(SecurityConstants.TOKEN_PREFIX)){
                    filterChain.doFilter(request, response);
                    return;
                }
            
                // JWT
                // : "Bearer {jwt}" > Bearer 제거 = jwt
                String jwt = authorization.replace(SecurityConstants.TOKEN_PREFIX, "");

                // 2. 인증 시도
                Authentication authentication = jwtProvider.getAuthenticationToken(jwt);


                if(authentication != null && authentication.isAuthenticated()){
                    log.info("JWT 를 통한 인증 완료");
                }

                // 3. JWT 검증
                boolean result = jwtProvider.validateToken(jwt);
                if( result ) {
                    // JWT 토큰이 유효하면, 인증 처리 완료
                    log.info("유효한 JWT 토큰 입니다.");
                    //  SecurityContextHolder : 사용자 보안정보를 담는 객체
                    //  Authentication        : 사용자 인증 정보
                    //  SecurityContextHolder 안에 Authentication을 집어넣는 작업이 로그인
                    SecurityContextHolder.getContext().setAuthentication(authentication);
                }

                // 4. 다음 필터로 진행
                filterChain.doFilter(request, response);

            }


    
}
