package com.kh.itda.board.model.service;

import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardRental;

public interface BoardService {

	int insertBoard(BoardCommon boardCommon, BoardRental boardRental);

}
