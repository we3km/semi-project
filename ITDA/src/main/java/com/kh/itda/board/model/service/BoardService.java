package com.kh.itda.board.model.service;

import java.util.List;
import java.util.Map;
import java.util.Optional;

import com.kh.itda.board.model.vo.AuctionBidding;
import com.kh.itda.board.model.vo.BoardAllWrapper;
import com.kh.itda.board.model.vo.BoardAuctionFileWrapper;
import com.kh.itda.board.model.vo.BoardAuctionWrapper;
import com.kh.itda.board.model.vo.BoardExchangeWrapper;
import com.kh.itda.board.model.vo.BoardRentalWrapper;
import com.kh.itda.board.model.vo.BoardShareFileWrapper;
import com.kh.itda.board.model.vo.BoardShareWrapper;
import com.kh.itda.board.model.vo.Dibs;
import com.kh.itda.board.model.vo.ProductCategories;
import com.kh.itda.board.model.vo.ProductCategory;
import com.kh.itda.board.model.vo.BoardRentalFileWrapper;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;

import com.kh.itda.user.model.vo.RentalItem;

import com.kh.itda.community.model.vo.CommunityType;


public interface BoardService {

	int insertBoardRental(BoardRentalWrapper board, List<File> imgList);
	
	int insertBoardExchange(BoardExchangeWrapper board, List<FilePath> pathList, List<File> imgList);
	int insertBoardAuction(BoardAuctionWrapper board, List<FilePath> pathList, List<File> imgList);

	List<ProductCategory> selectCategoryList();

	List<ProductCategory> getCategoriesByParentNum(int parentNum);
	List<BoardRentalFileWrapper> selectBoardRentalList(Map<String, Object> filterMap);
	BoardRentalWrapper selectBoardRental(int boardId);
	String selectWriterNickname(int userNum);
	List<String> selectTags(int boardId);
	int increaseViews(int boardId);

	
	boolean isLiked(Dibs dibs);
	void removeLike(Dibs dibs);
	void addLike(Dibs dibs);
	int countDibs(Dibs dibs);
	int selectMannerScore(int writerUserNum);
	
	List<BoardRentalFileWrapper> selectWriterRentalList(int userNum);
	
	
	List<BoardRentalFileWrapper> selectEqualsCategoryList(String smallCategory);
	List<FilePath> selectImgList(int boardId);
	List<Integer> getLikedBoardIdsByUser(int userNum);
	String selectUserAddress(int userNum);
	
	
	
	
	
	
	List<BoardShareFileWrapper> selectBoardShareList(Map<String, Object> filterMap);
	int insertBoardShare(BoardShareWrapper board, List<File> imgList);
	BoardShareWrapper selectBoardShare(int boardId);

	List<FilePath> selectShareImgList(int boardId);

	List<BoardShareFileWrapper> selectWriterShareList(int writerUserNum);
	List<BoardShareFileWrapper> selectEqualsCategoryShareList(String smallCategory);
	
	
	

	int insertBoardAuction(BoardAuctionWrapper board, List<File> imgList);

	BoardAuctionWrapper selectBoardAuction(int boardId);

	List<BoardAuctionFileWrapper> selectWriterAuctionList(int writerUserNum);

	List<BoardAuctionFileWrapper> selectEqualsCategoryAuctionList(String smallCategory);

	List<FilePath> selectAuctionImgList(int boardId);

	List<BoardAuctionFileWrapper> selectBoardAuctionList(Map<String, Object> filterMap);

	void saveBid(AuctionBidding bid);

	List<AuctionBidding> selectBidList(int boardId);

	AuctionBidding findBidByUserAndBoard(int userNum, int boardId);

	void updateBid(AuctionBidding bid);

	void insertBiddingWinner(int boardId);
	
	List<RentalItem> getRentalItemByUserNum(int userNum);

	List<BoardAllWrapper> selectMyBoard(int userNum);
	void deleteBoard(int boardId);

	Map<String, ProductCategories> getProductType();

	String getProfileImage(int writerUserNum);





}
