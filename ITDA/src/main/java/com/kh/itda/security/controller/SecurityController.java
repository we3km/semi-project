package com.kh.itda.security.controller;

import java.util.HashMap;
import java.util.Map;
import java.util.Optional;
import javax.servlet.http.HttpSession;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.Authentication;
import org.springframework.security.core.context.SecurityContextHolder;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;
import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.user.model.service.EmailService;
import com.kh.itda.user.model.service.UserService;
import lombok.extern.slf4j.Slf4j;

//회원정보 수정, 로그인/로그아웃(페이지 이동), 이메일(인증번호 등)
@Controller
@Slf4j
public class SecurityController {
	private final BCryptPasswordEncoder passwordEncoder;
	private final UserService uService;
	private final EmailService emailService;
	private final HttpSession session;

	public SecurityController(BCryptPasswordEncoder passwordEncoder, UserService uService, HttpSession session,
			EmailService emailService) {
		super();
		this.passwordEncoder = passwordEncoder;
		this.uService = uService;
		this.emailService = emailService;
		this.session = session;
	}

	// 로그인
	@GetMapping("/user/login")
	public String login() {
		return "user/login";
	}

	// 아이디 찾기
	@GetMapping("/user/findId")
	public String findId() {
		return "user/findId";
	}

	// 비밀번호 찾기
	@GetMapping("/user/findPwd")
	public String findPwd() {
		return "user/findPwd";
	}

	// 회원가입용 인증번호 전송
    @PostMapping("/user/sendVerification")
    @ResponseBody
    public ResponseEntity<?> sendVerification(@RequestParam String email) {
        String code = emailService.generateVerificationCode();
        boolean mailSent = emailService.sendEmail(email, "인증번호 발송", "인증번호는 " + code + "입니다.");
        
        if(mailSent) {
        	session.setAttribute("authCode", code);
        	return ResponseEntity.ok(Map.of("success", true, "message", "인증번호가 발송되었습니다."));        	
        } else {
        	return ResponseEntity.status(HttpStatus.INTERNAL_SERVER_ERROR)
                    .body(Map.of("success", false, "message", "이메일 발송 실패"));
        }
    }

    // 회원가입용 인증번호 확인
    @PostMapping("/user/checkVerification")
    @ResponseBody
    public ResponseEntity<?> checkVerification(@RequestParam String code) {
        String stored = (String) session.getAttribute("authCode");
        if (stored != null && stored.equals(code)) {
            session.setAttribute("verified", true);
            return ResponseEntity.ok(Map.of("result", "인증 성공"));
        } else {
            return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(Map.of("result", "fail", "message", "인증 실패, 일치하지 않습니다."));
        }
    }
    
    //아이디 찾기
    @PostMapping("/user/findId")
    @ResponseBody
    public Map<String, Object> findIdProcess(
    			@RequestParam("nickName") String nickName,
                @RequestParam("email") String email,
                HttpSession session) {
    	Map<String, Object> response = new HashMap<>();
    	
        Boolean verified = (Boolean) session.getAttribute("findIdVerified");
        
        // 이메일 인증 여부 확인
        if (verified == null || !verified) {
        	response.put("success", false);
        	response.put("message", "이메일 인증을 먼저 완료해주세요.");
            return response;
        }

        Optional<String> userId = uService.findIdByNameAndEmail(nickName, email);
        if (userId.isPresent()) {
        	boolean mailSent = emailService.sendEmail(email, "아이디 찾기", "회원님의 아이디는: " + userId.get());
        	if(mailSent) {
        		response.put("success", true);
                response.put("message", "이메일로 아이디를 전송했습니다.");
                session.removeAttribute("findIdVerified");
                session.removeAttribute("findIdAuthCode");
        	} else {
        		response.put("success", false);
                response.put("message", "이메일 전송에 실패했습니다.");
        	}
        } else {
        	response.put("success", false);
            response.put("message", "일치하는 회원이 없습니다.");
        }
        return response;
    }
    
