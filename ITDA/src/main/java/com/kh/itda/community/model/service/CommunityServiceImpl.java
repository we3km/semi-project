package com.kh.itda.community.model.service;

import java.util.ArrayList;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.Map.Entry;
import java.util.Set;
import java.util.TreeMap;

import javax.servlet.ServletContext;

import org.springframework.dao.DuplicateKeyException;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.BoardComment;
import com.kh.itda.common.model.vo.BoardCommentExt;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.community.model.dao.CommunityDao;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityExt;
import com.kh.itda.community.model.vo.CommunityImg;
import com.kh.itda.community.model.vo.CommunityReaction;
import com.kh.itda.community.model.vo.CommunityType;
import com.kh.itda.community.model.vo.communityTag;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class CommunityServiceImpl implements CommunityService{
	
	private final CommunityDao communityDao;
	private final ServletContext application;
	
	@Override
	public Map<String, CommunityType> getCommunityTypeMap() {
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
		c.setWriteDate(new Date());
		
		
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
	    CommunityReaction existing = communityDao.selectUserReaction(reaction.getUserNum(), reaction.getCommunityNo());

	    if (existing == null) {
	        try {
	            communityDao.insertReaction(reaction);
	            return reaction.getType();
	        } catch (DuplicateKeyException e) {
	            // 이미 존재하는 경우 → 기존 반응 조회해서 처리
	            return communityDao.selectUserReaction(reaction.getUserNum(), reaction.getCommunityNo()).getType();
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
	public CommunityReaction userReactionNo(int userNum, int communityNo) {
		System.out.println(">>> selectUserReaction() 호출됨");
		return communityDao.userReactionNo(userNum,communityNo);
	}

	@Override
	public int deleteCommunity(int communityNo, int userNum) {
		CommunityExt originalPost = communityDao.selectCommunity(communityNo);
		
		if(originalPost != null && originalPost.getCommunityWriter() == userNum) {
			return communityDao.deleteCommunity(communityNo);
		}else {
		return 0;
		}
	}

	//댓글
	@Override
	public List<BoardCommentExt> selectCommentList(int communityNo, String sort) {
		List<BoardComment> allComments = communityDao.selectCommentList(communityNo, sort);
	    
		Map<Integer, BoardCommentExt> commentMap = new HashMap<>();
	    List<BoardCommentExt> topLevelComments = new ArrayList<>();

	    for (BoardComment c : allComments) {
	    	BoardCommentExt cExt = new BoardCommentExt();
	        cExt.setBoardCmtId(c.getBoardCmtId());
	        cExt.setBoardCmtContent(c.getBoardCmtContent());
	        cExt.setCmtWriteDate(c.getCmtWriteDate());
	        cExt.setRefNo(c.getRefNo());
	        cExt.setRefCommentId(c.getRefCommentId());
	        cExt.setCmtWriterUserNum(c.getCmtWriterUserNum());
	        cExt.setNickName(c.getNickName());
	        commentMap.put(cExt.getBoardCmtId(), cExt);

	        if (cExt.getRefCommentId() > 0) {
	            // 답글인 경우, 부모 찾기
	            BoardCommentExt parent = commentMap.get(cExt.getRefCommentId());
	            if (parent != null) {
	                parent.getReplies().add(cExt);
	            } else {
	                // 부모가 아직 안 들어온 경우 (정렬 문제)
	                // 나중에 처리하거나 로깅
	                System.err.println("부모 댓글이 없습니다: " + cExt.getRefCommentId());
	            }
	        } else {
	            // 최상위 댓글
	            topLevelComments.add(cExt);
	        }
	    }
//	    }
//	    
//	    
//	    //원래는 최상위 댓글 정렬하는 곳
//	    for (Entry<Integer, BoardCommentExt> entry : commentMap.entrySet() ) {
//	    	BoardCommentExt cExt = entry.getValue();
//	        if (cExt.getRefCommentId() > 0) { // 답글인 경우
//	            BoardCommentExt parent = commentMap.get(cExt.getRefCommentId());
//	            if (parent != null) {
//	                parent.getReplies().add(cExt);
//	            }
//	        } else { // 최상위 댓글인 경우
//	            topLevelComments.add(cExt);
//	        }
//	    }
	    System.out.println("최종 : "+topLevelComments);
	    return topLevelComments;
	}

	@Override
	public int insertComment(BoardComment comment) {
		comment.setBoardCmtContent(Utils.XSSHandling(comment.getBoardCmtContent()));
	    comment.setBoardCmtContent(Utils.newLineHandling(comment.getBoardCmtContent()));
	    comment.setCmtWriteDate(new Date());
	    return communityDao.insertComment(comment);
	}

	@Override
	public int deleteComment(int commentNo, int userNo) {
		 // 1. 삭제할 댓글의 원본 정보를 먼저 조회합니다.
	    BoardComment originalComment = communityDao.selectComment(commentNo);

	    // 2. 댓글이 존재하고, 작성자와 삭제 요청자가 일치하는지 확인합니다.
	    if (originalComment != null && originalComment.getCmtWriterUserNum() == userNo) {
	        // 3. 권한이 있으면 삭제(상태 변경)를 진행합니다.
	        return communityDao.deleteComment(commentNo);
	    } else {
	        // 4. 권한이 없으면 0을 반환하여 실패를 알립니다.
	        return 0;
	    }
	}
	
	//게시글 업데이트
	@Override
	public int updateCommunity(CommunityExt c) {
		c.setEditDate(new Date());
		return communityDao.updateCommunity(c);
	}

	@Override
	@Transactional(rollbackFor = {Exception.class})
	public int updateCommunity(CommunityExt c, List<CommunityImg> newImgList, List<Integer> deleteImgNos) {
		// 1. XSS, 개행문자 처리
		c.setCommunityContent(Utils.XSSHandling(c.getCommunityContent()));
		c.setCommunityContent(Utils.newLineHandling(c.getCommunityContent()));
		c.setCommunityTitle(Utils.XSSHandling(c.getCommunityTitle()));
		c.setEditDate(new Date());

		// 2. 기존 이미지 삭제 처리
		if(deleteImgNos != null && !deleteImgNos.isEmpty()) {
			// (1) 서버에서 삭제할 파일의 변경된 이름(changeName) 목록 조회
			List<String> changeNamesToDelete = communityDao.selectChangeNames(deleteImgNos);
			
			// (2) DB에서 이미지 레코드 삭제
			int deleteResult = communityDao.deleteCommunityImgs(deleteImgNos);
			
			if(deleteResult != deleteImgNos.size()) {
				throw new RuntimeException("DB 이미지 레코드 삭제 실패");
			}
			
			// (3) 서버에서 실제 파일 삭제
			for(String changeName : changeNamesToDelete) {
				String folderName = "community/" + c.getCommunityCd();
				Utils.deleteFile(changeName, application, folderName);
			}
		}
		
		// 3. 새로운 이미지 추가
		if(newImgList != null && !newImgList.isEmpty()) {
			for(CommunityImg ci : newImgList) {
				ci.setRefCno(c.getCommunityNo()); // 게시글 번호 참조 설정
				// imgLevel은 필요 시 설정 (예: 기존 이미지 개수 + index)
			}
			int insertImgResult = communityDao.insertCommunityImgList(newImgList);
			if(insertImgResult != newImgList.size()) {
				throw new RuntimeException("첨부파일 등록 실패");
			}
		}
		
		// 4. 게시글 텍스트 정보 업데이트
		int result = communityDao.updateCommunity(c);
		if(result == 0) {
			throw new RuntimeException("게시글 정보 업데이트 실패");
		}
		
		// (1) 해당 게시글의 기존 태그 연결을 모두 삭제
	    communityDao.deleteCommunityTags(c.getCommunityNo());

	    // (2) 새로 제출된 태그 문자열(tagStr)을 다시 저장 (insert 로직과 동일)
	    String tagStr = c.getTagStr();
	    if (tagStr != null && !tagStr.isEmpty()) {
	        String[] tagNames = tagStr.split(",");
	        for (String tagName : tagNames) {
	            tagName = tagName.trim();
	            if (tagName.isEmpty()) continue;

	            // DB에 해당 태그가 있는지 확인
	            communityTag existingTag = communityDao.selectTagByName(tagName);
	            int tagId;

	            if (existingTag == null) {
	                // 없으면 TAG 테이블에 새로 추가
	                communityTag newTag = new communityTag();
	                newTag.setTagContent(tagName);
	                communityDao.insertTag(newTag);
	                tagId = newTag.getTagId();
	            } else {
	                // 있으면 기존 태그 ID 사용
	                tagId = existingTag.getTagId();
	            }

	            // 게시글과 태그의 관계를 BOARD_COMMUNITY_TAG 테이블에 추가
	            Map<String, Integer> params = new HashMap<>();
	            params.put("communityNo", c.getCommunityNo());
	            params.put("tagId", tagId);
	            communityDao.insertCommunityTag(params);
	        }
	     }
		return result;
		
	}

	
	


}
