package com.kh.itda.community.model.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;

import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.dao.CommunityDao;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityExt;
import com.kh.itda.community.model.vo.CommunityImg;
import com.kh.itda.community.model.vo.CommunityReaction;
import com.kh.itda.community.model.vo.communityTag;

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
		
		// 태그 저장 로직
        String tagStr = c.getTagStr();
        if (tagStr != null && !tagStr.isEmpty()) {
            String[] tagNames = tagStr.split(",");
            for (String tagName : tagNames) {
                tagName = tagName.trim();
                if (tagName.isEmpty()) continue;

                communityTag existingTag = communityDao.selectTagByName(tagName);
                int tagId;

                if (existingTag == null) {
                    communityTag newTag = new communityTag();
                    newTag.setTagContent(tagName);
                    communityDao.insertTag(newTag);
                    tagId = newTag.getTagId();
                } else {
                    tagId = existingTag.getTagId();
                }

                Map<String, Integer> params = new HashMap<>();
                params.put("communityNo", c.getCommunityNo());
                params.put("tagId", tagId);
                communityDao.insertCommunityTag(params);
            }
         }
		return result;
	}

	@Override
	public int increaseCount(int communityNo) {
		return communityDao.increaseCount(communityNo);
	}

	@Override
	public CommunityExt selectCommunity(int communityNo) {
		// 게시글 정보 조회
        CommunityExt c = communityDao.selectCommunity(communityNo);
        
        // 태그 목록 추가 조회
        if (c != null) {
            List<communityTag> tags = communityDao.selectTagsByCommunityNo(communityNo);
            c.setTags(tags); // 조회된 태그 목록을 객체에 담아줌
        }
        
        return c;
	}

	
	// 게시글 좋아요/실허용
	@Override
	public String handleReaction(CommunityReaction reaction) {
	    CommunityReaction existing = communityDao.selectUserReaction(reaction.getUserNo(), reaction.getCommunityNo());

	    if (existing == null) {
	        try {
	            communityDao.insertReaction(reaction);
	            return reaction.getType();
	        } catch (DuplicateKeyException e) {
	            // 이미 존재하는 경우 → 기존 반응 조회해서 처리
	            return communityDao.selectUserReaction(reaction.getUserNo(), reaction.getCommunityNo()).getType();
	        }
	    }

	    if (existing.getType().equals(reaction.getType())) {
	        communityDao.deleteReaction(reaction);
	        return "NONE";
	    } else {
	        communityDao.updateReaction(reaction);
	        return reaction.getType();
	    }
	}

	@Override
	public int getLikeCount(int communityNo) {
		return communityDao.getLikeCount(communityNo);
	}

	@Override
	public int getDislikeCount(int communityNo) {
		return communityDao.getDislikeCount(communityNo);
	}

	@Override
	public CommunityReaction userReactionNo(int userNo, int communityNo) {
		System.out.println(">>> selectUserReaction() 호출됨");
		return communityDao.userReactionNo(userNo,communityNo);
	}

	



}