    // 아이디 찾기용 인증번호 전송
    @PostMapping("/user/findId/sendCode")
    @ResponseBody
    public Map<String, Object> sendFindIdCode(@RequestParam String nickName,
                                              @RequestParam String email,
                                              HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // 닉네임과 이메일이 일치하는지 확인
        Optional<String> userId = uService.findIdByNameAndEmail(nickName, email);
        if (userId.isEmpty()) {
            response.put("success", false);
            response.put("message", "일치하는 회원 정보가 없습니다.");
            return response;
        }

        // 인증번호 생성 및 전송
        String code = emailService.generateVerificationCode();
        boolean mailSent = emailService.sendEmail(email, "아이디 찾기 인증번호", "인증번호는 " + code + "입니다.");

        if (mailSent) {
            session.setAttribute("findIdAuthCode", code);
            session.setAttribute("findIdVerified", false);  // 초기 상태
            response.put("success", true);
            response.put("message", "인증번호를 발송했습니다.");
        } else {
            response.put("success", false);
            response.put("message", "이메일 발송 실패");
        }
        return response;
    }
    
    // 아이디 찾기용 인증번호 확인
    @PostMapping("/user/findId/verifyCode")
    @ResponseBody
    public Map<String, Object> verifyFindIdCode(@RequestParam String code,
                                                HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        String storedCode = (String) session.getAttribute("findIdAuthCode");

        if (storedCode != null && storedCode.equals(code)) {
            session.setAttribute("findIdVerified", true);
            response.put("success", true);
            response.put("message", "인증이 완료되었습니다.");
        } else {
            response.put("success", false);
            response.put("message", "인증번호가 일치하지 않습니다.");
        }

        return response;
    }

    //비밀번호 찾기
    @PostMapping("/user/findPwd")
    @ResponseBody
    public Map<String, Object> findPwdProcess(
    							@RequestParam("userId") String userId,
                                @RequestParam("email") String email,
                                HttpSession session) {
    	Map<String, Object> response = new HashMap<>();
    	
        Boolean verified = (Boolean) session.getAttribute("findPwdVerified");
        
        // 이메일 인증 여부 확인
        if (verified == null || !verified) {
        	response.put("success", false);
        	response.put("message", "이메일 인증을 먼저 완료해주세요.");
            return response;
        }

        Optional<String> userPwd = uService.findPwdByIdAndEmail(userId, email);
        if (userPwd.isPresent()) {
        	// 임시 비밀번호 생성
        	String tempPwd = generateTempPassword();
        	
        	// 비밀번호 암호화 및 DB저장
        	if(tempPwd != null && !tempPwd.isEmpty()) {
	        	String encodedPwd = passwordEncoder.encode(tempPwd);
	        	try { // 에러 확인용
	        	uService.updatePassword(userId, encodedPwd);
	        	} catch (Exception e) {
	        		e.printStackTrace();
	        	}
        	}
        	// 임시 비밀번호 전송
        	emailService.sendEmail(email, "임시 비밀번호 발급", "회원님의 임시 비밀번호는: " + tempPwd);
            response.put("success", true);
            response.put("message", "이메일로 임시 비밀번호를 전송했습니다.");
        } else {
        	response.put("success", false);
            response.put("message", "일치하는 회원이 없습니다.");
        }
        
        // 세션 제거
        session.removeAttribute("findPwdVerified");
        session.removeAttribute("findPwdAuthCode");
        
        return response;
    }
    
    // 비밀번호 찾기용 인증번호 전송
    @PostMapping("/user/findPwd/sendCode")
    @ResponseBody
    public Map<String, Object> sendFindPwdCode(@RequestParam String userId,
                                              @RequestParam String email,
                                              HttpSession session) {
        Map<String, Object> response = new HashMap<>();

        // 아이디와 이메일이 일치하는지 확인
        Optional<String> userPwd = uService.findPwdByIdAndEmail(userId, email);
        if (userPwd.isEmpty()) {
            response.put("success", false);
            response.put("message", "일치하는 회원 정보가 없습니다.");
            return response;
        }

        // 인증번호 생성 및 전송
        String code = emailService.generateVerificationCode();
        boolean mailSent = emailService.sendEmail(email, "비밀번호 찾기 인증번호", "인증번호는 " + code + "입니다.");

        if (mailSent) {
            session.setAttribute("findPwdAuthCode", code);
            session.setAttribute("findPwdVerified", false);  // 초기 상태
            response.put("success", true);
            response.put("message", "인증번호를 발송했습니다.");
        } else {
            response.put("success", false);
            response.put("message", "이메일 발송 실패");
        }
        return response;
    }
    
