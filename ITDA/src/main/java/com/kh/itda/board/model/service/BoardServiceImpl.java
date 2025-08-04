package com.kh.itda.board.model.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.board.model.vo.AuctionBidding;
import com.kh.itda.board.model.vo.BoardAuctionFileWrapper;
import com.kh.itda.board.model.vo.BoardAuctionWrapper;
import com.kh.itda.board.model.vo.BoardExchangeWrapper;
import com.kh.itda.board.model.vo.BoardRentalWrapper;
import com.kh.itda.board.model.vo.BoardShareFileWrapper;
import com.kh.itda.board.model.vo.BoardShareWrapper;
import com.kh.itda.board.model.vo.Dibs;
import com.kh.itda.board.model.vo.ProductCategory;
import com.kh.itda.board.model.vo.BoardRentalFileWrapper;
import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;
import com.kh.itda.user.model.vo.RentalItem;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService{
	@Autowired
	private final BoardDao boardDao;
	// 대여 게시물 등록
	@Override
	public int insertBoardRental(BoardRentalWrapper board,  List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
					
		int result = boardDao.insertBoardRental(board, imgList);

		return result;
	}
	

	@Override
	public int insertBoardExchange(BoardExchangeWrapper board, List<FilePath> pathList, List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
		int result = 0;

		result = boardDao.insertBoardExchange(board, pathList, imgList);

		return result;
	}

	@Override
	public int insertBoardAuction(BoardAuctionWrapper board, List<FilePath> pathList, List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
		int result = 0;

		result = boardDao.insertBoardAuction(board, pathList, imgList);

		return result;
	}
	
	// 카테고리 리스트 반환
	@Override
	public List<ProductCategory> selectCategoryList() {
		List<ProductCategory> list = boardDao.selectCategoryList();
		return list;
	}
	
	// 선택한 카테고리의 하위 카테고리 리스트 반환
	@Override
	public List<ProductCategory> getCategoriesByParentNum(int parentNum) {
		return boardDao.getCategoriesByParentNum(parentNum);
	}

	// 정렬조건에 따른 대여 게시물 목록 반환
	@Override
	public List<BoardRentalFileWrapper> selectBoardRentalList(Map<String, Object> filterMap) {
		return boardDao.selectBoardRentalList(filterMap);
	}

	// 선택한 게시물의 상세정보 반환
	@Override
	public BoardRentalWrapper selectBoardRental(int boardId) {
		return boardDao.selectBoardRental(boardId);
	}

	// 선택한 게시물의 게시자 이름 반환
	@Override
	public String selectWriterNickname(int userNum) {
		return boardDao.selectWriterNickname(userNum);
	}

	// 선택한 게시글의 태그 반환
	@Override
	public List<String> selectTags(int boardId) {
		 return boardDao.selectTags(boardId);
	}

	// 조회한 게시글의 조회수 증가
	@Override
	public int increaseViews(int boardId) {
		return boardDao.increaseViews(boardId);
	}
	
	// 사용자가 조회한 게시글의 찜 여부 반환
	@Override
	public boolean isLiked(Dibs dibs) {
		
		return boardDao.isLiked(dibs) > 0;
		
	}

	// 찜 취소
	@Override
	public void removeLike(Dibs dibs) {
		boardDao.deleteLike(dibs);
		
	}

	// 찜 추가
	@Override
	public void addLike(Dibs dibs) {
		boardDao.insertLike(dibs);
		
	}

	// 조회한 게시글의 찜 수 반환
	@Override
	public int countDibs(Dibs dibs) {
		return boardDao.countDibs(dibs);
	}

	// 조회한 게시글의 게시자의 매너점수 반환
	@Override
	public int selectMannerScore(int writerUserNum) {
		int score = boardDao.selectMannerScore(writerUserNum);
		return score;
	}

	// 조회한 게시글의 게시자가 작성한 대여 게시글 목록 반환
	@Override
	public List<BoardRentalFileWrapper> selectWriterRentalList(int userNum) {
		return boardDao.selectWriterRentalList(userNum);
	}

	// 조회한 게시글의 소분류 카테고리와 같은 대여 게시글 목록 반환
	@Override
	public List<BoardRentalFileWrapper> selectEqualsCategoryList(String smallCategory) {
		return boardDao.selectEqualsCategoryList(smallCategory);
	}

	// 조회한 게시글의 이미지 목록 반환
	@Override
	public List<FilePath> selectImgList(int boardId) {
		return boardDao.selectImgList(boardId);
	}

	// 정렬된 목록 중에 사용자가 찜한 게시물 목록 반환
	@Override
	public List<Integer> getLikedBoardIdsByUser(int userNum) {
		return boardDao.selectLikedBoardIdsByUser(userNum);
	}


	// 사용자의 회원정보에 있는 주소 추출
	@Override
	public String selectUserAddress(int userNum) {
		return boardDao.selectUserAddress(userNum);
	}


	@Override
	public List<BoardShareFileWrapper> selectBoardShareList(Map<String, Object> filterMap) {
		return boardDao.selectBoardShareList(filterMap);
	}


	@Override
	public int insertBoardShare(BoardShareWrapper board, List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
					
		int result = boardDao.insertBoardShare(board, imgList);

		return result;
	}


	@Override
	public BoardShareWrapper selectBoardShare(int boardId) {
		return boardDao.selectBoardShare(boardId);
	}


	@Override
	public List<FilePath> selectShareImgList(int boardId) {
		// TODO Auto-generated method stub
		return boardDao.selectShareImgList(boardId);

	}


	@Override
	public List<BoardShareFileWrapper> selectWriterShareList(int writerUserNum) {
		return boardDao.selectWriterShareList(writerUserNum);
	}


	@Override
	public List<BoardShareFileWrapper> selectEqualsCategoryShareList(String smallCategory) {
		return boardDao.selectEqualsCategoryShareList(smallCategory);
	}

	@Override
	public int insertBoardAuction(BoardAuctionWrapper board, List<File> imgList) {
		board.getBoardCommon().setProductComment(Utils.XSSHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductComment(Utils.newLineHandling(board.getBoardCommon().getProductComment()));
		board.getBoardCommon().setProductName(Utils.XSSHandling(board.getBoardCommon().getProductName()));
		
					
		int result = boardDao.insertBoardAuction(board, imgList);

		return result;
	}


	@Override
	public BoardAuctionWrapper selectBoardAuction(int boardId) {
		return boardDao.selectBoardAuction(boardId);
	}


	@Override
	public List<BoardAuctionFileWrapper> selectWriterAuctionList(int writerUserNum) {
		return boardDao.selectWriterAuctionList(writerUserNum);
	}


	@Override
	public List<BoardAuctionFileWrapper> selectEqualsCategoryAuctionList(String smallCategory) {
		return boardDao.selectEqualsCategoryAuctionList(smallCategory);
	}


	@Override
	public List<FilePath> selectAuctionImgList(int boardId) {
		return boardDao.selectAuctionImgList(boardId);
	}


	@Override
	public List<BoardAuctionFileWrapper> selectBoardAuctionList(Map<String, Object> filterMap) {
		return boardDao.selectBoardAuctionList(filterMap);

	}


	@Override
	public void saveBid(AuctionBidding bid) {
		boardDao.saveBid(bid);
		
	}


	@Override
	public List<AuctionBidding> selectBidList(int boardId) {
		return boardDao.selectBidList(boardId);
	}


	@Override
	public AuctionBidding findBidByUserAndBoard(int userNum, int boardId) {
		return boardDao.findBidByUserAndBoard(userNum, boardId);
	}


	@Override
	public void updateBid(AuctionBidding bid) {
		boardDao.updateBid(bid);
		
	}


	@Override
	public void insertBiddingWinner(int boardId) {
		boardDao.insertBiddingWinner(boardId);
	}

	// 마이페이지 > 대여 중인 물품
	@Override
	public List<RentalItem> getRentalItemByUserNum(int userNum) {
		return boardDao.getRentalItemByUserNum(userNum);

	}


}
