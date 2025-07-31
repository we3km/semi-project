package com.kh.itda.openchat.model.service;

import java.io.File;
import java.io.IOException;
import java.nio.file.Files;
import java.nio.file.Path;
import java.nio.file.Paths;

import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

@Service
public class FileService {

    // 실제 저장할 폴더 경로 (프로젝트 기준, webapp/resources/images/openchatimg)
    private final String UPLOAD_DIR = "src/main/webapp/resources/images/openchatimg";

    public String saveFile(MultipartFile file) throws IOException {
        if (file == null || file.isEmpty()) {
            return null; // 저장할 파일이 없으면 null 리턴
        }

        // 저장 폴더가 없으면 생성
        File dir = new File(UPLOAD_DIR);
        if (!dir.exists()) {
            dir.mkdirs();
        }

        // 원본 파일명에서 확장자 추출
        String originalFileName = file.getOriginalFilename();
        String ext = "";

        if (originalFileName != null && originalFileName.lastIndexOf(".") != -1) {
            ext = originalFileName.substring(originalFileName.lastIndexOf("."));
        }

        // 저장할 파일명(중복 방지 UUID + 확장자)
        String savedFileName = System.currentTimeMillis() + ext;

        // 저장 경로 만들기
        Path path = Paths.get(UPLOAD_DIR, savedFileName);

        // 실제 파일 저장
        Files.write(path, file.getBytes());

        return savedFileName;
    }
}
