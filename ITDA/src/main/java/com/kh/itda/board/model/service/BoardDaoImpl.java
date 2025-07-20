package com.kh.itda.board.model.service;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.stereotype.Repository;

import com.kh.itda.board.model.vo.BoardCommon;
import com.kh.itda.board.model.vo.BoardRental;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Slf4j
@Repository
@RequiredArgsConstructor
public class BoardDaoImpl implements BoardDao {
	private final SqlSessionTemplate session;

	@Override
	public int insertBoard(BoardCommon boardCommon, BoardRental boardRental) {
		int result = 0;
		int commonResult = session.insert("board.insertBoardCommon" , boardCommon);
		int rentalResult = session.insert("board.insertBoardRental" , boardRental);
		
		if(commonResult > 0 && rentalResult > 0) {
			result = 1;
		}
		return result;
	}
	
	
}
