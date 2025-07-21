package com.kh.itda.openchat.controller;

import java.util.ArrayList;
import java.util.Arrays;
import java.util.List;
import java.util.stream.Collectors;

import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.common.Utils;
import com.kh.itda.openchat.model.service.FileService;
import com.kh.itda.openchat.model.service.OpenChatService;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.openchat.model.vo.openchatImg;
import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/openchat")
@Slf4j
@SessionAttributes({"chatRoomID"})
public class OpenChatController {
	
	@Autowired
	private OpenChatService openChatService;
	
	@GetMapping("/openChatList")
	public String selectOpenChatList(@RequestParam(defaultValue = "1") int page, Model model) {
	    int pageSize = 8;
	    int offset = (page - 1) * pageSize;

	    List<OpenChatRoom> allList = openChatService.selectOpenChatRoomList();
	    int total = allList.size();

	    List<OpenChatRoom> pagedList = allList.stream()
	        .skip(offset)
	        .limit(pageSize)
	        .collect(Collectors.toList());

	    int totalPage = (int) Math.ceil((double) total / pageSize);

	    model.addAttribute("openlist", pagedList);
	    model.addAttribute("currentPage", page);
	    model.addAttribute("totalPage", totalPage);

	    return "openchat/openChatList";
	}
	
	@PostMapping("/createOpenChat")
	public String createChatList(
	    @ModelAttribute OpenChatRoom room,
	    @RequestParam(value = "openImage", required = false) List<MultipartFile> openImages,
	    @RequestParam(value = "tagContent", required = false) String tagContent,
	    RedirectAttributes ra,
	    HttpSession session
	) {
	    log.debug(">> 받은 room(before userNum): {}", room);

	    User u = (User) session.getAttribute("loginUser");
	    if (u == null) {
	        ra.addFlashAttribute("alertMsg", "로그인이 필요합니다.");
	        return "redirect:/member/login";
	    }
	    room.setUserNum(u.getUserNum());

	    // ★ tagContent VO에 저장 (누락되어 있었음)
	    room.setTagContent(tagContent);

	    log.debug(">> 입력된 tagContent: {}", tagContent);
	    log.debug(">> 최종 room(after setUserNum, tagContent): {}", room);

	    List<openchatImg> openimgList = new ArrayList<>();
	    if (openImages != null) {
	        for (MultipartFile openImage : openImages) {
	            if (openImage.isEmpty()) continue;

	            // 채팅방 ID는 아직 없으므로 임시로 "temp" 디렉토리에 저장
	            String tempChatRoomID = "temp";
	            String fileName = Utils.saveOpenChatFile(openImage, session.getServletContext(), tempChatRoomID);

	            openchatImg img = new openchatImg();
	            img.setFileName(fileName);
	            img.setFileAssortment(6); // 오픈채팅 구분 코드
	            img.setRefNo(0); // 나중에 chatRoomID 세팅
	            openimgList.add(img);
	        }
	    }

	    List<String> tags = new ArrayList<>();
	    if (tagContent != null && !tagContent.trim().isEmpty()) {
	        tags = Arrays.stream(tagContent.split(" "))
	                     .map(String::trim)
	                     .filter(tag -> !tag.isEmpty())
	                     .collect(Collectors.toList());
	    }

	    int result = openChatService.createOpenChat(room, openimgList, tags);

	    if (result == 0) {
	        throw new RuntimeException("채팅방 생성 실패");
	    }

	    ra.addFlashAttribute("alertMsg", "채팅방 생성 성공");
	    return "redirect:/openchat/openChatList";
	}

}



