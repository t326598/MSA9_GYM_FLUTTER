package com.gym.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.gym.gym.domain.Ticket;

@Mapper
public interface TicketMapper {

    public List<Ticket> allList(String keyword) throws Exception;

    public List<Ticket> normalList() throws Exception;

    public List<Ticket> ptList() throws Exception;

    public Ticket select(int no) throws Exception;

    public int insert(Ticket ticket) throws Exception;

    public int update(Ticket ticket) throws Exception;

    public int delete(int no) throws Exception;

}
