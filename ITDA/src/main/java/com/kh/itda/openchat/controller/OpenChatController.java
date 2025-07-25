package com.kh.itda.openchat.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
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

import com.kh.itda.common.Utils;
import com.kh.itda.location.model.vo.Location;
import com.kh.itda.location.service.locationService;
import com.kh.itda.openchat.model.service.FileService;
import com.kh.itda.openchat.model.service.OpenChatService;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.openchat.model.vo.OpenChatImg;
import com.kh.itda.user.model.vo.User;

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
	public String selectOpenChatList(@RequestParam(defaultValue = "1") int page, Model model) {
	    int pageSize = 8;
	    int pageLimit = 5;  // 하단에 보여줄 페이지 수
	    int offset = (page - 1) * pageSize;

	    List<OpenChatRoom> allList = openChatService.selectOpenChatRoomList();
	    int total = allList.size();
	    int totalPage = (int) Math.ceil((double) total / pageSize);

	    // 페이지 리스트 계산
	    int startPage = ((page - 1) / pageLimit) * pageLimit + 1;
	    int endPage = startPage + pageLimit - 1;
	    if (endPage > totalPage) endPage = totalPage;

	    List<OpenChatRoom> pagedList = allList.stream()
	        .skip(offset)
	        .limit(pageSize)
	        .collect(Collectors.toList());

	    model.addAttribute("openlist", pagedList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPage", totalPage);
	    model.addAttribute("startPage", startPage);
	    model.addAttribute("endPage", endPage);
	    model.addAttribute("listCount", total);

	    return "openchat/openChatList";
	}

	@PostMapping("/createOpenChat")
	public String createChatList(
	    @ModelAttribute OpenChatRoom room,
	    @ModelAttribute Location loc,               // 여기로 이미 들어와 있음
	    @RequestParam(value = "openImage", required = false) List<MultipartFile> openImages,
	    @RequestParam(value = "tagContent", required = false) String tagContent,
	    RedirectAttributes ra,
	    HttpSession session
	) {
	    User u = (User) session.getAttribute("loginUser");
	    if (u == null) {
	        ra.addFlashAttribute("alertMsg", "로그인이 필요합니다.");
	        return "redirect:/member/login";
	    }

	    room.setUserNum(u.getUserNum());
	    room.setTagContent(tagContent);

	    
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



