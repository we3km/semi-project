package com.kh.itda.user.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.user.model.dao.UserDao;
import com.kh.itda.user.model.vo.User;

@Service
public class UserServiceImpl implements UserService {

    @Autowired
    private UserDao userDao;

    @Override
    public User login(String userId, String userPwd) {
        return userDao.login(userId, userPwd);
    }
}
