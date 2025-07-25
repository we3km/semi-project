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

	@Override
	public int insertBoardRental(BoardRentalWrapper board, List<File> imgList) {
		int result = 0;
		
		BoardCommon boardCommon = board.getBoardCommon();
		int commonResult = session.insert("board.insertBoardCommon" , boardCommon);
		
		int boardId = boardCommon.getBoardId(); // 지금 추가된 게시물 ID

		
		BoardRental boardRental = board.getBoardRental();
		boardRental.setBoardId(boardId); 
				
		int rentalResult = session.insert("board.insertBoardRental" , boardRental);	
		
		
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
	
	
	
	
	
	
	
	@Override
	public List<ProductCategory> selectCategoryList() {
		List<ProductCategory> list = session.selectList("board.selectCategoryList");

		return list;
	}

	@Override
	public List<ProductCategory> getCategoriesByParentNum(int parentNum) {
		
		return session.selectList("board.getCategoriesByParentNum", parentNum);
	}

	@Override
	public List<BoardRentalFileWrapper> selectBoardRentalList() {
		List<BoardRentalFileWrapper> boardRentalList = session.selectList("board.selectBoardRentalList");
		//System.out.println(boardRentalList);

		return boardRentalList;
	}

	@Override
	public BoardRentalWrapper selectBoardRental(int boardId) {
		BoardRentalWrapper board = session.selectOne("board.selectBoardRental", boardId);
		System.out.println(board);

		return board;
	}

	@Override
	public String selectWriterNickname(int userNum) {
		String writer = session.selectOne("board.selectWriterNickname", userNum);
		return writer;
	}

	@Override
	public List<String> selectTags(int boardId) {
		return session.selectList("board.selectTags", boardId);
	}

	@Override
	public int increaseViews(int boardId) {
		return session.update("board.increaseViews", boardId);
	}



	@Override
	public int isLiked(Dibs dibs) {
		return session.selectOne("board.isLiked", dibs);
	}


	@Override
	public void deleteLike(Dibs dibs) {
		session.selectOne("board.deleteLike", dibs);
		
	}

	@Override
	public void insertLike(Dibs dibs) {
		session.selectOne("board.insertLike", dibs);
	}

	@Override
	public int countDibs(Dibs dibs) {
		return session.selectOne("board.countDibs", dibs);
	}

	@Override
	public int selectMannerScore(int writerUserNum) {
		return session.selectOne("board.selectMannerScore", writerUserNum);
	}

	@Override
	public List<BoardRentalFileWrapper> selectWriterRentalList(int userNum) {
		return session.selectList("board.selectWriterRentalList", userNum);
	}

	@Override
	public List<BoardRentalFileWrapper> selectEqualsCategoryList(String smallCategory) {
		return session.selectList("board.selectEqualsCategoryList", smallCategory);
	}

	@Override
	public List<FilePath> selectImgList(int boardId) {
		return session.selectList("board.selectImgList", boardId);
	}



	
	
}