    // 비밀번호 찾기용 인증번호 확인
    @PostMapping("/user/findPwd/verifyCode")
    @ResponseBody
    public Map<String, Object> verifyFindPwdCode(@RequestParam String code,
                                                HttpSession session) {
        Map<String, Object> response = new HashMap<>();
        String storedCode = (String) session.getAttribute("findPwdAuthCode");

        if (storedCode != null && storedCode.equals(code)) {
            session.setAttribute("findPwdVerified", true);
            response.put("success", true);
            response.put("message", "인증이 완료되었습니다.");
        } else {
            response.put("success", false);
            response.put("message", "인증번호가 일치하지 않습니다.");
        }

        return response;
    }
	
    private String generateTempPassword() {
    	char[] charSet = new char[] {
    		'0','1','2','3','4','5','6','7','8','9','a','b','c','d','e','f','g','h',
    		'i','j','k','l','m','n','o','p','q','r','s','t','u','v','w','x','y','z'};

        String tempPwd = "";

        // 문자 배열 길이의 값을 랜덤으로 10개를 뽑아 구문을 작성함
        int index = 0;
        for (int i = 0; i < 10; i++) {
            index = (int) (charSet.length * Math.random());
            tempPwd += charSet[index];
        }
        return tempPwd;
	}

//	//회원정보 업데이트
//	@PostMapping("/user/update")
//	public String update(
//			@Validated @ModelAttribute UserExt loginUser,
//			BindingResult bindResult,
//			Authentication auth,
//			RedirectAttributes ra
//			) {
//		if(bindResult.hasErrors()) {
//			return "redirect:/user/mypage";
//		}
//		// 비밀번호 변경 시 암호화
//		if (loginUser.getUserPwd() != null && !loginUser.getUserPwd().isBlank()) {
//            loginUser.setUserPwd(passwordEncoder.encode(loginUser.getUserPwd()));
//        }
//		
//		// db의 user객체를 수정
//		int result = uService.updateUser(loginUser);
//		
//		// 변경된 회원정보를 DB에서 얻어온 후 새로운 인증정보 생성하여 스레드로컬에 저장
//		// 새로운 Authentication 객체생성
//		Authentication newAuth = new UsernamePasswordAuthenticationToken
//				(
//				loginUser, auth.getCredentials(), auth.getAuthorities()
//		);
//		SecurityContextHolder.getContext().setAuthentication(newAuth);
//		ra.addFlashAttribute("alertMsg", "내 정보 수정 성공");
//		
//		return "redirect:/user/mypage";
//	}
	//회원정보 업데이트
//	@PostMapping("/user/update")
//	public String update(
//			@Validated @ModelAttribute UserExt loginUser,
//			BindingResult bindResult,
//			Authentication auth,
//			RedirectAttributes ra
//			) {
//		if(bindResult.hasErrors()) {
//			return "redirect:/user/myPage";
//		}
//		// 비밀번호 변경 시 암호화
//		if (loginUser.getUserPwd() != null && !loginUser.getUserPwd().isBlank()) {
//            loginUser.setUserPwd(passwordEncoder.encode(loginUser.getUserPwd()));
//        }
//		
//		// db의 user객체를 수정
//		//int result = uService.updateUser(loginUser);
//		
//		// 변경된 회원정보를 DB에서 얻어온 후 새로운 인증정보 생성하여 스레드로컬에 저장
//		// 새로운 Authentication 객체생성
//		Authentication newAuth = new UsernamePasswordAuthenticationToken
//				(
//				loginUser, auth.getCredentials(), auth.getAuthorities()
//		);
//		SecurityContextHolder.getContext().setAuthentication(newAuth);
//		ra.addFlashAttribute("alertMsg", "내 정보 수정 성공");
//		
//		return "redirect:/user/myPage";
//	}

}