package com.kh.itda.user.model.service;

public interface EmailService {

	String generateVerificationCode();
	
	boolean sendEmail(String email, String string, String string2);


}
