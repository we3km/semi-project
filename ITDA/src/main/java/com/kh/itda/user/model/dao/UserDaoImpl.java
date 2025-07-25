package com.kh.itda.user.model.dao;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.user.model.vo.User;

import java.util.HashMap;
import java.util.Map;

@Repository
public class UserDaoImpl implements UserDao {

    @Autowired
    private SqlSession sqlSession;

    private static final String NAMESPACE = "userMapper.";

    @Override
    public User login(String userId, String userPwd) {
        Map<String, Object> param = new HashMap<>();
        param.put("userId", userId);
        param.put("userPwd", userPwd);

        return sqlSession.selectOne(NAMESPACE + "login", param);
    }
}
