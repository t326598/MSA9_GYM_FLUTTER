package com.gym.gym.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.HttpStatus;
import org.springframework.http.MediaType;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

import com.gym.gym.domain.Files;
import com.gym.gym.domain.Page;
import com.gym.gym.domain.TrainerProfile;
import com.gym.gym.domain.Users;
import com.gym.gym.service.FileService;
import com.gym.gym.service.TrainerProfileService;
import com.gym.gym.service.UserService;

import lombok.extern.slf4j.Slf4j;

@Slf4j
@RestController
@RequestMapping("/admin/trainer")
public class TrainerProfileController {

    @Autowired
    private TrainerProfileService trainerProfileService;
    @Autowired
    private FileService fileService;
    @Autowired
    private UserService userService;

    /**
     * 목록 조회
     */
    @GetMapping("/list")
    public ResponseEntity<List<TrainerProfile>> list(@RequestParam(name = "keyword", defaultValue = "") String keyword, Page page) {
        try {
            List<TrainerProfile> trainerList = trainerProfileService.list(keyword, page);
            return new ResponseEntity<>(trainerList, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error retrieving trainer list", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 트레이너 상세 조회
     */
    @GetMapping("/select")
    public ResponseEntity<TrainerProfile> select(@RequestParam("no") int no) {
        try {
            TrainerProfile trainerProfile = trainerProfileService.select(no);
            return new ResponseEntity<>(trainerProfile, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error retrieving trainer profile", e);
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    /**
     * 등록에 필요한 트레이너 사용자 목록
     */
    @GetMapping("/trainerUsers")
    public ResponseEntity<List<Users>> trainerUsers() {
        try {
            List<Users> trainerUsers = trainerProfileService.trainerUsers();
            return new ResponseEntity<>(trainerUsers, HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error retrieving trainer users", e);
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 선택된 트레이너 번호 조회
     */
    @GetMapping("/getTrainerNo")
    public ResponseEntity<Long> getTrainerNo(@RequestParam("trainerNo") Long trainerNo) {
        try {
            Users trainer = userService.select(trainerNo);
            return new ResponseEntity<>(trainer.getNo(), HttpStatus.OK);
        } catch (Exception e) {
            log.error("Error retrieving trainer number", e);
            return new ResponseEntity<>(HttpStatus.NOT_FOUND);
        }
    }

    /**
     * 트레이너 등록
     */
    @PostMapping("/insert")
    public ResponseEntity<String> insert(TrainerProfile trainerProfile) {
        try {
            int result = trainerProfileService.insert(trainerProfile);
            if (result > 0) {
                return new ResponseEntity<>("Trainer profile created successfully", HttpStatus.CREATED);
            } else {
                return new ResponseEntity<>("Error inserting trainer profile", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            log.error("Error inserting trainer profile", e);
            return new ResponseEntity<>("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 트레이너 정보 수정
     */
    @PutMapping(value = "/update" , consumes = MediaType.MULTIPART_FORM_DATA_VALUE)
    public ResponseEntity<String> update(TrainerProfile trainerProfile) {
        try {
            int result = trainerProfileService.update(trainerProfile);
            log.info("trainerProfile : {}", trainerProfile);
            if (result > 0) {
                return new ResponseEntity<>("Trainer profile updated successfully", HttpStatus.OK);
            } else {
                return new ResponseEntity<>("Error updating trainer profile", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            log.error("Error updating trainer profile", e);
            return new ResponseEntity<>("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }

    /**
     * 트레이너 삭제
     */
    @DeleteMapping("/delete")
    public ResponseEntity<String> delete(@RequestParam("no") int no) {
        try {
            Files file = fileService.select(no);

            int result = fileService.deleteByParent(file);
            int result2 = trainerProfileService.delete(no);

            if (result > 0 && result2 > 0) {
                return new ResponseEntity<>("Trainer profile deleted successfully", HttpStatus.NO_CONTENT);
            } else {
                return new ResponseEntity<>("Error deleting trainer profile", HttpStatus.BAD_REQUEST);
            }
        } catch (Exception e) {
            log.error("Error deleting trainer profile", e);
            return new ResponseEntity<>("Internal server error", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
}
