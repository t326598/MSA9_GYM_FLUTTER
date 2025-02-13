package com.gym.gym.service;

import com.google.zxing.BarcodeFormat;
import com.google.zxing.EncodeHintType;
import com.google.zxing.qrcode.QRCodeWriter;
import com.google.zxing.common.BitMatrix;
import com.gym.gym.domain.QRcode;
import com.gym.gym.mapper.QRcodeMapper;

import lombok.extern.slf4j.Slf4j;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import java.awt.*;
import java.awt.image.BufferedImage;
import java.io.OutputStream;
import java.util.HashMap;
import java.util.Map;

@Slf4j
@Service
public class QRCodeGenerator {

    @Autowired
    QRcodeMapper qRcodeMapper;

    public int QRinsert(QRcode qrCode) throws Exception {

        return qRcodeMapper.insertQRcode(qrCode);
    }

    public int deleteQRcode(String uuid) throws Exception {
        return qRcodeMapper.deleteQRcode(uuid);
    }

    public void generateQRCodeImage(QRcode qrCode, OutputStream outputStream) throws Exception {
        String qrText = createQRText(qrCode); // QR 코드에 포함할 텍스트 생성

        log.info("qwer" + qrCode);

        int width = 500; // QR 코드 이미지의 가로 크기
        int height = 500; // QR 코드 이미지의 세로 크기
        String fileType = "png"; // 이미지 파일 타입

        Map<EncodeHintType, Object> hintMap = new HashMap<>();
        hintMap.put(EncodeHintType.MARGIN, 1); // 여백 설정

        QRCodeWriter qrCodeWriter = new QRCodeWriter();
        BitMatrix bitMatrix = qrCodeWriter.encode(qrText, BarcodeFormat.QR_CODE, width, height, hintMap);

        BufferedImage image = new BufferedImage(width, height, BufferedImage.TYPE_INT_RGB);
        image.createGraphics();

        for (int x = 0; x < width; x++) {
            for (int y = 0; y < height; y++) {
                image.setRGB(x, y, bitMatrix.get(x, y) ? Color.BLACK.getRGB() : Color.WHITE.getRGB());
            }
        }

        javax.imageio.ImageIO.write(image, fileType, outputStream);
    }

    private String createQRText(QRcode qrCode) {
        return String.format("http://192.168.30.63:8080/user/attendance/check?qrcodeId=%d&uuid=%s",
                qrCode.getNo(), qrCode.getUuid());
    }
}
