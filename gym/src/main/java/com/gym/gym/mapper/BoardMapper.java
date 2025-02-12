package com.gym.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.Board;
import com.gym.gym.domain.Option;
import com.gym.gym.domain.Page;

@Mapper
public interface BoardMapper {


     public List<Board> list(@Param("option") Option option
                            ,@Param("page") Page page ) throws Exception;

    public List<Board> boardlist(@Param("option") Option option
    ,@Param("page") Page page ) throws Exception;

    public List<Board> myBoardlist(@Param("option") Option option, @Param("page") Page page,@Param("no") Long no) throws Exception;
                
    // 조회
    public Board select(@Param("no") Long no)throws Exception;
    // 등록
    public int insert(Board board) throws Exception;
    // 수정
    public int update(Board board) throws Exception;
    // 삭제
    public int delete(Long no) throws Exception;

    // 데이터 개수
    public int count(@Param("option")Option option) throws Exception;

    public Board select1(@Param("id") String id)throws Exception;

    public int countByUserNo(@Param("no") Long no)throws Exception;
    
    public List<Board> list();

}
