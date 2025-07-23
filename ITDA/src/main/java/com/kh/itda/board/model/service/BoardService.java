package com.kh.itda.board.model.service;

import java.util.List;

import com.kh.itda.board.model.vo.BoardAuctionWrapper;
import com.kh.itda.board.model.vo.BoardExchangeWrapper;
import com.kh.itda.board.model.vo.BoardRentalWrapper;
import com.kh.itda.board.model.vo.BoardShareWrapper;
import com.kh.itda.board.model.vo.ProductCategory;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;

public interface BoardService {

	int insertBoardRental(BoardRentalWrapper board, List<FilePath> pathList, List<File> imgList);
	int insertBoardShare(BoardShareWrapper board, List<FilePath> pathList, List<File> imgList);
	int insertBoardExchange(BoardExchangeWrapper board, List<FilePath> pathList, List<File> imgList);
	int insertBoardAuction(BoardAuctionWrapper board, List<FilePath> pathList, List<File> imgList);

	List<ProductCategory> selectCategoryList();

	List<ProductCategory> getCategoriesByParentNum(int parentNum);
	List<BoardRentalWrapper> selectBoardRentalList();

}
