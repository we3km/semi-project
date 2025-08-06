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

	/*
	 *  XSS(크로스 사이트 스크립트)공격을 방지하기 위한 메서드
	 *   - 스크립트 삽입 공격
	 *   - 사용자가 <script>태그를 게시글에 작성하여 클라이언트가 게시글 클릭시
	 *     script에 지정한 코드가 실행되도록 유도하는 방식
	 *   - 위 내용을 그대로 db에 저장 후 브라우저에 렌더링하면 문제가 발생할 수 잇
	 *     으므로 태그가 아닌 기본 문자열로 인식할 수 있게끔 html내부 entitiy로 변환
	 *     처리를 수행한다.
	 *  */	
	public static String XSSHandling(String content) {
		if(content != null) {
			content = content.replaceAll("&", "&amp;");
			content = content.replaceAll("<", "&lt;");
			content = content.replaceAll(">", "&gt;");
			content = content.replaceAll("\"", "&quot;");
		}
		return content;
	}
	
	// 개행문자 처리
	// textarea -> \n , p -> <br>
	public static String newLineHandling(String content) {
		return content.replaceAll("(\r\n|\r|\n|\n\r)", "<br>");
	}
	
	// 개행해제 처리
	public static String newLineClear(String content) {
		return content.replaceAll("<br>","\n");
	}
	
	//파일삭제
	public static void deleteFile(String changeName, ServletContext application, String folderName) {
		if (changeName == null || changeName.isEmpty()) {
			return; // 파일명이 없으면 아무것도 하지 않음
		}

		// 파일을 저장했던 실제 경로를 동일하게 구성합니다.
		String realPath = application.getRealPath("/resources/images/" + folderName);

		// 실제 경로와 파일명을 합쳐 전체 경로를 만듭니다.
		File fileToDelete = new File(realPath, changeName);

		// 파일이 실제로 존재하는지 확인 후 삭제합니다.
		if (fileToDelete.exists()) {
			if (fileToDelete.delete()) {
				System.out.println("파일 삭제 성공: " + fileToDelete.getPath());
			} else {
				System.out.println("파일 삭제 실패: " + fileToDelete.getPath());
			}
		} else {
			System.out.println("삭제할 파일이 존재하지 않음: " + fileToDelete.getPath());
		}
	}
	
	
	
}

