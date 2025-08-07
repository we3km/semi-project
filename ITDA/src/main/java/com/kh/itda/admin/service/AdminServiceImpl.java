package com.kh.itda.admin.service;

import java.util.Date;
import java.util.List;

import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.security.model.dao.SecurityDao;
import com.kh.itda.support.model.dao.ReportDao;
import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.BanUser;
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
	public boolean updateReportStatus(int reportNum, String status) {
		Report report = new Report();
		report.setReportNum(reportNum);
		report.setStatus(status);
		int result = reportDao.updateReportStatus(report);
		return result > 0;
	}

	@Override
	public void banUser(BanUser banUser) {
		securityDao.banUser(banUser);
	}

	@Override
	public void updateBanUser(BanUser banUser) {
		securityDao.updateBanUser(banUser);
	}

	@Transactional
	@Override
	public void updateReportProcessedAndBanUser(int reportNum, BanUser banUser) {
		reportDao.updateReportProcessedAt(reportNum);
		securityDao.updateBanUser(banUser);
	}

}