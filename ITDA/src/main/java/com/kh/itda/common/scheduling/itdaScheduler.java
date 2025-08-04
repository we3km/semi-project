package com.kh.itda.common.scheduling;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Component;

import com.kh.itda.board.model.service.BoardService;

@Component
public class itdaScheduler {

	@Autowired
	private BoardService boardService;
	
	@Scheduled(cron = "*/1 * * * * *")
	public void addBiddingWinner() {
		// 경매가 끝난 게시글 조회
		//  - 지금 날짜를 추출
		//  - 경매 게시글 목록에서 경매 종료날짜가 지난 리스트를 입찰금 현황이랑 조인
		//  - 
		// 최고 입찰금 제시자 추출
		// 낙찰자 테이블에 저장
		System.out.println("낙찰자 스케쥴러 작동");
		//boardService.insertBiddingWinner();
	}
}
