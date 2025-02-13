package com.gym.gym.service;

import java.util.List;

import com.gym.gym.domain.Files;

public interface FileService {
    
    public List<Files> list() throws Exception;

    // 트레이너 번호로 찾기
    public Files select(int no)  throws Exception;
    // 파일번호로 찾기
    public Files selectByNo(int no)  throws Exception;

    public int insert(Files file) throws Exception;

    public int update(Files file, int fileNo) throws Exception;

    public int delete(int no) throws Exception;

    // 파일 업로드
    public boolean upload(Files file) throws Exception;

    // 부모 테이블 기준 파일 목록
    public List<Files> listByParent(Files file) throws Exception;

    // 부모 테이블 기준 파일 삭제
    public int deleteByParent(Files file) throws Exception;
}
