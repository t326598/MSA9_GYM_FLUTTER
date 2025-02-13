package com.gym.gym.security.provider;

import java.util.Date;
import java.util.List;
import java.util.stream.Collectors;

import javax.crypto.SecretKey;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.authority.SimpleGrantedAuthority;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.stereotype.Component;

import com.gym.gym.domain.CustomUser;
import com.gym.gym.domain.UserAuth;
import com.gym.gym.domain.Users;
import com.gym.gym.mapper.UserMapper;
import com.gym.gym.security.constants.SecurityConstants;
import com.gym.gym.security.props.JwtProps;

import io.jsonwebtoken.Claims;
import io.jsonwebtoken.ExpiredJwtException;
import io.jsonwebtoken.Jws;
import io.jsonwebtoken.JwtException;
import io.jsonwebtoken.Jwts;
import io.jsonwebtoken.MalformedJwtException;
import io.jsonwebtoken.UnsupportedJwtException;
import io.jsonwebtoken.security.Keys;
import lombok.extern.slf4j.Slf4j;

// JWT 토큰 관련 기능을 제공하는 클래스
/*
 * 토큰 생성
 * 토큰 해석
 * 토큰 검증
 */

@Slf4j
@Component
public class JwtProvider {
    
    @Autowired
    private JwtProps jwtProps;

    @Autowired
    private UserMapper userMapper;

    public String creteToken(Long no, String id, List<String> roles) {

        SecretKey shakey = getShaKey();
        int exp = 1000 * 60 * 60 * 24 * 7;

        // JWT 토큰 생성
        String jwt = Jwts.builder()
                        .signWith(shakey, Jwts.SIG.HS512) // 시그니처 비밀키, 알고리즘 설정
                        .header()
                            .add("typ", SecurityConstants.TOKEN_TYPE) // typ : jwt 
                        .and()
                        .expiration(new Date(System.currentTimeMillis() + exp) )
                        .claim("id", id)                    // id       : 사용자 식별키
                        .claim("userNo", no)        // username : 사용자 아이디
                        .claim("rol", roles)                // rol      : 회원 권한 목록
                        .compact();

        

                
        log.info("jwt :" +jwt);                
        return jwt;
        
    }

    /*
     * jwt 토큰 > 인증을 위한 토큰 정보로 해석
     */
    public UsernamePasswordAuthenticationToken getAuthenticationToken (String authorization) {
            if(authorization == null || authorization.length() == 0)
            return null;

            // Authorization : "bearer {jwt}"

            try{
                // jwt 추출
                String jwt = authorization.replace("Bearer ", "");
                log.info("jwt : " + jwt);

                SecretKey shaKey = getShaKey();

                // JWT 파싱
                Jws<Claims> parsedToken = Jwts.parser()
                                                .verifyWith(shaKey)
                                                .build()
                                                .parseSignedClaims(jwt);

                log.info("parsedToken" + parsedToken);

                // 사용자 식별키(id)
                String id = parsedToken.getPayload().get("id").toString();
                // 사용자 아이디
                String userNo = parsedToken.getPayload().get("userNo").toString();
                // 회원 권한
                Object roles = parsedToken.getPayload().get("rol");


                Users user = new Users();
                user.setId(id);

                List<UserAuth> authList = ((List<?>) roles)
                                            .stream()
                                            .map( auth -> UserAuth.builder()
                                                                    .auth(auth.toString())
                                                                    .userNo(Long.parseLong(userNo))
                                                                    .build()
                                                )
                                            .collect(Collectors.toList() )
                                            ;
                user.setAuthList(authList);

                // 시큐리티 권한 목록
                List<SimpleGrantedAuthority> authorities = ((List<?>) roles)
                                                            .stream()
                                                            .map( auth ->  new SimpleGrantedAuthority((String) auth)
                                                                )
                                                            .collect(Collectors.toList() );

                // 추가 유저정보 가져오기
                try{
                    Users userInfo = userMapper.selectId(id);
                    if(userInfo != null){
                        user.setName(userInfo.getName());
                        user.setEmail(userInfo.getEmail());
                        user.setCreatedAt(userInfo.getCreatedAt());
                        user.setNo(userInfo.getNo());
                        user.setQuestion(userInfo.getQuestion());
                        user.setAnswer(userInfo.getAnswer());
                        user.setPhone(userInfo.getPhone());
                        user.setBirth(userInfo.getBirth());
                        user.setGender(userInfo.getGender());
                        user.setTrainerNo(userInfo.getTrainerNo());
                        user.setUserAuth(userInfo.getUserAuth());
                    }
                }catch(Exception e){
                    log.error(e.getMessage());
                    log.error("토큰 해석 중, 회원 추가 정보 조회시 에러 발생");
                }

                UserDetails userDetails = new CustomUser(user);

                // new UsernamePasswordAuthenticationToken(사용자정보객체, 비밀번호, 권한목록)
                return new UsernamePasswordAuthenticationToken(userDetails, null, authorities);

            } catch (ExpiredJwtException exception) {
            log.warn("Request to parse expired JWT : {} failed : {}", authorization, exception.getMessage());
        } catch (UnsupportedJwtException exception) {
            log.warn("Request to parse unsupported JWT : {} failed : {}", authorization, exception.getMessage());
        } catch (MalformedJwtException exception) {
            log.warn("Request to parse invalid JWT : {} failed : {}", authorization, exception.getMessage());
        } catch (IllegalArgumentException exception) {
            log.warn("Request to parse empty or null JWT : {} failed : {}", authorization, exception.getMessage());
        }

            
            catch(Exception e){
                log.info("jwt 토큰 인증 중 에러");

            }
                        return null;
        
    }

    /*
     * 토큰 검증
     */
    public boolean validateToken(String jwt){
        try{
            //  jwt > 토큰 파싱
            Jws<Claims> claims = Jwts.parser()
                                    .verifyWith(getShaKey())
                                    .build()
                                    .parseSignedClaims(jwt);

            Date expiration = claims.getPayload().getExpiration();

            
            log.info("만료기간" + expiration);

            // expiration.after
            // 날짜A.after(날짜 B)
            //  날짜 A가 날짜B 보다 뒤에 있으면 true
            boolean result = expiration.after(new Date());
            return result;

        }catch(ExpiredJwtException e){
            log.error("토큰 만료", e);

        }catch(JwtException e){
            log.error("토큰 잘못됨 에러남;", e);
            
        }catch (NullPointerException e) {
            log.error("토큰 없음");
        }catch(Exception e){
            log.error("토큰 검증 시 예외");

        }
        return false;
        
    }

    public SecretKey getShaKey(){

        String secretKey = jwtProps.getSecretKey();
        byte[] signinKey = secretKey.getBytes();
        SecretKey shakey = Keys.hmacShaKeyFor(signinKey);
        return shakey;
    }

}
