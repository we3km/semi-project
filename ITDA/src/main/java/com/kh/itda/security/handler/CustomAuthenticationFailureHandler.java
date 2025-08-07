package com.kh.itda.security.handler;

import java.io.IOException;
import java.net.URLEncoder;
import java.text.SimpleDateFormat;

import javax.servlet.ServletException;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import com.kh.itda.user.model.vo.BanUser;
import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.authentication.DisabledException;
import org.springframework.security.core.AuthenticationException;
import org.springframework.security.web.authentication.SimpleUrlAuthenticationFailureHandler;
import org.springframework.stereotype.Component;

@Component
public class CustomAuthenticationFailureHandler extends SimpleUrlAuthenticationFailureHandler {

    @Autowired
    private SqlSession sqlSession;

    @Override
    public void onAuthenticationFailure(HttpServletRequest request,
                                        HttpServletResponse response,
                                        AuthenticationException exception)
            throws IOException, ServletException {

        String errorMessage = "아이디 또는 비밀번호가 틀렸습니다.";
        String userId = request.getParameter("userId");

        if (exception instanceof DisabledException) {
            BanUser banInfo = sqlSession.selectOne("banned.getBanInfoByUserId", userId);

            if (banInfo != null) {
                String reason = banInfo.getReason() != null ? banInfo.getReason() : "관리자에 의해 정지됨";
                String penaltyDate = formatDate(banInfo.getPenaltyDate());
                String releaseDate = formatDate(banInfo.getReleaseDate());

                errorMessage = "정지된 계정입니다.\\n사유: " + reason +
                               "\\n정지일: " + penaltyDate +
                               "\\n해제일: " + releaseDate;
            } else {
                errorMessage = "정지된 계정입니다. 관리자에게 문의하세요.";
            }
        }

        // 메시지 URL 인코딩
        String encodedMessage = URLEncoder.encode(errorMessage, "UTF-8");
        setDefaultFailureUrl("/user/login?error=true&message=" + encodedMessage);

        super.onAuthenticationFailure(request, response, exception);
    }

    private String formatDate(java.util.Date date) {
        if (date == null) return "-";
        return new SimpleDateFormat("yyyy-MM-dd").format(date);
    }
}