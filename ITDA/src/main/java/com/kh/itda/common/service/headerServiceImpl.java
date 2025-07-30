package com.kh.itda.common.service;

import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.itda.common.dao.HeaderDao;
import com.kh.itda.common.model.vo.boardCategory;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class headerServiceImpl implements HeaderService{
	private final HeaderDao headerDao;

	@Override
	public Map<Integer, boardCategory> getTypeMap() {
		return headerDao.getTypeMap();
	}
	

}
