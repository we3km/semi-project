package com.kh.itda.support.model.dao;

import java.util.Date;
import java.util.List;
import java.util.Map;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.support.model.vo.Report;

@Repository
public class ReportDao {

    @Autowired
    private SqlSession session;

    public int insertReport(Report report) {
        return session.insert("report.insertReport", report);
    }

    public Report selectReportById(int reportNum) {
        return session.selectOne("report.selectReportById", reportNum);
    }

    public int updateReportStatus(Report report) {
        return session.update("report.updateReportStatus", report);
    }
    
    // 총 신고 갯수 조회
    public int getTotalReportCount() {
        return session.selectOne("report.getTotalReportCount");
    }

    // 페이징 처리된 신고 리스트 조회
    public List<Report> selectReportsByPage(int offset, int pageSize) {
        Map<String, Object> param = Map.of(
            "offset", offset,
            "pageSize", pageSize
        );
        return session.selectList("report.selectReportsByPage", param);
    }

	public void updateReportProcessedAtAndValidity(int reportNum, Date processedAt, Date validityPeriod) {
		session.update("report.updateReportProcessedAtAndValidity");
	}
}