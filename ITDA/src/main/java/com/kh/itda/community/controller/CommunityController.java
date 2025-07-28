package com.kh.itda.community.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Date;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;
import javax.servlet.http.Cookie;
import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.CookieValue;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.common.model.vo.template.Pagination;
import com.kh.itda.community.model.service.CommunityService;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityExt;
import com.kh.itda.community.model.vo.CommunityImg;
import com.kh.itda.community.model.vo.CommunityReaction;
import com.kh.itda.user.model.vo.User;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequiredArgsConstructor
@RequestMapping("/community")
@Slf4j
public class CommunityController {

	private final CommunityService communityService;

	// ServletContext : application scope를 가진 서블릿 전역에서 사용가능한 객체
	private final ServletContext application;

	// ResourceLoader : 스프링에서 제공하는 자원 로딩클래스
	// classpath, file시스템, url등 다양한 경로의 자원을 동일한 인터페이스로 로드하는 메서드를 제공
	private final ResourceLoader resourceLoader;

	// communityType 전역객체 설정
	@PostConstruct
	public void init() {
		// key=value, COMMUNITY_CODE=community_name
		// all= 전체 , w = 운동, a = 문화/예술, g = 취미/오락, p = 반려동물, f = 동네친구 , s = 자기계발/스터디, h = 공포
		Map<String, String> communityTypeMap = communityService.getCommunityTypeMap();
		application.setAttribute("communityTypeMap", communityTypeMap);
		log.info("communityTypeMap:{}", communityTypeMap);
	}
	
	
	


	// 게시판 목록 서비스 communityList
	@GetMapping("/list/{communityCode}")
	public String selectList(@PathVariable("communityCode") String communityCode,
			// communityCode로 동적인 모든 커뮤니티 코드값 저장
			@RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
			// 클라이언트가 요청시 전달한 파라미터의 key,value을 Map형태로 만들어서 대입
			@RequestParam Map<String, Object> paramMap, Model model) {
		// 기본 로직
		// 1. 페이징 처리
		// 1) 현재 요청한 게시판 코드 및 검색정보와 일치하는 게시글의 총 갯수를 조회
		// 2) 개시글 갯수, 페이지 번호, 기본 파라미터들을 추가하여 페이징정보*(PageInfo)객체를 생성
		// 2. 현재 요청한 게시판코드와 일치하면서, 현재 페이지에 해당하는게시글정보를 조회
		// 3. 게시글 목록페이지로 게시글 정보, 페이징 정보, 검색정보를 담아서 forward

		paramMap.put("communityCode", communityCode); // 검색 조건 + 커뮤니티 코드

		int listCount = communityService.selectListCount(paramMap);
		int pageLimit = 10;
		int communityLimit = 10;

		// 페이지 정보 생성 템플릿을 이용하여 PageInfo생성
		PageInfo pi = Pagination.getPagInfo(listCount, currentPage, pageLimit, communityLimit);

		List<Community> list = communityService.selectList(pi, paramMap);

		model.addAttribute("list", list);
		model.addAttribute("pi", pi);
		model.addAttribute("param", paramMap);

		return "community/communityList";

	}

	// 게시판 등록폼 이동 서비스
	@GetMapping("/insert/{communityCode}")
	public String enrollForm(@ModelAttribute Community c, @PathVariable("communityCode") String communityCode,
			Model model) {
		Map<String, String> communityTypeMap = communityService.getCommunityTypeMap();
	    model.addAttribute("communityTypeMap", communityTypeMap);
		model.addAttribute("c", c);
		return "community/communityWrite";
	}

	// 게시판 등록기능
	@PostMapping("/insert/{communityCode}")
	public String insertCommunity(
								@ModelAttribute Community c, @PathVariable("communityCode") String communityCode,
								Authentication auth, Model model, RedirectAttributes ra,
								@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles
								) {
		
		List<CommunityImg> imgList = new ArrayList<>();
		int level = 0; // 첨부파일의 레벨
		// 0 = 썸네일, 0이 아닌 값들은 썸네일이 아닌 기타 파일들
		for (MultipartFile upfile : upfiles) {
			if (upfile.isEmpty()) {
				continue;
			}
			// 첨부파일이 존재한다면 WEB서버상에 첨부파일 저장
			// 첨부파일 관리를 위해 DB에 첨부파일의 위치정보를 저장
			String changeName = Utils.saveFile(upfile, application, communityCode);
			CommunityImg ci = new CommunityImg();
			ci.setChangeName(changeName);
			ci.setOriginName(upfile.getOriginalFilename());
			ci.setImgLevel(level++);
			imgList.add(ci); // 연관게시글번호 refCno값 추가 필요

		}
		
		//로그인 사용자 정보 등록
//		User loginUser = (User) auth.getPrincipal();
		
		
//		c.setCommunityWriter(String.valueOf(loginUser.getUserNo()));
		c.setCommunityWriter(1);
		
		c.setCommunityNickname(String.valueOf(1));
		c.setWriteDate(new Date());
		c.setCommunityCd(communityCode);

		
		// 정보체크
		log.debug("community : {}", c);		
		log.debug("imgList : {}", imgList);
		int result = communityService.insertCommunity(c, imgList);
		
		// 게시글 등록 결과에 따른 페이지 지정

		if (result == 0) {
			throw new RuntimeException("게시글 작성 실패");
		}
		
		ra.addFlashAttribute("alertMsg", "게시글 작성 성공");
		System.out.println(c);
		return "redirect:/community/list/" + communityCode;
	}
	
