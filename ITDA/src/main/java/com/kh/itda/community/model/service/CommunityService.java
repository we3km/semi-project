package com.kh.itda.community.model.service;

import java.util.List;
import java.util.Map;

import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityImg;

public interface CommunityService {

	Map<String, String> getCommunityTypeMap();

	int selectListCount(Map<String, Object> paramMap);

	List<Community> selectList(PageInfo pi, Map<String, Object> paramMap);

	int insertCommunity(Community c, List<CommunityImg> imgList);

}
