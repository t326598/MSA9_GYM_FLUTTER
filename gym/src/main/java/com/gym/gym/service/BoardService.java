package com.gym.gym.service;

import java.util.List;

import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.Board;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;


public interface BoardService {
     public List<Board> list(@Param("option") Option option
                            ,@Param("page") Page page ) throws Exception;
    // 게시글과 댓글 함께 조회 
    public List<Board> boardlist(@Param("option") Option option
    ,@Param("page") Page page ) throws Exception;
    // 조회
    public Board select(Long no)throws Exception;
    // 등록
    public int insert(Board board) throws Exception;
    // 수정
    public int update(Board board) throws Exception;
    // 삭제
    public int delete(Long no) throws Exception;

    // 데이터 개수
    public int count(@Param("option")Option option) throws Exception;

    public List<Board> list() throws Exception;

    public Boolean isOwner(Long no, Long boardNo) throws Exception;

    public List<Board> myBoardlist(@Param("option") Option option, @Param("page") Page page,@Param("no") Long no) throws Exception;

    public int countByUserNo(@Param("no") Long no)throws Exception;

}
