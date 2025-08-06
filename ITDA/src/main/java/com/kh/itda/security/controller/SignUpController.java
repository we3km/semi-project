package com.kh.itda.security.controller;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
import java.util.HashMap;
import java.util.Map;
import java.util.Random;

import javax.servlet.http.HttpSession;

import org.springframework.http.ResponseEntity;
import org.springframework.security.crypto.password.PasswordEncoder;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.validation.BindingResult;
import org.springframework.validation.annotation.Validated;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.config.FileConfig;
import com.kh.itda.user.model.service.EmailService;
import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;
import com.kh.itda.validator.UserValidator;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/user/join")
@RequiredArgsConstructor
@Slf4j
public class SignUpController { //회원가입
    private final UserService uService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;
    private static final String DEFAULT_IMAGE_URL = "/resources/profile/default.png";

    // 1단계: 이용약관
    @GetMapping("/terms")
    public String showTermsPage() {
        return "user/join/terms";
    }

    @PostMapping("/terms")
    public String acceptTerms(
    		@RequestParam(value = "agreeTerms", required = false) String terms1,
            @RequestParam(value = "agreePrivacy", required = false) String terms2,
            @RequestParam(value = "agreePolicy", required = false) String terms3,
            HttpSession session) {
        if (terms1 != null && terms2 != null && terms3 != null) {
            session.setAttribute("termsAccepted", true);
            return "redirect:/user/join/emailAuth";
        } else {
            return "redirect:/user/join/terms?error=notAgreed";
        }
    }

    // 2단계: 이메일 인증 페이지
    @GetMapping("/emailAuth")
    public String showEmailVerificationPage(HttpSession session) {
        if (session.getAttribute("termsAccepted") == null) {
            return "redirect:/user/join/terms";
        }
        return "user/join/emailAuth";
    }

    // 이메일로 인증번호 발송
    @PostMapping("/emailAuth/sendAuthCode")
    @ResponseBody
    public Map<String, Object> sendAuthCode(
    		@RequestParam("email") String email, 
    		HttpSession session) {
        String code = generateAuthCode();
        session.setAttribute("authCode", code);
        session.setAttribute("email", email);
        
        boolean result = emailService.sendEmail(email, "이메일 인증번호", "인증번호: " + code);
        
        Map<String, Object> response = new HashMap<>();
        if (result) {
            response.put("result", "success");
        } else {
            response.put("result", "fail");
        }
        return response;
    }
    
    @GetMapping("/emailAuth/checkEmail")
    @ResponseBody
    public Map<String, Object> checkEmailDuplication(@RequestParam("email") String email) {
        Map<String, Object> response = new HashMap<>();
        boolean exists = uService.emailExists(email);

        if (exists) {
            response.put("result", "exists");
        } else {
            response.put("result", "not_exists");
        }
        return response;
    }

    // 인증번호 확인
    @PostMapping("/emailAuth/verifyCode")
    @ResponseBody
    public Map<String, Object> verifyCode(
    		@RequestParam("code") String code,
    		@RequestParam("email") String email,
    		HttpSession session) {
    	Map<String, Object> response = new HashMap<>();
        String sessionCode = (String) session.getAttribute("authCode");
        String sessionEmail = (String) session.getAttribute("email");
        
        if (sessionCode != null && sessionCode.equals(code)
        		 && sessionEmail != null  && sessionEmail.equals(email)) {
            session.setAttribute("emailVerified", true);
            response.put("result", "success");
        } else {
        	response.put("result", "fail");
        }
        return response;
    }
    
    //이메일 인증 성공
    @PostMapping("/emailAuth/verifyEmailSuccess")
    @ResponseBody
    public ResponseEntity<?> setEmailVerified(@RequestBody Map<String, String> payload, HttpSession session) {
        String email = payload.get("email");
        if (email != null) {
            session.setAttribute("emailVerified", true);
            session.setAttribute("verifiedEmail", email);
            return ResponseEntity.ok().body(Collections.singletonMap("success", true));
        } else {
            return ResponseEntity.badRequest().body(Collections.singletonMap("success", false));
        }
    }

    // 회원정보 입력 페이지서 아이디 중복체크 담당
    @ResponseBody
    @GetMapping("/enroll/checkId")
    public String idCheck(String userId) {
    	if (!UserValidator.isValidId(userId)) {
            return "-1"; // 유효하지 않은 형식
        }
    	int result = uService.idCheck(userId);
    	return result+"";
    }
    
