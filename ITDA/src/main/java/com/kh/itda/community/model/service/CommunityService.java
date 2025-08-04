package com.kh.itda.community.model.service;

import java.util.List;
import java.util.Map;

import com.kh.itda.common.model.vo.BoardComment;
import com.kh.itda.common.model.vo.BoardCommentExt;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityExt;
import com.kh.itda.community.model.vo.CommunityImg;
import com.kh.itda.community.model.vo.CommunityReaction;
import com.kh.itda.community.model.vo.CommunityType;

public interface CommunityService {

	Map<String, CommunityType> getCommunityTypeMap();

	int selectListCount(Map<String, Object> paramMap);

	List<Community> selectList(PageInfo pi, Map<String, Object> paramMap);

	int insertCommunity(Community c, List<CommunityImg> imgList);

	int increaseCount(int communityNo);

	CommunityExt selectCommunity(int communityNo);

	String handleReaction(CommunityReaction reaction);

	int getLikeCount(int communityNo);

	int getDislikeCount(int communityNo);

	CommunityReaction userReactionNo(int userNum, int communityNo);

	int deleteCommunity(int communityNo, int userNum);

	List<BoardCommentExt> selectCommentList(int communityNo);

	int insertComment(BoardComment comment);

	int deleteComment(int commentNo, int userNo);

	

}
