package com.gym.gym.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Answer;
import com.gym.gym.mapper.AnswerMapper;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@Service
public class AnswerServiceImpl implements AnswerService {

    @Autowired
    private AnswerMapper answerMapper;

    @Override
    public List<Answer> list() throws Exception {
        List<Answer> answerList = answerMapper.list();
        return answerList;    
    }

    @Override
    public Answer select(Long no) throws Exception {
        Answer answer = answerMapper.select(no);
        return answer;

    }

    @Override
    public int insert(Answer answer) throws Exception {
        int result = answerMapper.insert(answer);
        return result;
    }

    @Override
    public int update(Answer answer) throws Exception {
        int result = answerMapper.update(answer);
        return result;

    }

    @Override
    public int delete(Long no) throws Exception {
        int result = answerMapper.delete(no);
        return result;
    }

    @Override
    public List<Answer> listByParent(Long boardNo) throws Exception {
        List<Answer> answerList = answerMapper.listByParent(boardNo);
        return answerList;
    }

    @Override
    public int deleteByParent(Long boardNo) throws Exception {
        int result = answerMapper.deleteByParent(boardNo);
        return result;
    }
    
}
