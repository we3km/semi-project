package com.kh.itda.board.model.service;

import java.util.List;

import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;

public interface BoardService {

	int insertBoard(BoardCommon boardCommon, BoardRental boardRental, List<FilePath> pathList, List<File> imgList);

}
