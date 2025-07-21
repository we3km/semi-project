package com.kh.itda.community.controller;

import java.util.ArrayList;
import java.util.List;
import java.util.Map;

import javax.annotation.PostConstruct;
import javax.servlet.ServletContext;

import org.springframework.core.io.ResourceLoader;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.common.Utils;
import com.kh.itda.common.model.vo.PageInfo;
import com.kh.itda.common.model.vo.template.Pagination;
import com.kh.itda.community.model.service.CommunityService;
import com.kh.itda.community.model.vo.Community;
import com.kh.itda.community.model.vo.CommunityImg;
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
	public String enrollForm(@ModelAttribute Community c, @PathVariable("coummunityCode") String coummunityCode,
			Model model) {
		model.addAttribute("c", c);
		return "community/communityEnrollForm";
	}

	// 게시판 등록기능
	@PostMapping("/insert/{communityCode}")
	public String insertCommunity(
								@ModelAttribute Community c, @PathVariable("communityCode") String communityCode,
								Authentication auth, Model model, RedirectAttributes ra,
								/*
								 * List<MultipartFile> - multipartFile - multipart/form-data방식으로 전송된 파일데이터를
								 * 바인딩해주는 클래스 - 파일의 이름, 크기, 존재, 저장기능 다양한 메서드 제공 - name속성값이 upfile으로 전달되는 모든 파일
								 * 파람을 하나의 컬렉션으로 모아오기위해 선언 - @RequestParam + List/Map 사용시 바인딩할 데이터가 없더라도 항상 객체
								 * 자체는 생성된다.
								 */
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
			imgList.add(ci); // 연관게시글번호 refBno값 추가 필요

		}
		User loginUser = (User) auth.getPrincipal();
		c.setCommunityWriter(String.valueOf(loginUser.getUserNo()));
		c.setCommunityCd(communityCode);

		// 정보체크
		log.debug("board : {}", c);
		log.debug("imgList : {}", imgList);
		int result = communityService.insertCommunity(c, imgList);

		// 게시글 등록 결과에 따른 페이지 지정

		if (result == 0) {
			throw new RuntimeException("게시글 작성 실패");
		}

		ra.addFlashAttribute("alertMsg", "게시글 작성 성공");

		return "redirect:/community/list/" + communityCode;
	}

}
