package com.kh.itda.support.model.dao;

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
}