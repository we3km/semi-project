package com.kh.itda.board.model.service;

import java.util.List;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardRental;
import com.kh.itda.common.model.vo.File;
import com.kh.itda.common.model.vo.FilePath;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class BoardDaoImpl implements BoardDao {
	private final SqlSessionTemplate session;

	@Override
	public int insertBoard(BoardCommon boardCommon, BoardRental boardRental, List<FilePath> pathList, List<File> imgList) {
		int result = 0;
		int commonResult = session.insert("board.insertBoardCommon" , boardCommon);
		
		boardRental.setBoardId(boardCommon.getBoardId());
		
		int rentalResult = session.insert("board.insertBoardRental" , boardRental);
		
		if(!pathList.isEmpty()) {
			for(int i = 0; i < imgList.size();i++) {
				FilePath fp = pathList.get(i);
				File f = imgList.get(i);
				session.insert("board.insertPath", fp);
				f.setPathNum(fp.getPathId());
				f.setRefNo(boardCommon.getBoardId());
				switch(boardCommon.getTransactionCategory()) {
				case "rental":
					f.setFileAssortment(1);
					break;
				case "exchange":
					f.setFileAssortment(2);
					break;
				case "auction":
					f.setFileAssortment(3);
					break;
				case "share":
					f.setFileAssortment(4);
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

	
	
}
