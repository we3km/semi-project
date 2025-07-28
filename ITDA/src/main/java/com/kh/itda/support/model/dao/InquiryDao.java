package com.kh.itda.support.model.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.common.model.vo.Category;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.support.model.vo.Inquiry;

@Repository
public class InquiryDao {

    @Autowired
    private SqlSession session;

    // 1. 문의글 삽입
    public int insertInquiry(Inquiry inquiry) {
        return session.insert("inquiry.insertInquiry", inquiry);
    }

    // 2. 문의글 상세 조회
    public Inquiry selectInquiryById(int csNum) {
        return session.selectOne("inquiry.selectInquiryById", csNum);
    }

    // 3. 문의글 답변 등록
    public int updateInquiryReply(Inquiry inquiry) {
        return session.update("inquiry.updateInquiryReply", inquiry);
    }

    // 4. 문의글 상태 변경
    public int updateInquiryStatus(Inquiry inquiry) {
        return session.update("inquiry.updateInquiryStatus", inquiry);
    }

    // 5. 문의글 전체 목록 조회
    public List<Inquiry> selectAllInquiries() {
        return session.selectList("inquiry.selectAllInquiries");
    }

    // 6. 첨부파일 목록 조회 (refNo: 문의글 번호)
    public List<File> selectFilesByRef(int refNo) {
        return session.selectList("inquiry.selectFilesByRef", refNo);
    }

    // 첨부파일 저장
    public int insertFile(File file) {
        return session.insert("inquiry.insertFile", file);
    }

    // 경로로 PATH_NUM 조회
    public Integer selectPathNumByPath(String path) {
        return session.selectOne("inquiry.selectPathNumByPath", path);
    }

    // 경로가 없으면 PATH 테이블에 새 경로 삽입
    public int insertPath(String path) {
        return session.insert("inquiry.insertPath", path);
    }

    public List<Inquiry> selectInquiriesByUserNum(int userNum) {
        return session.selectList("inquiry.selectInquiriesByUser", userNum);
    }

    
}