package com.kh.itda.location.service;

import java.util.List;

public interface locationService {

	Long findOrCreate(String sido, String sigungu);

	List<String> findAllSido();

	List<String> findSigunguBySido(String sido); 

}
