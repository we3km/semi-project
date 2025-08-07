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

import com.kh.itda.alarm.model.service.AlarmService;
import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.BoardComment;
import com.kh.itda.common.model.vo.BoardCommentExt;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.common.model.vo.template.Pagination;
import com.kh.itda.community.model.service.CommunityService;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityExt;
import com.kh.itda.community.model.vo.CommunityImg;
import com.kh.itda.community.model.vo.CommunityReaction;
import com.kh.itda.community.model.vo.CommunityType;
import com.kh.itda.security.model.vo.UserExt;
import com.kh.itda.support.model.vo.Report;
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
	
	private final AlarmService alarmService;

	// communityType 전역객체 설정
	@PostConstruct
	public void init() {
		// key=value, COMMUNITY_CODE=community_name
		// all= 전체 , w = 운동, a = 문화/예술, g = 취미/오락, p = 반려동물, f = 동네친구 , s = 자기계발/스터디, h = 공포
		Map<String, CommunityType> communityTypeMap = communityService.getCommunityTypeMap();
		application.setAttribute("communityTypeMap", communityTypeMap);
		log.info("communityTypeMap:{}", communityTypeMap);
	}
	
	
	


	// 게시판 목록 서비스 communityList
	@GetMapping("/list/{communityCode}")
	public String selectList(@PathVariable("communityCode") String communityCode,
            @RequestParam(value = "currentPage", defaultValue = "1") int currentPage,
            @RequestParam Map<String, Object> paramMap, @RequestParam(value="category", required=false) List<String> cat, Model model) {
		// 기본 로직
		// 1. 페이징 처리
		// 1) 현재 요청한 게시판 코드 및 검색정보와 일치하는 게시글의 총 갯수를 조회
		// 2) 개시글 갯수, 페이지 번호, 기본 파라미터들을 추가하여 페이징정보*(PageInfo)객체를 생성
		// 2. 현재 요청한 게시판코드와 일치하면서, 현재 페이지에 해당하는게시글정보를 조회
		// 3. 게시글 목록페이지로 게시글 정보, 페이징 정보, 검색정보를 담아서 forward
		
		paramMap.put("category", cat);
		paramMap.put("communityCode", communityCode);
		

	    int listCount = communityService.selectListCount(paramMap);
	    PageInfo pi = Pagination.getPagInfo(listCount, currentPage, 10, 10);
	    List<Community> list = communityService.selectList(pi, paramMap);
	    
	    // 1. 기본 URL 생성 (contextPath는 JSP에서 처리하므로 여기서는 제외)
	    String url = "community/list/" + communityCode + "?currentPage=";

	    // 2. 검색/필터 조건을 담을 문자열 생성
	    StringBuilder searchParamBuilder = new StringBuilder();
	    for (Map.Entry<String, Object> entry : paramMap.entrySet()) {
	        String key = entry.getKey();
	        // 페이지 번호와 카테고리 코드는 기본 URL에 이미 있으므로 제외
	        if (!key.equals("currentPage") && !key.equals("communityCode")) {
	            searchParamBuilder.append("&").append(key).append("=").append(entry.getValue());
	        }
	    }
	    String searchParam = searchParamBuilder.toString();

	    model.addAttribute("list", list);
	    model.addAttribute("pi", pi);
	    model.addAttribute("param", paramMap);
	    model.addAttribute("communityCode", communityCode);
	    model.addAttribute("selectedCategories", cat);
	    model.addAttribute("url", url);
	    model.addAttribute("searchParam", searchParam);

	    return "community/communityList";

	}

	// 게시판 등록폼 이동 서비스
	@GetMapping("/insert")
	public String enrollForm(
			@ModelAttribute("c") CommunityExt c, /* @PathVariable("communityCode") String communityCode, */
			Model model) {
//		Map<String, CommunityType> communityTypeMap = communityService.getCommunityTypeMap();
//	    model.addAttribute("communityTypeMap", communityTypeMap);
		model.addAttribute("c", c);
		return "community/communityWrite";
	}

	// 게시판 등록기능
	@PostMapping("/insert")
	public String insertCommunity(
								@ModelAttribute Community c, /*@PathVariable("communityCode") String communityCode,*/
								Authentication auth,
								/* Model model, */ RedirectAttributes ra,
								@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles
								) {
		if (upfiles != null && upfiles.size() > 5) {
	        ra.addFlashAttribute("alertMsg", "이미지는 최대 5개까지 첨부할 수 있습니다.");
	        return "redirect:/community/insert"; // 글쓰기 폼으로 다시 돌려보냄
	    }
		
		List<CommunityImg> imgList = new ArrayList<>();
		int level = 0; // 첨부파일의 레벨
		
		// 0 = 썸네일, 0이 아닌 값들은 썸네일이 아닌 기타 파일들
		for (MultipartFile upfile : upfiles) {
			if (upfile.isEmpty()) {
				continue;
			}
			// 첨부파일이 존재한다면 WEB서버상에 첨부파일 저장
			// 첨부파일 관리를 위해 DB에 첨부파일의 위치정보를 저장
			String folderName = "community/"+c.getCommunityCd();
			String changeName = Utils.saveFileToCategoryFolder(upfile, application,folderName );
			CommunityImg ci = new CommunityImg();
			ci.setChangeName(changeName);
			ci.setOriginName(upfile.getOriginalFilename());
			ci.setImgLevel(level++);
			imgList.add(ci); // 연관게시글번호 refCno값 추가 필요

		}
		
		//로그인 사용자 정보 등록
		UserExt loginUser = (UserExt) auth.getPrincipal();
		c.setCommunityWriter(loginUser.getUserNum());
		
		c.setCommunityNickname(String.valueOf(1));
		c.setWriteDate(new Date());
		/* c.setCommunityCd(communityCode); */

		
		// 정보체크
		log.debug("community : {}", c);		
		log.debug("imgList : {}", imgList);
		
		int result = communityService.insertCommunity(c, imgList);
		
		// 게시글 등록 결과에 따른 페이지 지정

		if (result == 0) {
			throw new RuntimeException("게시글 작성 실패");
		}
		
		ra.addFlashAttribute("alertMsg", "게시글 작성 성공");
		
		return "redirect:/community/list/all";
	}
	
	//게시판 상세보기
	@GetMapping("/detail/{communityCd}/{communityNo}")
	public String selectCommunity(
								@PathVariable("communityCd") String communityCd,
								@PathVariable("communityNo") int communityNo,
								Authentication auth,
								Model model,
								//@CookieValue(value="readCommunityNo", required = false) String readCommunityNoCookie,
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
		
		//유져관련		
		int userNum = ((UserExt) auth.getPrincipal()).getUserNum();
		//int userNum = 3;
	    

		// 1. 본인 글이 아닐 경우에만 조회수 증가 로직 실행
	    if (userNum != c.getCommunityWriter()) {
	        
	        // 2. 현재 사용자에 맞는 쿠키 이름 생성 (예: "readCommunityNo_1")
	        String cookieName = "readCommunityNo_" + userNum;
	        String readCommunityNoCookie = null; // 쿠키 값을 담을 변수

	        // 3. request에 담겨온 모든 쿠키를 확인
	        Cookie[] cookies = req.getCookies();
	        if (cookies != null) {
	            for (Cookie cookie : cookies) {
	                // 4. 내가 찾던 이름의 쿠키가 있는지 확인
	                if (cookie.getName().equals(cookieName)) {
	                    readCommunityNoCookie = cookie.getValue();
	                    break; // 찾았으면 반복 중단
	                }
	            }
	        }

	        boolean increase = false; // 조회수 증가 여부
	        
	        // 5. 사용자별 쿠키가 없거나, 쿠키는 있지만 현재 게시글 번호가 포함되지 않은 경우
	        if (readCommunityNoCookie == null) {
	            increase = true;
	            readCommunityNoCookie = String.valueOf(communityNo);
	        } else {
	            if (!Arrays.asList(readCommunityNoCookie.split("/")).contains(String.valueOf(communityNo))) {
	                increase = true;
	                readCommunityNoCookie += "/" + communityNo;
	            }
	        }

	        // 6. 조회수를 증가시켜야 할 경우 DB 업데이트 및 새 쿠키 생성
	        if (increase) {
	            int result = communityService.increaseCount(communityNo);
	            if (result > 0) {
	                c.setViews(c.getViews() + 1);
	                
	                Cookie newCookie = new Cookie(cookieName, readCommunityNoCookie);
	                newCookie.setPath("/");
	                newCookie.setMaxAge(60 * 60 * 24); // 1일
	                res.addCookie(newCookie);
	            }
	        }
	    }
	    
	    
		 // 현재 유저가 해당 게시글에 대해 좋아요/싫어요 한 상태 조회
		CommunityReaction reaction = communityService.userReactionNo(userNum, communityNo);

		String userReaction = "NONE"; 
	    if(reaction != null && reaction.getType() != null) {
	        userReaction = reaction.getType(); // "LIKE" 또는 "DISLIKE" 등
	    }
	   
		model.addAttribute("community", c);
		model.addAttribute("reactionForm", new CommunityReaction());
		model.addAttribute("userReaction", userReaction);
		model.addAttribute("communityCd", communityCd); 
		model.addAttribute("report", new Report());
		
		return "community/communityDetail"; 
	}
	
	@PostMapping("/react")
	@ResponseBody
	public Map<String, Object> react(@RequestBody CommunityReaction reaction,Authentication auth, HttpSession session) {
		
		int userNum = ((UserExt) auth.getPrincipal()).getUserNum();
	    
	    
	    reaction.setUserNum(userNum);

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
	
	//게시글 삭제
	@PostMapping("/delete")
	public String deleteCommunity( int communityNo,
									Authentication auth,
									RedirectAttributes ra) {
		//로그인 유저정보
		UserExt loginUser = (UserExt)auth.getPrincipal();
		int userNum = loginUser.getUserNum();
		
		//삭제 시도
		int result = communityService.deleteCommunity(communityNo, userNum);
		
		//결과
		if(result>0) {
			ra.addFlashAttribute("alertMsg","게시글이 성공적으로 삭제되었습니다.");
		 } else {
	        ra.addFlashAttribute("alertMsg", "게시글 삭제에 실패했습니다. (권한이 없거나 존재하지 않는 게시글)");
	     }

		return "redirect:/community/list/all";
	}
	
	//게시글 수정
	@GetMapping("/update/{communityNo}")
	public String updateForm(
							@PathVariable("communityNo") int communityNo,
							Model model
							) {
		CommunityExt community = communityService.selectCommunity(communityNo);
		
		community.setCommunityContent(Utils.newLineClear(community.getCommunityContent()));
		
		model.addAttribute("c",community);
		
		return "community/communityWrite";
	}
	
	//게시글 수정 반영
	@PostMapping("/update")
	public String updateCommunity(
									@ModelAttribute("c") CommunityExt c,
									@RequestParam(value = "upfile", required = false) List<MultipartFile> upfiles,
									@RequestParam(value="deleteImgNos", required=false) List<Integer> deleteImgNos,
									RedirectAttributes ra
								) {
		
		
		
	    // 1. DB에서 현재 게시글의 이미지 정보를 가져옴
	    CommunityExt originalCommunity = communityService.selectCommunity(c.getCommunityNo());
	    int existingImgCount = originalCommunity.getImgList().size();
	    
	    // 2. 삭제될 이미지 개수를 반영
	    int deleteCount = (deleteImgNos != null) ? deleteImgNos.size() : 0;
	    
	    // 3. 새로 추가될 이미지 개수를 반영
	    int newImgCount = (upfiles != null && !upfiles.get(0).isEmpty()) ? upfiles.size() : 0;
	    
	    // 4. 최종 개수 계산 및 검사
	    if (existingImgCount - deleteCount + newImgCount > 5) {
	        ra.addFlashAttribute("alertMsg", "이미지는 최대 5개까지 첨부할 수 있습니다.");
	        return "redirect:/community/update/" + c.getCommunityNo(); // 수정 폼으로 다시 돌려보냄
	    }
	   

	    System.out.println("### [디버깅] updateCommunity 메소드 시작. 전달받은 communityNo: " + c.getCommunityNo());
	   
		List<CommunityImg> imgList = new ArrayList<>();
		if(upfiles != null) {
			for (MultipartFile upfile : upfiles) {
				if (upfile != null && !upfile.isEmpty()) {
					// 파일을 서버에 저장하고, CommunityImg 객체로 만들어 리스트에 추가
					String folderName = "community/" + c.getCommunityCd();
					String changeName = Utils.saveFileToCategoryFolder(upfile, application, folderName);
					
					CommunityImg ci = new CommunityImg();
					ci.setChangeName(changeName);
					ci.setOriginName(upfile.getOriginalFilename());
					// 이미지 레벨이나 참조 게시글 번호는 서비스에서 설정
					imgList.add(ci);
				}
			}
		}
		
		int result = communityService.updateCommunity(c, imgList, deleteImgNos);
		
		if(result > 0) {
			ra.addFlashAttribute("alertMsg","게시글이 성공적으로 수정되었습니다.");
		}else {
			ra.addFlashAttribute("alertMsg","게시글 수정에 실패했습니다.");
		}
		return "redirect:/community/detail/" + c.getCommunityCd() + "/" + c.getCommunityNo();
	}
	
	// 댓글 목록 조회 (AJAX) - Service에서 계층형으로 처리된 데이터를 반환
	@GetMapping(value="/comments/{communityNo}", produces="application/json; charset=UTF-8")
	@ResponseBody
	public List<BoardCommentExt> ajaxSelectCommentList( @PathVariable("communityNo") int communityNo,
														@RequestParam(value="sort", defaultValue="asc") String sort
													  ) {
		System.out.println("정렬 : "+ sort +" communityNo : " + communityNo);
	    return communityService.selectCommentList(communityNo, sort);
	}

	 //댓글 등록 (AJAX)
		@PostMapping(value="/comments", produces="application/json; charset=UTF-8")
		@ResponseBody
		public Map<String, String> ajaxInsertComment(
		        @RequestBody BoardComment comment, 
		        Authentication auth) {
		    UserExt loginUser = (UserExt) auth.getPrincipal();
		    comment.setCmtWriterUserNum(loginUser.getUserNum());

		    int result = communityService.insertComment(comment);

		    Map<String, String> response = new HashMap<>();
		    if (result > 0) {
		        // 1) 게시글 정보 조회
		        CommunityExt c = communityService.selectCommunity(comment.getRefNo());
		        
		        System.out.println("게시글 작성자: " + c.getCommunityWriter());
		        System.out.println("현재 로그인 유저: " + loginUser.getUserNum());

		        // 2) 작성자와 내가 다르면 알림 전송
		        if (c != null && loginUser.getUserNum() != c.getCommunityWriter()) {
		            alarmService.sendBoardCommentAlarm(
		                c.getCommunityWriter(),
		                c.getCommunityNo(),
		                c.getCommunityTitle(),
		                c.getCommunityCd(),
		                loginUser.getNickName()
		            );
		        }
		      
		        response.put("result", "success");
		    } else {
		        response.put("result", "fail");
		    }
		    return response;
		}
	
	// 댓글 삭제 (AJAX)
	@PostMapping(value="/comments/delete", produces="application/json; charset=UTF-8")
	@ResponseBody
	public Map<String, Object> ajaxDeleteComment(@RequestBody BoardComment comment, Authentication auth) {
	    
	    // 임시 유저 정보 (로그인 연동 후 Authentication 객체에서 가져옵니다)
		UserExt loginUser = (UserExt) auth.getPrincipal();
	    comment.setCmtWriterUserNum(loginUser.getUserNum());
	    int userNum = ((UserExt) auth.getPrincipal()).getUserNum();
	    
	    int result = communityService.deleteComment(comment.getBoardCmtId(), userNum);
	    
	    Map<String, Object> response = new HashMap<>();
	    if (result > 0) {
	        response.put("result", "success");
	    } else {
	        response.put("result", "fail");
	        response.put("message", "댓글을 삭제할 권한이 없습니다.");
	    }
	    return response;
	}

	

}
