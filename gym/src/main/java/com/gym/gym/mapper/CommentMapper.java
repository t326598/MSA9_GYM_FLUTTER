package com.gym.gym.mapper;

import java.util.Date;
import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.Comment;

@Mapper
public interface CommentMapper {
    public Comment selectByDate(@Param("commentDate")Date commentDate, @Param("userNo")int userNo)throws Exception;

    public Comment selectByNo(int no)throws Exception;

    public List<Comment> selectByTrainer(int trainerNo) throws Exception;

    public List<Comment> selectByUser(int userNo) throws Exception;
    
    public List<Comment> selectByPeriod(@Param("userNo")int userNo, @Param("startTime")Date startTime, @Param("endTime")Date endTime) throws Exception;

    public int insert(Comment comment) throws Exception;

    public int update(Comment comment) throws Exception;
    
    public int updateByNo(Comment comment) throws Exception;

    public int delete(int no) throws Exception;

}
