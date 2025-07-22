package com.kh.itda.board.model.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardRental;
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
	public int insertBoard(BoardCommon boardCommon, BoardRental boardRental, List<FilePath> pathList, List<File> imgList) {
		boardCommon.setProductComment(Utils.XSSHandling(boardCommon.getProductComment()));
		boardCommon.setProductComment(Utils.newLineHandling(boardCommon.getProductComment()));
		boardCommon.setProductName(Utils.XSSHandling(boardCommon.getProductName()));
		
		// 게시글 정보 등록
		int result = 0;
		// 이미지가 비어있는지 확인
		if(!imgList.isEmpty() && !pathList.isEmpty()) {
			result = boardDao.insertBoard(boardCommon, boardRental, pathList, imgList);
			
		}
		
		return result;
	}
	
	@Override
	public List<ProductCategory> selectCategoryList() {
		List<ProductCategory> list = boardDao.selectCategoryList();
		return list;
	}

}
