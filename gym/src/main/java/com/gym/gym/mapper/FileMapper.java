package com.gym.gym.mapper;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.gym.gym.domain.Files;

@Mapper
public interface FileMapper {
    
    public List<Files> list() throws Exception;

    // 트레이너 번호로 찾기
    public Files select(int no)  throws Exception;
    // 파일번호로 찾기
    public Files selectByNo(int no)  throws Exception;

    public int insert(Files file) throws Exception;

    public int update(@Param("file") Files file, @Param("fileNo") int fileNo) throws Exception;

    public int delete(int no) throws Exception;

    // 부모 테이블 기준 파일 목록
    public List<Files> listByParent(Files file) throws Exception;

    // 부모 테이블 기준 파일 삭제
    public int deleteByParent(Files file) throws Exception;

}
