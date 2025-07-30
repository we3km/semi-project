package com.kh.itda.common.dao;

import java.util.Map;

import com.kh.itda.common.model.vo.boardCategory;

public interface HeaderDao {

	Map<Integer, boardCategory> getTypeMap();

}
