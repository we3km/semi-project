package com.kh.itda.common.service;

import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.itda.common.dao.MainDao;
import com.kh.itda.common.model.vo.boardCategory;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class MainServiceImpl implements MainService{
	private final MainDao mainDao;

	@Override
	public Map<Integer, boardCategory> getMainTypeMap() {
		return mainDao.getMainTypeMap();
	}

}
