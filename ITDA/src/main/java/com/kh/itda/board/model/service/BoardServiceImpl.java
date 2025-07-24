package com.kh.itda.board.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.board.model.vo.BoardAuctionWrapper;
import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardExchangeWrapper;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.board.model.vo.BoardRentalWrapper;
import com.kh.itda.board.model.vo.BoardShareWrapper;
import com.kh.itda.board.model.vo.Dibs;
import com.kh.itda.board.model.vo.ProductCategory;
import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService{
	@Autowired
	private final BoardDao boardDao;
	@Override
	public int insertBoardRental(BoardRentalWrapper board,  List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
		// 게시글 정보 등록
		int result = 0;
		// 이미지가 비어있는지 확인
//		if(!imgList.isEmpty() /*&&!pathList.isEmpty()*/) {
//			
//		}
					
			result = boardDao.insertBoardRental(board, imgList);

		return result;
	}
	

	@Override
	public int insertBoardShare(BoardShareWrapper board, List<FilePath> pathList, List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
		// 게시글 정보 등록
		int result = 0;
		// 이미지가 비어있는지 확인
//		if(!imgList.isEmpty() /*&&!pathList.isEmpty()*/) {
//			
//		}
					
			result = boardDao.insertBoardShare(board, pathList, imgList);

		return result;
	}

	@Override
	public int insertBoardExchange(BoardExchangeWrapper board, List<FilePath> pathList, List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
		// 게시글 정보 등록
		int result = 0;
		// 이미지가 비어있는지 확인
//		if(!imgList.isEmpty() /*&&!pathList.isEmpty()*/) {
//			
//		}
					
			result = boardDao.insertBoardExchange(board, pathList, imgList);

		return result;
	}

	@Override
	public int insertBoardAuction(BoardAuctionWrapper board, List<FilePath> pathList, List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
		// 게시글 정보 등록
		int result = 0;
		// 이미지가 비어있는지 확인
//		if(!imgList.isEmpty() /*&&!pathList.isEmpty()*/) {
//			
//		}
					
			result = boardDao.insertBoardAuction(board, pathList, imgList);

		return result;
	}
	
	@Override
	public List<ProductCategory> selectCategoryList() {
		List<ProductCategory> list = boardDao.selectCategoryList();
		return list;
	}

	@Override
	public List<ProductCategory> getCategoriesByParentNum(int parentNum) {
		return boardDao.getCategoriesByParentNum(parentNum);
	}


	@Override
	public List<BoardRentalWrapper> selectBoardRentalList() {
		return boardDao.selectBoardRentalList();
	}


	@Override
	public BoardRentalWrapper selectBoardRental(int boardId) {
		return boardDao.selectBoardRental(boardId);
	}


	@Override
	public String selectWriterNickname(int userNum) {
		return boardDao.selectWriterNickname(userNum);
	}


	@Override
	public List<String> selectTags(int boardId) {
		 return boardDao.selectTags(boardId);
	}


	@Override
	public int increaseViews(int boardId) {
		return boardDao.increaseViews(boardId);
	}

	@Override
	public boolean isLiked(Dibs dibs) {
		
		return boardDao.isLiked(dibs) > 0;
		
	}


	@Override
	public void removeLike(Dibs dibs) {
		boardDao.deleteLike(dibs);
		
	}


	@Override
	public void addLike(Dibs dibs) {
		boardDao.insertLike(dibs);
		
	}


	@Override
	public int countDibs(Dibs dibs) {
		return boardDao.countDibs(dibs);
	}


	@Override
	public int selectMannerScore(int writerUserNum) {
		int score = boardDao.selectMannerScore(writerUserNum);
		return score;
	}




}
