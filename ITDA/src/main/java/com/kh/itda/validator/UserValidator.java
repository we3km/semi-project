package com.kh.itda.validator;

import java.util.Calendar;
import java.util.Date;

public class UserValidator {

	public static boolean isValidId(String userId) {
        return userId != null && userId.matches("^[a-zA-Z0-9]{4,12}$");
    }

    public static boolean isValidPassword(String userPwd) {
        return userPwd != null && userPwd.matches("^(?=.*[a-zA-Z])(?=.*\\d)[a-zA-Z0-9]{8,15}$");
    }

    public static boolean isValidNickName(String nickName) {
        return nickName != null && nickName.matches("^[가-힣a-zA-Z0-9]{2,12}$");
    }

    public static boolean isValidPhone(String phone) {
        return phone != null && phone.matches("^010-\\d{4}-\\d{4}$");
    }

    public static boolean isValidBirth(Date birth) {
        if (birth == null) return false;

        Calendar today = Calendar.getInstance();
        Calendar birthCal = Calendar.getInstance();
        birthCal.setTime(birth);

        // 미래 날짜 여부 확인
        if (birthCal.after(today)) {
            return false;
        }

        // 만 14세 이상 여부 확인
        today.add(Calendar.YEAR, -14); // 14세 이상 조건
        return !birthCal.after(today); // 미래는 입력 불가
    }
}
