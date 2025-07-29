package com.kh.itda.user.model.dao;

import org.springframework.stereotype.Repository;

import com.kh.itda.user.model.vo.USER;

@Repository
public interface UserDao {
    USER login(String userId, String userPwd);
}
