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
            List<File> fileList = inquiryDao.selectFilesByRef(csNum);
            inquiry.setFileList(fileList);
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

    // 카테고리ID → 카테고리명 변환 메서드
    private String mapCategoryIdToName(int categoryId) {
        switch(categoryId) {
            case 1: return "member_info";
            case 2: return "trade";
            case 3: return "report";
            case 4: return "suggestion";
            case 5: return "etc";
            default: return "etc";
        }
    }

    /**
     * 첨부파일 저장 처리
     * - 카테고리명으로 폴더 생성 및 저장
     * - 저장된 파일명을 File VO에 세팅 후 DB에 insert
     */
    @Override
    public int saveFile(MultipartFile file, int csNum, int categoryId) {
        if (file == null || file.isEmpty()) {
            return 0;
        }

        String categoryName = mapCategoryIdToName(categoryId);

        String savedFileName = Utils.saveFileToCategoryFolder(file, application, categoryName);

        if (savedFileName == null) {
            return 0;
        }

        File savedFile = new File();
        savedFile.setFileName(savedFileName);
        savedFile.setRefNo(csNum);
        savedFile.setCategoryId(7); // 문의하기 고정 카테고리 번호 (필요시 조정)

        return insertFile(savedFile);
    }

    @Override
    public Integer selectPathNumByPath(String path) {
        Integer pathNum = inquiryDao.selectPathNumByPath(path);
        if (pathNum == null) {
            inquiryDao.insertPath(path);
            pathNum = inquiryDao.selectPathNumByPath(path);
        }
        return pathNum;
    }

    @Override
    public int insertPath(String path) {
        return inquiryDao.insertPath(path);
    }
    
    @Override
    public List<Inquiry> selectInquiriesByUserNum(int userNum) {
        return inquiryDao.selectInquiriesByUserNum(userNum);
    }
}