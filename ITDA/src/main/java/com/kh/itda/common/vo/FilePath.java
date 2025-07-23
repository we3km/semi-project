package com.kh.itda.common.vo;

public class FilePath {
    private String fileName;   // 실제 저장된 파일명 (변경된 이름)
    private String filePath;   // 저장된 경로 (예: /resources/images/cs_service/)
    
    public FilePath() {}

    public FilePath(String fileName, String filePath) {
        this.fileName = fileName;
        this.filePath = filePath;
    }

    // getter, setter
    public String getFileName() {
        return fileName;
    }
    public void setFileName(String fileName) {
        this.fileName = fileName;
    }
    public String getFilePath() {
        return filePath;
    }
    public void setFilePath(String filePath) {
        this.filePath = filePath;
    }
}