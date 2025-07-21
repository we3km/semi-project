package com.kh.itda.community.model.service;

import java.util.List;
import java.util.Map;

import org.springframework.stereotype.Service;

import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.dao.CommunityDao;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityImg;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommunityServiceImpl implements CommunityService{
	
	private final CommunityDao communityDao;
	
	@Override
	public Map<String, String> getCommunityTypeMap() {
		return communityDao.getCommunityTypeMap();
	}

	@Override
	public int selectListCount(Map<String, Object> paramMap) {
		return communityDao.selectListCount(paramMap);
	}

	@Override
	public List<Community> selectList(PageInfo pi, Map<String, Object> paramMap) {
		return communityDao.selectList(pi,paramMap);
	}

	@Override
	public int insertCommunity(Community c, List<CommunityImg> imgList) {
		
		// 데이터 전처리
		c.setCommunityContent(Utils.XSSHandling(c.getCommunityContent()));
		c.setCommunityContent(Utils.newLineHandling(c.getCommunityContent()));
		c.setCommunityTitle(Utils.XSSHandling(c.getCommunityTitle()));
		
		// 게시글 저장
		int result = communityDao.insertCommunity(c);
		
		if(result == 0 ) {
			throw new RuntimeException("게시글 등록 실패");
		}
		
		//첨부파일 등록
		if(!imgList.isEmpty()) {
			for(CommunityImg ci : imgList) {
				ci.setRefCno(c.getCommunityNo());
			}
			//다중 인서트문 실행
			int imgResult = communityDao.insertCommunityImgList(imgList);
			
			if(imgResult != imgList.size()) {
				throw new RuntimeException("첨부파일 등록 실패");
			}
		}
		
		return result;
	}

}
