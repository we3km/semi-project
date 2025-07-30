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
	Integer selectPathNumByPath(String path);
	int insertPath(String path);
	int saveFile(MultipartFile file, int csNum, int categoryId);
	List<Inquiry> selectInquiriesByUserNum(int userNum);
}