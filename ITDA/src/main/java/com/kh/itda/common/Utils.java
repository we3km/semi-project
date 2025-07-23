package com.kh.itda.common;

import java.io.File;
import java.io.IOException;
import java.time.LocalDateTime;
import java.time.format.DateTimeFormatter;
import java.util.Arrays;

import javax.servlet.ServletContext;

import org.springframework.web.multipart.MultipartFile;

public class Utils {

    /* =========================================================
     * 파일 구분 코드/경로 매핑
     * ========================================================= */
    public enum FileAssortment {
        RENTAL(1,     "/resources/images/rental/"),
        EXCHANGE(2,   "/resources/images/exchange/"),
        AUCTION(3,    "/resources/images/auction/"),
        SHARING(4,    "/resources/images/sharing/"),
        COMMUNITY(5,  "/resources/images/community/"),
        OPEN_CHAT(6,  "/resources/images/chat/");

        private final int code;
        private final String webPath;

        FileAssortment(int code, String webPath) {
            this.code = code;
            this.webPath = webPath;
        }
        public int code() { return code; }
        public String webPath() { return webPath; }

        public static FileAssortment of(int code) {
            return Arrays.stream(values())
                         .filter(f -> f.code == code)
                         .findFirst()
                         .orElseThrow(() -> new IllegalArgumentException("Unknown FileAssortment code: " + code));
        }
    }

    /* =========================================================
     * 파일 저장 유틸
     * ========================================================= */

    /**
     * 공통 파일 저장
     * @param file 업로드 파일
     * @param app  ServletContext (realPath 얻기용)
     * @param type FileAssortment (폴더/코드정보)
     * @return 저장된 파일명(변경명) — DB FILE_NAME에 저장
     */
    public static String saveFile(MultipartFile file, ServletContext app, FileAssortment type) {
        if (file == null || file.isEmpty()) return null;

        // 웹경로 보정
        String webDir = type.webPath();
        if (!webDir.endsWith("/")) webDir += "/";

        // 실제 저장 경로
        String realDir = app.getRealPath(webDir);
        File dir = new File(realDir);
        if (!dir.exists()) dir.mkdirs();

        // 변경 파일명
        String changeName = buildChangeName(getExtension(file.getOriginalFilename()));

        try {
            file.transferTo(new File(dir, changeName));
        } catch (IllegalStateException | IOException e) {
            throw new RuntimeException("파일 저장 실패", e);
        }

        return changeName;
    }

    /** 오픈채팅 전용 헬퍼 */
    public static String saveOpenChatFile(MultipartFile file, ServletContext app) {
        return saveFile(file, app, FileAssortment.OPEN_CHAT);
    }

    /* =========================================================
     * 문자열/XSS/개행 처리
     * ========================================================= */
    public static String XSSHandling(String content) {
        if (content == null) return null;
        return content.replace("&", "&amp;")
                      .replace("<", "&lt;")
                      .replace(">", "&gt;")
                      .replace("\"", "&quot;");
    }

    public static String newLineHandling(String content) {
        if (content == null) return "";
        return content.replaceAll("(\r\n|\r|\n|\n\r)", "<br>");
    }

    public static String newLineClear(String content) {
        if (content == null) return "";
        return content.replace("<br>", "\n");
    }

    /* =========================================================
     * 내부 헬퍼
     * ========================================================= */
    private static String getExtension(String originName) {
        if (originName == null) return "";
        int idx = originName.lastIndexOf('.');
        return (idx > -1) ? originName.substring(idx) : "";
    }

    private static String buildChangeName(String ext) {
        String ts = LocalDateTime.now().format(DateTimeFormatter.ofPattern("yyyyMMddHHmmssSSS"));
        int rand = (int) (Math.random() * 90000 + 10000);
        return ts + "_" + rand + ext;
    }
}
