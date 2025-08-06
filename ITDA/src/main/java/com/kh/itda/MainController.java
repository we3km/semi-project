package com.kh.itda;

import java.util.Map;

import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;


import com.kh.itda.board.model.service.BoardService;

import com.kh.itda.common.model.vo.boardCategory;
import com.kh.itda.common.service.MainService;
import com.kh.itda.community.model.service.CommunityService;


import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@Slf4j
public class MainController {
	private final MainService mainService;

	private final CommunityService communityService; // CommunityService 주입
	private final BoardService boardService;
	
	@RequestMapping(value = "/", method = RequestMethod.GET)
	public String home(Model model,Authentication auth) {
		// 거래유형 목록 드롭다운
		//if(((User)auth.getPrincipal()).getUserId()!=null)
			//log.info("user info : {}",((User)auth.getPrincipal()).getPhone());
		
		Map<Integer, boardCategory> mainTypeMap = mainService.getMainTypeMap();
	     model.addAttribute("mainCategoryType", mainTypeMap);
	     
	    //상품유형 목록 (categoryId 6~9일 때 사용)
	    System.out.println( boardService.getProductType());
        model.addAttribute("productCategories", boardService.getProductType());
        
        //커뮤니티 타입 목록 (categoryId 10일 때 사용)
        model.addAttribute("communityTypes", communityService.getCommunityTypeMap());
	       
        
		
		  // 로그인한 사용자 ID
		  //System.out.println((User) auth.getPrincipal());
		 
		return "main";
	}
	
	
}