	//게시판 상세보기
	@GetMapping("/detail/{communityCd}/{communityNo}")
	public String selectCommunity(
								@PathVariable("communityCd") String communityCode,
								@PathVariable("communityNo") int communityNo,
								Authentication auth,
								Model model,
								@CookieValue(value="readCommunityNo", required = false) String readCommunityNoCookie,
								HttpServletRequest req,
								HttpServletResponse res
							 ) {
		  
		/*
		 * 업무로직
		 *  1. boardNo를 기반으로 게시판 정보 조회
		 *  2. 조회수 증가 서비스 호출
		 *  3. 게시판 정보를 model영역에 담은 후 forward
		 * */
		
		// 게시글 정보를 조회
		// 게시글 정보에 사용자의 이름, 첨부파일 목록을 추가로 담아서 반환하기위해 communityExt사용
		CommunityExt c = communityService.selectCommunity(communityNo); 		
		if(c == null) {
			throw new RuntimeException("게시글이 존재하지 않습니다.");
			
		}
		
		//	============================= 시큐리티 이후에 사용=========
		//유져관련
//		int userNo = ((User) auth.getPrincipal()).getUserNo();
		int userNo = 1;
		System.out.println("===== 최종 userReaction 확인 =====");
	    System.out.println("c 객체: " + c);
	    
		
				
		if(userNo != c.getCommunityWriter()) {
			boolean increase = false;	//조회수 증가를 위한 체크변수
			
			// readCommunityNo라는 이름의 쿠키가 있는지 조사
			if(readCommunityNoCookie == null) {
				//첫 조회
				increase = true;
				readCommunityNoCookie = String.valueOf(communityNo);
			}else {
				//쿠키가 있는 경우
				List<String> list = Arrays.asList(readCommunityNoCookie.split("/"));
				// 기존 쿠키값들 중 게시글 번호화 일치하는 값이 하나도 없는 경우
				if(!list.contains(String.valueOf(communityNo))) {
					increase = true;
					readCommunityNoCookie = readCommunityNoCookie.trim() + "/" + communityNo;
				}
			}
			if(increase) {
				int result = communityService.increaseCount(communityNo);
				if(result > 0) {
					c.setViews(c.getViews() + 1);
					
					// 새 쿠키 생성하여 클라이언트에게 전달
					Cookie newCookie = new Cookie("readCommunityNo",readCommunityNoCookie);
					newCookie.setPath("/"); 
					newCookie.setMaxAge(1 * 60 * 60);	//1시간
					res.addCookie(newCookie);
					
				}
			}
		}
		 // 현재 유저가 해당 게시글에 대해 좋아요/싫어요 한 상태 조회
		CommunityReaction reaction = communityService.userReactionNo(userNo, communityNo);

		String userReaction = "NONE"; // 기본값 ========================얘가문제야야ㅣ아ㅓ이ㅏ어;이ㅑ어ㅣㅏ너
	    if(reaction != null && reaction.getType() != null) {
	        userReaction = reaction.getType(); // "LIKE" 또는 "DISLIKE" 등
	    }
	    //로그확인
	    System.out.println(">>> userNo: " + userNo);
	    System.out.println(">>> communityNo: " + communityNo);

	    System.out.println("===== 최종 userReaction 확인 =====");
	    System.out.println("reaction 객체: " + reaction);
	    System.out.println("reaction.getType(): " + (reaction != null ? reaction.getType() : "reaction is null"));
	    System.out.println("userReaction: " + userReaction);
		
		model.addAttribute("community", c);
		model.addAttribute("reactionForm", new CommunityReaction());
		model.addAttribute("userReaction", userReaction);
		model.addAttribute("communityCd", communityCode); 
		
		return "community/communityDetail"; 
	}
	
	@PostMapping("/react")
	@ResponseBody
	public Map<String, Object> react(@RequestBody CommunityReaction reaction, HttpSession session) {
		// 임시 로그인 유저 번호 
	    int userNo = 1;
	//  int userNo = ((User) session.getAttribute("loginUser")).getUserNo();
	    
	    reaction.setUserNo(userNo);

	    // 서비스 호출 → 반응 처리
	    String userReaction = communityService.handleReaction(reaction);

	    // 좋아요/싫어요 카운트 다시 조회
	    int likeCount = communityService.getLikeCount(reaction.getCommunityNo());
	    int dislikeCount = communityService.getDislikeCount(reaction.getCommunityNo());

	    Map<String, Object> map = new HashMap<>();
	    map.put("userReaction", userReaction); // 최종 상태
	    map.put("likeCount", likeCount);
	    map.put("dislikeCount", dislikeCount);

	    return map;
	}

	

}

