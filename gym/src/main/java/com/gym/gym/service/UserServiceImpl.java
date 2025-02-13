package com.gym.gym.service;

import java.util.List;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RequestParam;

import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.UserAuth;
import com.gym.gym.domain.Users;
import com.gym.gym.mapper.UserMapper;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class UserServiceImpl implements UserService {


    @Autowired
    private UserMapper userMapper;

    @Autowired
    private PasswordEncoder passwordEncoder;

    @Override
    public List<Users> list() throws Exception {
        List<Users> userList = userMapper.list(new Option(), new Page());

                return userList;
    }

    @Override
    public Users select(Long no) throws Exception {
        Users user = userMapper.select(no);
        return user;
    }

    @Override
    @Transactional // 트랜잭션 처리 설정(회원정보, 회원 권한)
    public int join(Users user) throws Exception {
        String password = user.getPassword();
        
        String encodePassword = passwordEncoder.encode(password);
        user.setPassword(encodePassword);
        user.setEnabled(1);
        int result = userMapper.join(user);
        
        Long userNo = user.getNo();
        
        if(result > 0){
            UserAuth userAuth = new UserAuth();
            userAuth.setUserNo(userNo);
            userAuth.setAuth("ROLE_USER");
            result = userMapper.insertAuth(userAuth);
        }
        return result;
    }

    @Override
    public boolean update(Users user) throws Exception {
        int result = userMapper.update(user);
        return result > 0;
    }

    @Override
    public int insertAuth(UserAuth userAuth) throws Exception {
        int result = userMapper.insertAuth(userAuth);
        return result;
    }

    @Override
    public int updateAuth(UserAuth userAuth) throws Exception {
        int result = userMapper.updateAuth(userAuth);
        return result;
    }

    @Override
    public int delete(@PathVariable("no") Long no) throws Exception {
        int result = userMapper.delete(no);
        return result;
    }

    @Override
    public int deleteAuth(@PathVariable("no") Long no) throws Exception {
        int result = userMapper.deleteAuth(no);
        return result;
    }
    



      @Autowired
    private AuthenticationManager authenticationManager;
 
    @Override
    public boolean login(Users user, HttpServletRequest request) throws Exception {
       // // 💍 토큰 생성
       String username = user.getId();    // 아이디
       String password = user.getPassword();    // 암호화되지 않은 비밀번호
       UsernamePasswordAuthenticationToken token 
           = new UsernamePasswordAuthenticationToken(username, password);
       
       // 토큰을 이용하여 인증
       Authentication authentication = authenticationManager.authenticate(token);

       // 인증 여부 확인
       boolean result = authentication.isAuthenticated();

       if(result){
           // 시큐리티 컨텍스트에 등록
           SecurityContextHolder.getContext().setAuthentication(authentication);

            HttpSession session = request.getSession(true); // 세션이 없으면 새로 생성
            session.setAttribute("SPRING_SECURITY_CONTEXT", SecurityContextHolder.getContext());
       }
       else{
           log.error("바로 로그인 인증에 실패하였습니다.");
       }


       return result;
   }

    @Override
    public Users selectId(String id) throws Exception {
        Users user = userMapper.selectId(id);
        return user;
    }

    @Override
    public UserAuth selectAuth(Long no) throws Exception {
        UserAuth userAuth = userMapper.selectAuth(no);
        return userAuth;
    }

    @Override
    public Users findUserByDetails(@RequestParam("name") String name,
    @RequestParam("phone") String phone, @RequestParam("question") String question,
    @RequestParam("answer") String answer) throws Exception {
        Users user = userMapper.findUserByDetails(name, phone, question, answer);
        return user;
    }

    @Override
    public Users findUserByPassword(@RequestParam("name") String name,@RequestParam("phone") String phone,
    @RequestParam("question") String question,@RequestParam("answer") String answer,@RequestParam("id") String id)
            throws Exception {
                Users user = userMapper.findUserByPassword(name, phone, question, answer, id);
                return user;
    }

    @Override
    public int codeInsert(Users user) throws Exception {
  
        int result = userMapper.codeInsert(user);
        return result;
    }

    @Override
    public int passwordUpdate(Users user) throws Exception {
        int result = userMapper.passwordUpdate(user);
        return result;

    }

    @Override
    public List<Users> list(Option option, Page page) throws Exception {
        int total = count(option);
        page.setTotal(total);

        List<Users> userList = userMapper.list(option, page);
        return userList;

    }

    @Override
    public int count(Option option) throws Exception {
        return userMapper.count(option);
    }

    @Override
    public int updateTrainerNo(Long no) throws Exception {
        return userMapper.updateTrainerNo(no);
    }

    @Override
    public Users selectCode(String code) throws Exception {
        return userMapper.selectCode(code);
    }


    
    


}
