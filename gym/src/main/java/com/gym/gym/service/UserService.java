package com.gym.gym.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.UserAuth;
import com.gym.gym.domain.Users;

import jakarta.servlet.http.HttpServletRequest;

public interface UserService {

     //로그인
    public boolean login(Users user, HttpServletRequest request) throws Exception;

    // 데이터 개수
    public int count(@Param("option")Option option) throws Exception;
  
    public List<Users> list(@Param("option") Option option, @Param("page") Page page ) throws Exception;
    
    public List<Users> list() throws Exception;

    public Users selectId(String id) throws Exception;

    public Users select(Long no) throws Exception;

    public Users selectCode(String code) throws Exception;
    
    public int join(Users user) throws Exception;

    public boolean update(Users user) throws Exception;

    public int insertAuth(UserAuth userAuth) throws Exception;
    
    public int updateAuth(UserAuth userAuth) throws Exception;

    public int delete(@Param("no") Long no) throws Exception;

    public int deleteAuth(@Param("no") Long no) throws Exception;
    
    public UserAuth selectAuth(Long no) throws Exception; 

  public Users findUserByDetails(@Param("name") String name,@Param("phone") String phone,@Param("question") String question,@Param("answer") String answer) throws Exception;

    public Users findUserByPassword(@Param("name") String name,@Param("phone") String phone,@Param("question") String question,@Param("answer") String answer, @Param("id")String id) throws Exception;

    public int codeInsert(Users user) throws Exception;

    public int passwordUpdate(Users user) throws Exception;

    public int updateTrainerNo(Long no) throws Exception;


}
