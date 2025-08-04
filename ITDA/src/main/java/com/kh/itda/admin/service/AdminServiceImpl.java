package com.kh.itda.admin.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.itda.security.model.dao.SecurityDao;
import com.kh.itda.support.model.dao.ReportDao;
import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class AdminServiceImpl implements AdminService {

	private final SecurityDao securityDao;
	private final ReportDao reportDao;

	@Override
	public List<User> searchUsers(String keyword) {
	    return securityDao.searchUsers(keyword);
	}

	@Override
	public List<Report> getAllReports() {
		return securityDao.getAllReports();
	}

	@Override
	public User findUserById(String userId) {
		return securityDao.findUserById(userId);
	}

	@Override
	public Report getReportById(int reportNum) {
		return reportDao.selectReportById(reportNum);
	}

	@Override
	public void updateReportStatus(int reportNum, String status) {
		Report report = new Report();
		report.setReportNum(reportNum);
		report.setStatus(status);
		reportDao.updateReportStatus(report);
	}
}