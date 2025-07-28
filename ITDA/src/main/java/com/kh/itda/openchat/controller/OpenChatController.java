package com.kh.itda.openchat.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.User;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.location.model.vo.Location;
import com.kh.itda.location.service.locationService;
import com.kh.itda.openchat.model.service.OpenChatService;
import com.kh.itda.openchat.model.vo.OpenChatRoom;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/openchat")
@Slf4j
@SessionAttributes({"chatRoomID"})
public class OpenChatController {
	
	 @Autowired
	    private locationService locationService;
	
	@Autowired
	private OpenChatService openChatService;

	@GetMapping("/openChatList")
	public String selectOpenChatList(
	        @RequestParam(required = false) String sido,
	        @RequestParam(required = false) String sigungu,
	        @RequestParam(required = false) String keyword,
	        @RequestParam(defaultValue = "1") int page,
	        Model model) {

	    // ——— 기존 시·도 / 시·군·구 셋업 ———
	    List<String> sidoList = locationService.findAllSido();
	    model.addAttribute("sidoList", sidoList);
	    model.addAttribute("selectedSido", sido == null ? "" : sido);

	    List<String> sigunguList = Collections.emptyList();
	    if (sido != null && !sido.isEmpty()) {
	        sigunguList = locationService.findSigunguBySido(sido);
	    }
	    model.addAttribute("sigunguList", sigunguList);
	    model.addAttribute("selectedSigungu", sigungu == null ? "" : sigungu);
	    
	    model.addAttribute("keyword", keyword == null ? "" : keyword);

	    Map<String, Object> params = new HashMap<>();
	    params.put("sido",    sido);
	    params.put("sigungu", sigungu);
	    params.put("keyword", keyword);

	    // ——— 필터 적용된 전체 리스트 조회 ———
	    List<OpenChatRoom> allList = openChatService.selectOpenChatRoomList(params);

	    int pageSize  = 8;
	    int pageLimit = 10;
	    int offset    = (page - 1) * pageSize;
	    int total     = allList.size();
	    int totalPage = (int) Math.ceil((double) total / pageSize);
	    int startPage = ((page - 1) / pageLimit) * pageLimit + 1;
	    int endPage   = Math.min(startPage + pageLimit - 1, totalPage);

	    List<OpenChatRoom> pagedList = allList.stream()
	        .skip(offset)
	        .limit(pageSize)
	        .collect(Collectors.toList());

	    model.addAttribute("openlist",     pagedList);
	    model.addAttribute("currentPage",  page);
	    model.addAttribute("totalPage",    totalPage);
	    model.addAttribute("startPage",    startPage);
	    model.addAttribute("endPage",      endPage);
	    model.addAttribute("listCount",    total);

	    return "openchat/openChatList";
	}

	@PostMapping("/createOpenChat")
	public String createChatList(
	    @ModelAttribute OpenChatRoom room,
	    @ModelAttribute Location loc,              
	    @RequestParam(value = "openImage", required = false) List<MultipartFile> openImages,
	    @RequestParam(value = "tagContent", required = false) String tagContent,
	    RedirectAttributes ra,
	    //로그인되면 수정해야함
	    HttpSession session
	) {
	    User u = (User) session.getAttribute("loginUser");
	    if (u == null) {
	        ra.addFlashAttribute("alertMsg", "로그인이 필요합니다.");
	        return "redirect:/member/login";
	    }

		/*
		 * room.setUserNum(u.getUsername()); room.setTagContent(tagContent);
		 */

	    
	    log.debug("▶︎ loc.sido = {}, loc.sigungu = {}", loc.getSido(), loc.getSigungu());
	    // loc.getSido(), loc.getSigungu() 에 이미 값 바인딩됨
	    Long locId = locationService.findOrCreate(loc.getSido(), loc.getSigungu());
	    room.setLocationId(locId);

	    List<String> tags = tagContent != null
	        ? Arrays.stream(tagContent.split(" "))
	                .map(String::trim)
	                .filter(t -> !t.isEmpty())
	                .collect(Collectors.toList())
	        : new ArrayList<>();

	    int result = openChatService.createOpenChat(room, openImages, tags, session.getServletContext());
	    if (result == 0) throw new RuntimeException("채팅방 생성 실패");

	    ra.addFlashAttribute("alertMsg", "채팅방 생성 성공");
	    return "redirect:/openchat/openChatList";
	}
	
}



