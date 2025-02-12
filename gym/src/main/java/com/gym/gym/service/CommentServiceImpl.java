package com.gym.gym.service;

import java.util.Date;
// import java.util.Date;
import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Comment;
import com.gym.gym.mapper.CommentMapper;

@Service
public class CommentServiceImpl implements CommentService{

    @Autowired
    CommentMapper commentMapper;

    @Override
    public Comment selectByDate(Date commentDate, int userNo) throws Exception {
       Comment comment = commentMapper.selectByDate(commentDate, userNo);
       return comment;
    }

    @Override
    public Comment selectByNo(int no) throws Exception {
        Comment comment = commentMapper.selectByNo(no);
        return comment;
    }

    @Override
    public List<Comment> selectByTrainer(int trainerNo) throws Exception {
        List<Comment> commentList = commentMapper.selectByTrainer(trainerNo);
        return commentList;
    }
    
    @Override
    public List<Comment> selectByUser(int userNo) throws Exception {
        List<Comment> commentList = commentMapper.selectByUser(userNo);
        return commentList;
    }

    @Override
    public List<Comment> selectByStartEnd(int userNo, Date startTime, Date endTime) throws Exception {
        List<Comment> commentList = commentMapper.selectByPeriod(userNo, startTime, endTime);
        return commentList;
    }

    @Override
    public int insert(Comment comment) throws Exception {
        int result = commentMapper.insert(comment);
        return result;
    }

    @Override
    public int update(Comment comment) throws Exception {
        int result = commentMapper.update(comment);
        return result;
    }
    
    @Override
    public int updateByNo(Comment comment) throws Exception {
        int result = commentMapper.updateByNo(comment);
        return result;
    }

    @Override
    public int delete(int no) throws Exception {
        int result = commentMapper.delete(no);
        return result;       
    }

    
}
