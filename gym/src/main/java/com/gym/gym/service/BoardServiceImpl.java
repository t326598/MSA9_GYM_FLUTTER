package com.gym.gym.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.gym.gym.domain.Board;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;
import com.gym.gym.mapper.BoardMapper;

import groovy.util.logging.Slf4j;

@Slf4j
@Service
public class BoardServiceImpl implements BoardService {

    @Autowired
    private BoardMapper boardMapper;

    @Override
    public List<Board> list(Option option, Page page) throws Exception {
        int total = count(option);
        page.setTotal(total);

        List<Board> boardList = boardMapper.list(option, page);
        return boardList;

    }

    @Override
    public Board select(Long no) throws Exception {
        Board board = boardMapper.select(no);
        return board;
    }

    @Override
    public int insert(Board board) throws Exception {
        int result = boardMapper.insert(board);
        return result;
    }

    @Override
    public int update(Board board) throws Exception {
        int result = boardMapper.update(board);
        return result;

    }

    @Override
    public int delete(Long no) throws Exception {
        int result = boardMapper.delete(no);
        return result;

    }

    @Override
    public int count(Option option) throws Exception {
        return boardMapper.count(option);
    }


    @Override
    public List<Board> list() throws Exception {
        List<Board> boardList = boardMapper.list(new Option(), new Page());
        return boardList;
    }

    @Override
    public Boolean isOwner(Long no, Long userNo) throws Exception {
     
            Board board = boardMapper.select(no);

            return board.getUserNo() == userNo;
        }

    @Override
    public List<Board> boardlist(Option option, Page page) throws Exception {
        int total = count(option);
        page.setTotal(total);

         List<Board> boardList = boardMapper.boardlist(option, page);
        return boardList;
    }

    @Override
    public List<Board> myBoardlist(Option option, Page page, Long no) throws Exception {
        int total = countByUserNo(no);
        page.setTotal(total);
        
        List<Board> boardList = boardMapper.myBoardlist(option, page, no);
        return boardList;

    }

    @Override
    public int countByUserNo(Long no) throws Exception {
    
        return boardMapper.countByUserNo(no);
    }

}


