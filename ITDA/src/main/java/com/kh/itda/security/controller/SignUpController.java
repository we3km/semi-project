package com.kh.itda.security.controller;

import java.io.File;
import java.io.IOException;
import java.util.Collections;
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

import com.kh.itda.user.model.service.EmailService;
import com.kh.itda.user.model.service.UserService;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/user/signup")
@RequiredArgsConstructor
@Slf4j
public class SignUpController {

    private final UserService uService;
    private final EmailService emailService;
    private final PasswordEncoder passwordEncoder;

    // 1단계: 이용약관
    @GetMapping("/terms")
    public String showTermsPage() {
        return "user/signup/terms";
    }

    @PostMapping("/terms")
    public String acceptTerms(
    		@RequestParam(value = "agreeTerms", required = false) String terms1,
            @RequestParam(value = "agreePrivacy", required = false) String terms2,
            @RequestParam(value = "agreePolicy", required = false) String terms3,
            HttpSession session) {
        if (terms1 != null && terms2 != null && terms3 != null) {
            session.setAttribute("termsAccepted", true);
            return "redirect:/user/signup/emailAuth";
        } else {
            return "redirect:/user/signup/terms?error=notAgreed";
        }
    }

    // 2단계: 이메일 인증 페이지
    @GetMapping("/emailAuth")
    public String showEmailVerificationPage(HttpSession session) {
        if (session.getAttribute("termsAccepted") == null) {
            return "redirect:/user/signup/terms";
        }
        return "user/signup/emailAuth";
    }

    // 이메일로 인증번호 발송
    @PostMapping("/emailAuth/sendAuthCode")
    @ResponseBody
    public String sendAuthCode(
    		@RequestParam("email") String email, 
    		HttpSession session) {
        String code = generateAuthCode();
        session.setAttribute("authCode", code);
        session.setAttribute("email", email);

        boolean result = emailService.sendEmail(email, "이메일 인증번호", "인증번호: " + code);
        return result ? "success" : "fail";
    }

    // 인증번호 확인
    @PostMapping("/emailAuth/verifyCode")
    @ResponseBody
    public String verifyCode(
    		@RequestParam("code") String code,
    		@RequestParam("email") String email,
    		HttpSession session) {
        String sessionCode = (String) session.getAttribute("authCode");
        String sessionEmail = (String) session.getAttribute("email");
        if (sessionCode != null && sessionCode.equals(code)
        		 && sessionEmail != null  && sessionEmail.equals(email)) {
            session.setAttribute("emailVerified", true);
            return "success";
        } else {
            return "fail";
        }
    }
    
    //이메일 인증 성공
    @PostMapping("/signup/verifyEmailSuccess")
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
    	int result = uService.idCheck(userId);
    	return result+"";
    }
    
    // 3단계: 회원정보 입력 페이지
    @GetMapping("/enroll")
    public String showSignUpForm(Model model, HttpSession session) {
        if (session.getAttribute("emailVerified") == null) {
            return "redirect:/user/signup/emailAuth";
        }
        model.addAttribute("user", new User());
        return "user/signup/enroll";
    }
    
    @PostMapping("/enroll")
    public String submitSignUpForm(
            @Validated @ModelAttribute("user") User user,
            BindingResult bindingResult,
            @RequestParam("userPwdCheck") String userPwdCheck,
            @RequestParam("profileImage") MultipartFile profileImage,
            HttpSession session,
            RedirectAttributes ra) {

    	//디버그용 2줄 코드
    	System.out.println("multipart content type: " + profileImage.getContentType());
        System.out.println("file size: " + profileImage.getSize());
        
        if (bindingResult.hasErrors()) {
            return "user/signup/enroll";
        }

        // 비밀번호 일치 확인
        if (!userPwdCheck.equals(user.getUserPwd())) {
        	ra.addFlashAttribute("alertMsg", "비밀번호가 일치하지 않습니다.");
        	return "redirect:/user/signup/enroll";
        }
        
        // 비밀번호 암호화
        String encryptedPassword = passwordEncoder.encode(user.getUserPwd());
        user.setUserPwd(encryptedPassword);

        // 프로필 이미지 저장
        if (!profileImage.isEmpty()) {
            try {
                // 실제 저장 경로
                String saveDirectory = session.getServletContext().getRealPath("/resources/profile/");
                File dir = new File(saveDirectory);
                if (!dir.exists()) {
                    dir.mkdirs(); // 디렉토리가 없으면 생성
                }

                String originalFilename = profileImage.getOriginalFilename();
                String newFilename = System.currentTimeMillis() + "_" + originalFilename;

                File destFile = new File(saveDirectory + File.separator + newFilename);
                profileImage.transferTo(destFile);

                // 이미지 파일 URL 설정 (브라우저에서 접근 가능 경로)
                String imageUrl = "/resources/profile/" + newFilename;
                user.setImageUrl(imageUrl);

            } catch (IOException e) {
                e.printStackTrace();
            }
        }

        // DB 저장
        int userNum = uService.insertUser(user);

        if (user.getImageUrl() != null && !user.getImageUrl().isBlank()) {
            uService.insertProfile(userNum, user.getImageUrl());
        }

        ra.addFlashAttribute("alertMsg", "회원가입 완료!");
        // session.invalidate();
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
