package com.kh.itda.community.model.dao;

import java.util.List;
import java.util.Map;

import com.kh.itda.common.model.vo.BoardComment;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityExt;
import com.kh.itda.community.model.vo.CommunityImg;
import com.kh.itda.community.model.vo.CommunityReaction;
import com.kh.itda.community.model.vo.CommunityType;
import com.kh.itda.community.model.vo.communityTag;

public interface CommunityDao {

	Map<String, CommunityType> getCommunityTypeMap();

	int selectListCount(Map<String, Object> paramMap);

	List<Community> selectList(PageInfo pi, Map<String, Object> paramMap);

	int insertCommunity(Community c);

	int insertCommunityImgList(List<CommunityImg> imgList);

	int increaseCount(int communityNo);

	CommunityExt selectCommunity(int communityNo);

	CommunityReaction selectUserReaction(int userNum, int communityNo);

	int insertReaction(CommunityReaction reaction);

	int deleteReaction(CommunityReaction reaction);

	int updateReaction(CommunityReaction reaction);

	int getLikeCount(int communityNo);

	int getDislikeCount(int communityNo);

	CommunityReaction userReactionNo(int userNum, int communityNo);

	communityTag selectTagByName(String tagName);

	int insertTag(communityTag newTag);

	int insertCommunityTag(Map<String, Integer> params);

	List<communityTag> selectTagsByCommunityNo(int communityNo);

	int deleteCommunity(int communityNo);

	List<BoardComment> selectCommentList(int communityNo);

	int insertComment(BoardComment comment);

	BoardComment selectComment(int commentNo);

	int deleteComment(int commentNo);

	



}