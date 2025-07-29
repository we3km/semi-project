package com.kh.itda.board.model.service;

import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.itda.board.model.vo.BoardAuctionWrapper;
import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardExchangeWrapper;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.board.model.vo.BoardRentalWrapper;
import com.kh.itda.board.model.vo.BoardShareWrapper;
import com.kh.itda.board.model.vo.Dibs;
import com.kh.itda.board.model.vo.ProductCategory;
import com.kh.itda.board.model.vo.BoardRentalFileWrapper;
import com.kh.itda.common.model.vo.BoardTag;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;
import com.kh.itda.common.model.vo.Tag;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class BoardDaoImpl implements BoardDao {
	private final SqlSessionTemplate session;
	
	// 대여 게시물 등록
	@Override
	public int insertBoardRental(BoardRentalWrapper board, List<File> imgList) {
		int result = 0;
		
		// 공통 정보 저장
		BoardCommon boardCommon = board.getBoardCommon();
		// 공통정보 저장 결과
		int commonResult = session.insert("board.insertBoardCommon" , boardCommon);
		
		
		int boardId = boardCommon.getBoardId(); // 지금 추가된 게시물 ID

		// 대여 정보 저장
		BoardRental boardRental = board.getBoardRental();
		boardRental.setBoardId(boardId); 
		
		// 대여 정보 저장 결과
		int rentalResult = session.insert("board.insertBoardRental" , boardRental);	
		
		// 태그 저장
		List<String> tagList = boardCommon.getTagList();
		
		if(!tagList.isEmpty()) {
			for(int i = 0; i < tagList.size(); i++) {
				Tag tag =new Tag();
				BoardTag boardTag = new BoardTag();
				tag.setTagContent(tagList.get(i));
				session.insert("board.insertTag", tag);
				
				boardTag.setTagId(tag.getTagId());
				boardTag.setBoardId(boardId);
				boardTag.setBoardCategory(boardCommon.getTransactionCategory());
				session.insert("board.insertBoardTag", boardTag);
			}
			
		}
		
		
		
		// 이미지 정보 저장
		if(!imgList.isEmpty()) {
			for(int i = 0; i < imgList.size();i++) {
				File f = imgList.get(i);
				
				f.setRefNo(boardId);
				switch(boardCommon.getTransactionCategory()) {
				case "rental":
					f.setCategoryId(6);
					break;
				case "share":
					f.setCategoryId(7);
					break;
				case "auction":
					f.setCategoryId(8);
					break;
				case "exchange":
					f.setCategoryId(9);
					break;
				}
				session.insert("board.insertImg", f);
			}
		}
		
		
		if(commonResult > 0 && rentalResult > 0) {
			result = 1;
		}
		return result;
	}

	
	@Override
	public int insertBoardShare(BoardShareWrapper board, List<FilePath> pathList, List<File> imgList) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int insertBoardAuction(BoardAuctionWrapper board, List<FilePath> pathList, List<File> imgList) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	@Override
	public int insertBoardExchange(BoardExchangeWrapper board, List<FilePath> pathList, List<File> imgList) {
		// TODO Auto-generated method stub
		return 0;
	}
	
	
	
	
	
	
	// 카테고리 리스트 반환 
	@Override
	public List<ProductCategory> selectCategoryList() {
		List<ProductCategory> list = session.selectList("board.selectCategoryList");

		return list;
	}
	// 선택한 카테고리의 하위 카테고리 리스트 반환
	@Override
	public List<ProductCategory> getCategoriesByParentNum(int parentNum) {
		
		return session.selectList("board.getCategoriesByParentNum", parentNum);
	}

	// 정렬조건에 따른 대여 게시물 목록 반환
	@Override
	public List<BoardRentalFileWrapper> selectBoardRentalList(Map<String, Object> filterMap) {
		List<BoardRentalFileWrapper> boardRentalList = session.selectList("board.selectBoardRentalList", filterMap);
		//System.out.println(boardRentalList);

		return boardRentalList;
	}

	// 선택한 게시물의 상세정보 반환
	@Override
	public BoardRentalWrapper selectBoardRental(int boardId) {
		BoardRentalWrapper board = session.selectOne("board.selectBoardRental", boardId);
		System.out.println(board);

		return board;
	}
	
	// 선택한 게시물의 게시자 이름 반환
	@Override
	public String selectWriterNickname(int userNum) {
		String writer = session.selectOne("board.selectWriterNickname", userNum);
		return writer;
	}

	// 선택한 게시글의 태그 반환
	@Override
	public List<String> selectTags(int boardId) {
		return session.selectList("board.selectTags", boardId);
	}

	// 조회한 게시글의 조회수 증가
	@Override
	public int increaseViews(int boardId) {
		return session.update("board.increaseViews", boardId);
	}
	
	// 사용자가 조회한 게시글의 찜 여부 반환
	@Override
	public int isLiked(Dibs dibs) {
		return session.selectOne("board.isLiked", dibs);
	}

	// 찜 취소
	@Override
	public void deleteLike(Dibs dibs) {
		session.selectOne("board.deleteLike", dibs);
	}
	
	// 찜 추가
	@Override
	public void insertLike(Dibs dibs) {
		session.selectOne("board.insertLike", dibs);
	}
	
	// 조회한 게시글의 찜 수 반환
	@Override
	public int countDibs(Dibs dibs) {
		return session.selectOne("board.countDibs", dibs);
	}

	// 조회한 게시글의 게시자의 매너점수 반환	
	@Override
	public int selectMannerScore(int writerUserNum) {
		return session.selectOne("board.selectMannerScore", writerUserNum);
	}

	// 조회한 게시글의 게시자가 작성한 대여 게시글 목록 반환
	@Override
	public List<BoardRentalFileWrapper> selectWriterRentalList(int userNum) {
		return session.selectList("board.selectWriterRentalList", userNum);
	}
	
	// 조회한 게시글의 소분류 카테고리와 같은 대여 게시글 목록 반환
	@Override
	public List<BoardRentalFileWrapper> selectEqualsCategoryList(String smallCategory) {
		return session.selectList("board.selectEqualsCategoryList", smallCategory);
	}
	
	// 조회한 게시글의 이미지 목록 반환
	@Override
	public List<FilePath> selectImgList(int boardId) {
		return session.selectList("board.selectImgList", boardId);
	}

	// 정렬된 목록 중에 사용자가 찜한 게시물 목록 반환
	@Override
	public List<Integer> selectLikedBoardIdsByUser(int userNum) {
		return session.selectList("board.selectLikedBoardIdsByUser", userNum);
	}


	@Override
	public String selectUserAddress(int userNum) {
		return session.selectOne("board.selectUserAddress", userNum);
	}



	
	
}
