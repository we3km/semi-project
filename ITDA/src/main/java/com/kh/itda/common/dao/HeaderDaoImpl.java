package com.kh.itda.common.dao;

import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.itda.common.model.vo.boardCategory;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class HeaderDaoImpl implements HeaderDao{
	private final SqlSessionTemplate session;

	@Override
	public Map<Integer, boardCategory> getTypeMap() {
		return session.selectMap("getTypeMap", "categoryId");
	}
	

}
