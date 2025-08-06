package com.kh.itda.support.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.support.model.dao.ReportDao;
import com.kh.itda.support.model.vo.Report;

@Service
public class ReportServiceImpl implements ReportService {

    @Autowired
    private ReportDao reportDao;

    @Override
    public int insertReport(Report report) {
        return reportDao.insertReport(report);
    }
}
