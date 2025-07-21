package com.kh.itda.community.model.dao;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityImg;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class CommunityDaoImpl implements CommunityDao{
	private final SqlSessionTemplate session;

	@Override
	public Map<String, String> getCommunityTypeMap() {
		return session.selectMap("community.getCommunityTypeMap", "communityCd");
	}

	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		return session.selectOne("community.selectListCount",paramMap);
	}

	@Override
	public List<Community> selectList(PageInfo pi, Map<String, Object> paramMap) {
		// 특정 페이지의 데이터를 가져옴(페이징 처리)
		//1. ROWNUM,ROW_NUMBER()으로
		//2. RowBounds를 활용
		//3. OFFSET FETCH를 사용하여 쿼리 조회
		int offset = (pi.getCurrentPage() -1)*pi.getCommunityLimit();
		int limit = pi.getCommunityLimit();	//offset위치에서 몇개의 행을 가져올지
		
		paramMap.put("offset", offset);
		paramMap.put("limit", limit);
		
		return session.selectList("community.selectList",paramMap);
	}

	@Override
	public int insertCommunity(Community c) {
		log.debug("게시글 등록 이전 c : {}", c);
		int result = session.insert("board.insertBoard", c);
		log.debug("게시글 등록 이후 c : {}", c);
		return result;
	}

	@Override
	public int insertCommunityImgList(List<CommunityImg> imgList) {
		return session.insert("community.insertCommunityImgList",imgList);
	}
	
	

}
