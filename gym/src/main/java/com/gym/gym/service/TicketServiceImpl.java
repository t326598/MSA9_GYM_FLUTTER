package com.gym.gym.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Ticket;
import com.gym.gym.mapper.TicketMapper;

@Service
public class TicketServiceImpl implements TicketService {

    @Autowired private TicketMapper ticketMapper;

    @Override
    public List<Ticket> allList() throws Exception {
        return ticketMapper.allList("");
    }

    @Override
    public List<Ticket> allList(String keyword) throws Exception {
        return ticketMapper.allList(keyword);
    }

    @Override
    public List<Ticket> normalList() throws Exception {
        return ticketMapper.normalList();
    }
    
    @Override
    public List<Ticket> ptList() throws Exception {
        return ticketMapper.ptList();
    }

    @Override
    public Ticket select(int no) throws Exception {
        return ticketMapper.select(no);
    }

    @Override
    public int insert(Ticket ticket) throws Exception {
        int result = ticketMapper.insert(ticket);
        return result;
    }

    @Override
    public int update(Ticket ticket) throws Exception {
        int result = ticketMapper.update(ticket);
        return result;
    }

    @Override
    public int delete(int no) throws Exception {
        int result = ticketMapper.delete(no);
        return result;
    }
    
}
