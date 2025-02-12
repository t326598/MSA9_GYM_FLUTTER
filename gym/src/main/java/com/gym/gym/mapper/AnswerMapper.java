package com.gym.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.gym.gym.domain.Answer;

@Mapper
public interface AnswerMapper {

public List<Answer> list() throws Exception;

public Answer select(Long no) throws Exception;

    public int insert(Answer answer) throws Exception;

    public int update(Answer answer) throws Exception;
    
    public int delete(Long no) throws Exception;

    public List<Answer> listByParent(Long boardNo) throws Exception;

    public int deleteByParent(Long boardNo ) throws Exception;


}
