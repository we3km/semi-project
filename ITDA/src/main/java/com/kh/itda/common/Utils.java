package com.kh.itda.common;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletContext;

import org.springframework.web.multipart.MultipartFile;

public class Utils {

    // 폴더 없으면 생성 (categoryName 폴더명)
    public static boolean createFolderIfNotExists(ServletContext application, String categoryName) {
        String webPath = "/resources/images/" + categoryName + "/";
        String serverFolderPath = application.getRealPath(webPath);

        if (serverFolderPath == null) {
            throw new IllegalStateException("서버 절대 경로를 찾을 수 없습니다.");
        }

        File folder = new File(serverFolderPath);
        if (!folder.exists()) {
            return folder.mkdirs();
        }

        return true;
    }

    public static String saveFileToCategoryFolder(MultipartFile upfile, ServletContext application, String categoryName) {
        if (upfile == null || upfile.isEmpty()) {
            return null;
        }

        // 폴더 생성
        if (!createFolderIfNotExists(application, categoryName)) {
            throw new IllegalStateException("파일 저장 폴더 생성 실패");
        }

        String webPath = "/resources/images/" + categoryName + "/";
        String serverFolderPath = application.getRealPath(webPath);

        if (serverFolderPath == null) {
            throw new IllegalStateException("서버 절대 경로를 찾을 수 없습니다.");
        }

        String originName = upfile.getOriginalFilename();
        if (originName == null) originName = "unknown";

        String ext = "";
        int dotIndex = originName.lastIndexOf(".");
        if (dotIndex != -1) {
            ext = originName.substring(dotIndex);
        }

        String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
        int randomNum = (int)(Math.random() * 90000 + 10000);
        String changedName = currentTime + randomNum + ext;

        java.io.File dest = new java.io.File(serverFolderPath, changedName);

        try {
            upfile.transferTo(dest);
        } catch (IOException e) {
            e.printStackTrace();
            return null;
        }

        return changedName;
    }
}