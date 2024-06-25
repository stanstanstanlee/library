package com.kim.app.util;

import java.io.File;
import java.io.IOException;
import java.nio.file.Path;
import java.nio.file.Paths;
import java.util.UUID;

import org.springframework.beans.factory.annotation.Value;
import org.springframework.stereotype.Component;
import org.springframework.web.multipart.MultipartFile;

@Component
public class FileService {
	@Value("${upload.path}") // application 의 properties 의 변수
    private String uploadPath;
	
	public String saveFile(MultipartFile uploadFile) {
		/*
        // 실제 파일 이름 IE나 Edge는 전체 경로가 들어오므로 => 바뀐 듯 ..
        String orginalName = uploadFile.getOriginalFilename();
        String fileName = orginalName.substring(orginalName.lastIndexOf("\\") + 1);

        System.out.println("fileName: "+fileName);

        String folderPath = uploadPath;

        // UUID
        String uuid = UUID.randomUUID().toString();

        // 저장할 파일 이름 중간에 "_"를 이용해서 구현
        String saveName = folderPath + File.separator + uuid + "_" + fileName;

        Path savePath = Paths.get(saveName);

        try {
            uploadFile.transferTo(savePath); // 실제 이미지 저장
            return uuid + "_" + fileName;
        } catch (IOException e) {
            e.printStackTrace();
        }
		
		return null;
		*/
		 if (uploadFile == null || uploadFile.isEmpty()) {
	            return null; // 업로드된 파일이 없으면 null 반환
	        }

	        try {
	            // 파일의 원래 이름을 사용
	            String orginalName = uploadFile.getOriginalFilename();

	            // UUID
	            String uuid = UUID.randomUUID().toString();

	            // 저장할 파일 이름 중간에 "_"를 이용해서 구현
	            String saveName = uploadPath + File.separator + uuid + "_" + orginalName;

	            Path savePath = Paths.get(saveName);

	            uploadFile.transferTo(savePath); // 실제 이미지 저장
	            return uuid + "_" + orginalName;
	        } catch (IOException e) {
	            e.printStackTrace();
	        }
	        return null;
	}
}
