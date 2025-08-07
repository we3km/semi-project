package com.kh.itda.support.model.service;

import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.multipart.MultipartFile;

import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.support.model.dao.InquiryDao;
import com.kh.itda.support.model.vo.Inquiry;

@Service
public class InquiryServiceImpl implements InquiryService {

    @Autowired
    private InquiryDao inquiryDao;

    @Autowired
    private ServletContext application;

    @Override
    public int insertInquiry(Inquiry inquiry) {
        return inquiryDao.insertInquiry(inquiry);
    }

    @Override
    public Inquiry selectInquiryById(int csNum) {
    	Inquiry inquiry = inquiryDao.selectInquiryById(csNum);

    	if (inquiry != null) {
    		// categoryName → categoryId 매핑
    		int categoryId = 0; // 기본값: 기타
    		switch (inquiry.getCategoryName()) {
    			case "회원정보": categoryId = 1; break;
    			case "거래관련": categoryId = 2; break;
    			case "신고처리": categoryId = 3; break;
    			case "건의사항": categoryId = 4; break;
    			case "기타":
    			default: categoryId = 5; break;
    		}

    		// categoryId 기반 파일 조회
    		List<File> fileList = inquiryDao.selectFilesByRefAndCategory(csNum, categoryId);
    		inquiry.setFileList(fileList);

    		// 닉네임 세팅
    		String nickName = inquiryDao.selectNickNameByUserNum(inquiry.getUserNum());
    		inquiry.setNickName(nickName);
    	}

    	return inquiry;
    }

    @Override
    public List<Inquiry> selectAllInquiries() {
        return inquiryDao.selectAllInquiries();
    }

    @Override
    public int updateInquiryReply(Inquiry inquiry) {
        return inquiryDao.updateInquiryReply(inquiry);
    }

    @Override
    public int updateInquiryStatus(Inquiry inquiry) {
        return inquiryDao.updateInquiryStatus(inquiry);
    }

    @Override
    public int insertFile(File file) {
        return inquiryDao.insertFile(file);
    }

    /**
     * 첨부파일 저장 처리 (categoryId → DB에서 경로 조회 후 저장)
     */
    public int saveFile(MultipartFile file, int csNum, int categoryId) {
        if (file == null || file.isEmpty()) {
            return 0;
        }

        // DB에서 categoryId에 대응하는 전체 경로 가져오기 (예: "resources/images/support")
        String fullCategoryPath = inquiryDao.selectCategoryPathById(categoryId);

        String categoryName = fullCategoryPath;
        if (categoryName != null && categoryName.startsWith("resources/images/")) {
            categoryName = categoryName.substring("resources/images/".length());
        }

        if (categoryName == null || categoryName.isEmpty()) {
            categoryName = "etc";
        }

        String savedFileName = Utils.saveFileToCategoryFolder(file, application, categoryName);
        if (savedFileName == null) {
            return 0;
        }

        File savedFile = new File();
        savedFile.setFileName(savedFileName);
        savedFile.setRefNo(csNum);
        savedFile.setCategoryId(categoryId);

        return insertFile(savedFile);
    }

    @Override
    public List<Inquiry> selectInquiriesByUser(int userNum) {
        return inquiryDao.selectInquiriesByUser(userNum);
    }
    
    @Override
    public List<File> selectFilesByRefAndCategory(int refNo, int categoryId) {
        return inquiryDao.selectFilesByRefAndCategory(refNo, categoryId);
    }
	
    @Override
    public String selectCategoryPathByCategoryId(int categoryId) {
        return inquiryDao.selectCategoryPathById(categoryId);  // 기존 메서드 재사용
    }

    
}
