package com.kh.itda.location.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.Resource;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.location.model.vo.Location;


@Repository
public class locationDao {

	@Autowired
	private SqlSessionTemplate session;

	public int insertLocation(Location loc) {
		return session.insert("location.insertLocation",loc);
	}

	public Location findBySidoSigungu(String sido, String sigungu) {
		Map<String,String> param = new HashMap<>();
		param.put("sido", sido);
		param.put("sigungu",sigungu);
		return session.selectOne("location.findBySidoSigungu",param);
	}

	public List<String> findAllSido() {
        return session.selectList("location.findAllSido");

	}

	public List<String> findSigunguBySido(String sido) {
		return session.selectList("location.findSigunguBySido", sido);
	}

	public List<String> findGuListBySidoIfDirect(String sido) {
		return session.selectList("findGuListBySidoIfDirect",sido);
	}

}
