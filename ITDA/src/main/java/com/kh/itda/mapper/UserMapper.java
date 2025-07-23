package com.kh.itda.mapper;

import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.kh.itda.user.model.vo.User;

@Mapper
public interface UserMapper {

    Optional<String> findIdByNameAndEmail(@Param("name") String name, @Param("email") String email);

    Optional<String> findPwdByIdAndEmail(@Param("id") String id, @Param("email") String email);

    int selectNextUserNo();
    int insertUser(User user);
    int insertProfile(User user);
    int insertAuthority(@Param("userNum") int userNum);
}