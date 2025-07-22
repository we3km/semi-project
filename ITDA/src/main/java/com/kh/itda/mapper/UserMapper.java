package com.kh.itda.mapper;

import java.util.Optional;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

@Mapper
public interface UserMapper {

    Optional<String> findIdByNameAndEmail(@Param("name") String name, @Param("email") String email);

    Optional<String> findPwdByIdAndEmail(@Param("id") String id, @Param("email") String email);

}