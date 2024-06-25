package com.kim.app.controller;

import java.io.File;
import java.net.URLDecoder;
import java.nio.charset.StandardCharsets;
import java.nio.file.Files;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.http.HttpHeaders;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.util.FileCopyUtils;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.RestController;

@RestController
public class ImageController {
	@Value("${upload.path}") // application 의 properties 의 변수
    private String uploadPath;

	@GetMapping("/display")
    public ResponseEntity<byte[]> getFile(@RequestParam(value="fileName") String fileName) {

        ResponseEntity<byte[]> result;
        
        try {
            String srcFileName = URLDecoder.decode(fileName, StandardCharsets.UTF_8);

            System.out.println("fileName: " + srcFileName);

            File file = new File(uploadPath + File.separator + srcFileName);
            
            System.out.println("file: " + file);

            HttpHeaders header = new HttpHeaders();

            // MIME 타입 처리
            header.add("Content-Type", Files.probeContentType(file.toPath()));

            // 파일 데이터 처리
            result = new ResponseEntity<>(FileCopyUtils.copyToByteArray(file), header, HttpStatus.OK);

        } catch (Exception e) {
            System.out.println(e.getMessage());
            return new ResponseEntity<>(HttpStatus.INTERNAL_SERVER_ERROR);
        }

        return result;
         
    }
}
