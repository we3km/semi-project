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
public class MainDaoImpl implements MainDao{
	
	private final SqlSessionTemplate session;
	
	@Override
	public Map<Integer, boardCategory> getMainTypeMap() {
		return session.selectMap("getMainTypeMap","categoryId");
	}

}
