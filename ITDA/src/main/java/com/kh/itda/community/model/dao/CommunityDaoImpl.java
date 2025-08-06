package com.kh.itda.community.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.itda.common.model.vo.BoardComment;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityExt;
import com.kh.itda.community.model.vo.CommunityImg;
import com.kh.itda.community.model.vo.CommunityReaction;
import com.kh.itda.community.model.vo.CommunityType;
import com.kh.itda.community.model.vo.communityTag;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class CommunityDaoImpl implements CommunityDao{
	private final SqlSessionTemplate session;

	@Override
	public Map<String, CommunityType> getCommunityTypeMap() {
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
		int result = session.insert("community.insertCommunity", c);
		log.debug("게시글 등록 이후 c : {}", c);
		return result;
	}

	@Override
	public int insertCommunityImg(CommunityImg ci) {
		return session.insert("community.insertCommunityImg", ci);
	}

	@Override
	public int increaseCount(int communityNo) {
		return session.update("community.increaseCount",communityNo);
	}

	@Override
	public CommunityExt selectCommunity(int communityNo) {
		return session.selectOne("community.selectCommunity",communityNo);
	}

	//댓글
	@Override
	public CommunityReaction selectUserReaction(int userNum, int communityNo) {
		Map<String,Object> param = new HashMap<>();
		param.put("userNum", userNum);
		param.put("communityNo", communityNo);
		return session.selectOne("community.selectUserReaction",param);
	}

	@Override
	public int insertReaction(CommunityReaction reaction) {
		return session.insert("community.insertReaction", reaction);
	}

	@Override
	public int deleteReaction(CommunityReaction reaction) {
		return session.delete("community.deleteReaction", reaction);
		
	}

	@Override
	public int updateReaction(CommunityReaction reaction) {
		return session.update("community.updateReaction", reaction);
		
	}

	@Override
	public int getLikeCount(int communityNo) {
		return session.selectOne("community.getLikeCount", communityNo);
	}

	@Override
	public int getDislikeCount(int communityNo) {
		return session.selectOne("community.getDislikeCount", communityNo);
	}

	@Override
	public CommunityReaction userReactionNo(int userNum, int communityNo) {
		Map<String, Object> param = new HashMap<>();
		param.put("userNum", userNum);
		param.put("communityNo", communityNo);
		return session.selectOne("community.selectUserReaction", param);
	}

	@Override
	public communityTag selectTagByName(String tagName) {
		return session.selectOne("community.selectTagByName",tagName);
	}

	@Override
	public int insertTag(communityTag tag) {
		return session.insert("community.insertTag",tag);
		
	}

	@Override
	public int insertCommunityTag(Map<String, Integer> params) {
		return session.insert("community.insertCommunityTag", params);
	}

	@Override
	public List<communityTag> selectTagsByCommunityNo(int communityNo) {
		return session.selectList("community.selectTagsByCommunityNo", communityNo);
	}

	@Override
	public int deleteCommunity(int communityNo) {
		return session.delete("community.deleteCommunity",communityNo);
	}

	@Override
	public List<BoardComment> selectCommentList(int communityNo, String sort) {
		Map<String,Object> params = new HashMap<>();
		params.put("communityNo", communityNo);
		params.put("sort", sort);
		return session.selectList("community.selectCommentList",params);
	}

	@Override
	public int insertComment(BoardComment comment) {
		return session.insert("community.insertComment",comment);
	}

	@Override
	public BoardComment selectComment(int commentNo) {
		return session.selectOne("community.selectComment",commentNo);
	}

	@Override
	public int deleteComment(int commentNo) {
		return session.update("community.deleteComment",commentNo);
	}

	@Override
	public int updateCommunity(CommunityExt c) {
		return session.update("community.updateCommunity",c);
	}

	@Override
	public List<String> selectChangeNames(List<Integer> deleteImgNos) {
		return session.selectList("community.selectChangeNamesByIds", deleteImgNos);
	}

	@Override
	public int deleteCommunityImgs(List<Integer> deleteImgNos) {
		return session.delete("community.deleteImgsByIds", deleteImgNos);
	}

	@Override
	public int deleteCommunityTags(int communityNo) {
		return session.delete("community.deleteCommunityTags",communityNo);
	}

	
	



	

	
	
	

}
