package com.kh.itda.board.model.service;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.common.Utils;

import lombok.RequiredArgsConstructor;

@Service
@RequiredArgsConstructor
public class BoardServiceImpl implements BoardService{
	@Autowired
	private final BoardDao boardDao;
	@Override
	public int insertBoard(BoardCommon boardCommon, BoardRental boardRental) {
		boardCommon.setProductComment(Utils.XSSHandling(boardCommon.getProductComment()));
		boardCommon.setProductComment(Utils.newLineHandling(boardCommon.getProductComment()));
		boardCommon.setProductName(Utils.XSSHandling(boardCommon.getProductName()));
		
		int result = boardDao.insertBoard(boardCommon, boardRental);
		
		if(result == 0) {
			throw new RuntimeException("게시글 등록 실패");
		}
		return result;
	}

}
