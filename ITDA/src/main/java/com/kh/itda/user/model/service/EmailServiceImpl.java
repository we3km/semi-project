package com.kh.itda.user.model.service;

import java.util.Random;

/*import javax.mail.MessagingException;
import javax.mail.internet.MimeMessage;

import org.springframework.mail.javamail.JavaMailSender;
import org.springframework.mail.javamail.MimeMessageHelper;*/
import org.springframework.stereotype.Service;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@RequiredArgsConstructor
@Slf4j
public class EmailServiceImpl implements EmailService {

	/*
	 * private final JavaMailSender mailSender;
	 * 
	 * @Override public String generateVerificationCode() { Random random = new
	 * Random(); int code = 100000 + random.nextInt(900000); // 6자리 숫자 return
	 * String.valueOf(code); }
	 * 
	 * @Override public boolean sendEmail(String email, String subject, String
	 * content) { try { MimeMessage message = mailSender.createMimeMessage();
	 * MimeMessageHelper helper = new MimeMessageHelper(message, false, "UTF-8");
	 * 
	 * helper.setTo(email); helper.setSubject(subject); helper.setText(content,
	 * false); helper.setFrom("ta0313v@gmail.com"); // 발신자 주소(안태형) 설정
	 * 
	 * mailSender.send(message); log.info("이메일 전송 완료: {}", email); return true; }
	 * catch (MessagingException e) { log.error("이메일 전송 실패: {}", e.getMessage());
	 * return false; } }
	 */
}
