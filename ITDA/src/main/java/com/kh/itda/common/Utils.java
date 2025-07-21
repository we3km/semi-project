package com.kh.itda.common;

import java.io.File;
import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.Date;

import javax.servlet.ServletContext;

import org.springframework.web.multipart.MultipartFile;

public class Utils {

    /**
     * 오픈채팅 이미지 저장
     * @param upfile 업로드된 MultipartFile
     * @param application ServletContext (getRealPath용)
     * @return 저장된 웹 경로 (예: /resources/images/openchatimg/2024072112123456789.jpg)
     */
	public static String saveOpenChatFile(MultipartFile upfile, ServletContext application, String chatRoomID) {
	    // 프로젝트 루트 경로 기준으로 webapp 안에 저장
		String webPath = "/resources/images/openchat/"+chatRoomID+"/";
		
		String serverFolderPath = application.getRealPath(webPath);
		
		File dir = new File(serverFolderPath);
		if(!dir.exists()) {
			dir.mkdir();
		}
		// 랜덤한 파일명 생성
				String originName = upfile.getOriginalFilename();//파일의 원본명
				String currentTime = new SimpleDateFormat("yyyyMMddHHmmss").format(new Date());
				int random = (int)(Math.random()*90000 + 10000); //5자리 fosejsrkqt
				String ext = originName.substring(originName.lastIndexOf("."));
				String changeName = currentTime + random+ext;
				// 서버에 파일을 업로드
				
				try {
					upfile.transferTo(new File(serverFolderPath+changeName));
				} catch (IllegalStateException e) {
					e.printStackTrace();
				} catch (IOException e) {
					e.printStackTrace();
				}
				// 파일명 반환
				return webPath+changeName;

	}
    /**
     * XSS 공격 방지 처리
     */
    public static String XSSHandling(String content) {
        if (content == null) return null;

        content = content.replaceAll("&", "&amp;");
        content = content.replaceAll("<", "&lt;");
        content = content.replaceAll(">", "&gt;");
        content = content.replaceAll("\"", "&quot;");
        return content;
    }

    /**
     * 개행문자 → <br> 처리 (null-safe)
     */
    public static String newLineHandling(String content) {
        if (content == null) return "";
        return content.replaceAll("(\r\n|\r|\n|\n\r)", "<br>");
    }

    /**
     * <br> → 개행문자 처리 (textarea용) (null-safe)
     */
    public static String newLineClear(String content) {
        if (content == null) return "";
        return content.replaceAll("<br>", "\n");
    }
}
