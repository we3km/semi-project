package com.kh.itda.admin.service;

import java.util.Date;
import java.util.List;

import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.BanUser;
import com.kh.itda.user.model.vo.User;

public interface AdminService {
	List<User> searchUsers(String keyword);
	List<Report> getAllReports();
	Report getReportById(int reportNum);
	boolean updateReportStatus(int reportNum, String status);
	User findUserById(String userId);
	void banUser(BanUser banUser);
	void updateBanUser(BanUser banUser);
	void updateReportProcessedAtAndValidity(int reportNum, Date now, Date validityPeriod);
}