    // 회원정보 입력 페이지서 닉네임 중복체크 담당
    @ResponseBody
    @GetMapping("/enroll/checkNickname")
    public String checkNickname(String nickName) {
    	if(!UserValidator.isValidNickName(nickName)) {
    		return "-1";
    	}
    	int result = uService.checkNickname(nickName);
    	return result+"";
    }
    
    // 3단계: 회원정보 입력 페이지
    @GetMapping("/enroll")
    public String showSignUpForm(Model model, HttpSession session) {
        if (session.getAttribute("emailVerified") == null) {
            return "redirect:/user/join/emailAuth";
        }
        
        User user = new User();
        
        // 이메일 세션에서 가져와 사용자 객체에 주입
        String verifiedEmail = (String) session.getAttribute("verifiedEmail");
        if (verifiedEmail != null) {
        	user.setEmail(verifiedEmail);
        }
        
        model.addAttribute("user", user);
        return "user/join/enroll";
    }
    
    @PostMapping("/enroll")
    public String submitSignUpForm(
            @Validated @ModelAttribute("user") User user,
            BindingResult bindingResult,
            @RequestParam("userPwdCheck") String userPwdCheck,
            @RequestParam(value="profileImage", required=false) MultipartFile profileImage,
            HttpSession session,
            RedirectAttributes ra) {

    	//바인딩 체크
    	if (bindingResult.hasErrors()) {
    		if (session.getAttribute("verifiedEmail") != null) {
    	        user.setEmail((String) session.getAttribute("verifiedEmail"));
    	    }
    	    return "user/join/enroll";
    	}
    	
    	//디버그용 5줄 코드
    	System.out.println("multipart content type: " + profileImage.getContentType());
        System.out.println("file size: " + profileImage.getSize());
        System.out.println("termsAccepted: " + session.getAttribute("termsAccepted"));
        System.out.println("emailVerified: " + session.getAttribute("emailVerified"));
        System.out.println("verifiedEmail: " + session.getAttribute("verifiedEmail"));
        
        log.info("회원가입 처리 시작");
        
        // 비밀번호 일치 확인
        if (user.getUserPwd() == null || !userPwdCheck.equals(user.getUserPwd())) {
        	ra.addFlashAttribute("alertMsg", "비밀번호가 일치하지 않습니다.");
        	return "redirect:/user/join/enroll";
        }
        
        // 비밀번호 암호화
        String encryptedPassword = passwordEncoder.encode(user.getUserPwd());
        user.setUserPwd(encryptedPassword);

        log.info("프로필 이미지 업로드 시작");
        
        // 프로필 이미지 저장
        if (profileImage != null && !profileImage.isEmpty()) {
            try {
                // 실제 저장 경로
                String saveDirectory = session.getServletContext().getRealPath(FileConfig.PROFILE_IMAGE_WEB_PATH);
                File dir = new File(saveDirectory);
                if (!dir.exists()) {
                    dir.mkdirs(); // 디렉토리가 없으면 생성
                }

                String originalFilename = profileImage.getOriginalFilename();
                String newFilename = System.currentTimeMillis() + "_" + originalFilename;

                File destFile = new File(saveDirectory + File.separator + newFilename);
                profileImage.transferTo(destFile);

                // 이미지 파일 URL 설정 (브라우저에서 접근 가능 경로)
                user.setImageUrl(FileConfig.PROFILE_IMAGE_WEB_PATH + newFilename);

            } catch (IOException e) {
                e.printStackTrace();
                user.setImageUrl(DEFAULT_IMAGE_URL);
            }
        } else {
        	user.setImageUrl(DEFAULT_IMAGE_URL);
        }
        
        log.info("유저 DB 저장 시작");
        
        // DB 저장
        int userNum = 0;
        try {
        	uService.register(user);
        } catch (Exception e) {
            e.printStackTrace();
            ra.addFlashAttribute("alertMsg", "회원가입 중 오류가 발생했습니다.");
            return "user/join/enroll";
        }
        // 반환값이 0인지 아닌지 검사
        System.out.println("userNum: " + userNum);

        log.info("회원가입 처리 완료, 리다이렉트");
        
        ra.addFlashAttribute("alertMsg", "회원가입 완료!");
        return "redirect:/user/login";
    }
    
    //인증코드 생성
    private String generateAuthCode() {
        Random rand = new Random();
        StringBuilder code = new StringBuilder();
        for (int i = 0; i < 6; i++) {
            code.append(rand.nextInt(10));
        }
        return code.toString();
    }
}
