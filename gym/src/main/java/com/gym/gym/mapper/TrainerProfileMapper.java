package com.gym.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.Page;
import com.gym.gym.domain.TrainerProfile;
import com.gym.gym.domain.Users;

@Mapper
public interface TrainerProfileMapper {

    // public List<TrainerProfile> list() throws Exception;
    public List<TrainerProfile> list(@Param("keyword") String keyword, @Param("page") Page page) throws Exception;

    public TrainerProfile select(int no) throws Exception;

    public int insert(TrainerProfile trainerPofile) throws Exception;

    public int update(TrainerProfile trainerPofile) throws Exception;

    public int delete(int no) throws Exception;

    public List<Users> trainerUsers() throws Exception;

    public int count(@Param("keyword") String keyword) throws Exception;

    public TrainerProfile selectTrainer(@Param("trainerNo") int trainerNo) throws Exception;

}
