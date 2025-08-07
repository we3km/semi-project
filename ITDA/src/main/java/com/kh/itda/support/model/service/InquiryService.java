package com.kh.itda.support.model.service;

import java.util.List;

import org.springframework.web.multipart.MultipartFile;

import com.kh.itda.common.model.vo.File;
import com.kh.itda.support.model.vo.Inquiry;

public interface InquiryService {
    int insertInquiry(Inquiry inquiry);
    Inquiry selectInquiryById(int csNum);
    int updateInquiryReply(Inquiry inquiry);
    int updateInquiryStatus(Inquiry inquiry);
    List<Inquiry> selectAllInquiries();
	int insertFile(File file);
	int saveFile(MultipartFile file, int csNum, int string);
	List<Inquiry> selectInquiriesByUser(int userNum);
	List<File> selectFilesByRefAndCategory(int refNo, int categoryId);
	String selectCategoryPathByCategoryId(int categoryId);
}