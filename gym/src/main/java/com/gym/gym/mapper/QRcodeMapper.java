package com.gym.gym.mapper;

import javax.print.DocFlavor.STRING;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.google.zxing.qrcode.encoder.QRCode;
import com.gym.gym.domain.QRcode;

@Mapper
public interface QRcodeMapper {

    // 출석 체크 ( 등록 )
    public int insertQRcode(QRcode qRcode) throws Exception;

    // 출석 체크 ( 삭제 )
    public int deleteQRcode(String uuid) throws Exception;

    // UUID 존재 확인 ㅋ
    public QRcode selectQRcode(@Param("userNo") Long userNo) throws Exception;

}
