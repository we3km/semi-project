package com.kh.itda.location.service;

import java.util.List;

public interface locationService {

	Long findOrCreate(String sido, String sigungu);

	List<String> findAllSido();

	List<String> findSigunguBySido(String sido);

	List<String> findSigunListBySido(String sido);

	List<String> findGuListBySigun(String sido, String sigun); 

}
