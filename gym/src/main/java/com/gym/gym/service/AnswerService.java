package com.gym.gym.service;

import java.util.List;

import com.gym.gym.domain.Answer;

public interface AnswerService {

    
    
public List<Answer> list() throws Exception;

public Answer select(Long no) throws Exception;

    public int insert(Answer answer) throws Exception;

    public int update(Answer answer) throws Exception;
    
    public int delete(Long no) throws Exception;

    public List<Answer> listByParent(Long boardNo) throws Exception;

    public int deleteByParent(Long boardNo ) throws Exception;


}
