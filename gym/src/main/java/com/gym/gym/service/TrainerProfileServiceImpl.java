package com.gym.gym.service;

import java.util.Collections;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.gym.gym.domain.Files;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.TrainerProfile;
import com.gym.gym.domain.Users;
import com.gym.gym.mapper.TrainerProfileMapper;

import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
public class TrainerProfileServiceImpl implements TrainerProfileService {

    @Autowired private TrainerProfileMapper trainerProfileMapper;
    @Autowired private FileService fileService;

    @Override
    public List<TrainerProfile> list() throws Exception {
        return trainerProfileMapper.list("", new Page());
    }

    @Override
    public TrainerProfile select(int no) throws Exception {
        return trainerProfileMapper.select(no);
    }

    @Override
    public int insert(TrainerProfile trainerPofile) throws Exception {
        int result = trainerProfileMapper.insert(trainerPofile);
        List<MultipartFile> fileList = trainerPofile.getFileList();

        if( fileList != null ) 
            for (MultipartFile file : fileList) {
                // 빈 파일이 넘어온 경우 
                if (file != null && file.isEmpty()) 
                    continue;
                
                Files uploadFile = new Files();
                uploadFile.setFile(file);
                uploadFile.setProfileNo(trainerPofile.getNo());
                uploadFile.setType("main");
                fileService.upload(uploadFile);
            }
        return result;
    }

    @Override
    public int update(TrainerProfile trainerPofile) throws Exception {
        
        int result = trainerProfileMapper.update(trainerPofile);
        // 파일 찾기
        Files file = fileService.selectByNo(trainerPofile.getFileNo());
        log.info("파일 : " + file);

        List<MultipartFile> fileList = trainerPofile.getFileList();

        if( fileList != null ) 
            for (MultipartFile updateFile : fileList) {
                // 빈 파일이 넘어온 경우 
                if (updateFile != null && updateFile.isEmpty()) 
                    continue;
                
                Files uploadFile = new Files();
                uploadFile.setFile(updateFile);
                uploadFile.setProfileNo(trainerPofile.getNo());
                uploadFile.setType("main");
                result = fileService.update(uploadFile, trainerPofile.getFileNo());
            }

        

        return result;
    }

    @Override
    public int delete(int no) throws Exception {
        int result = trainerProfileMapper.delete(no);
        return result;
    }

    @Override
    public List<TrainerProfile> list(String keyword, Page page) throws Exception {
        
        int total = count(keyword);
        page.setTotal(total);

        return trainerProfileMapper.list(keyword, page);
    }

    @Override
    public List<Users> trainerUsers() throws Exception {
        List<Users> trainUsers = trainerProfileMapper.trainerUsers();
        return trainUsers;
    }

    @Override
    public int count(String keyword) throws Exception {
        int total = trainerProfileMapper.count(keyword);

        return total;
    }

    @Override
    public TrainerProfile selectTrainer(int trainerNo) throws Exception {
        return trainerProfileMapper.selectTrainer(trainerNo);
    }

    
}
