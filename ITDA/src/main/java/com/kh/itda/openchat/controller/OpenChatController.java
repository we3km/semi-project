package com.kh.itda.openchat.controller;
import java.util.ArrayList;
import java.util.Arrays;
import java.util.Collections;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.stream.Collectors;
import javax.servlet.http.HttpServletRequest;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
import org.springframework.security.core.Authentication;
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
import com.kh.itda.chat.model.service.ChatService;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.location.model.vo.Location;
import com.kh.itda.location.service.locationService;
import com.kh.itda.openchat.model.service.OpenChatService;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.user.model.vo.User;
import lombok.extern.slf4j.Slf4j;
@Controller
@RequestMapping("/openchat")
@Slf4j
@SessionAttributes({ "chatRoomID" })
public class OpenChatController {
	@Autowired
	private locationService locationService;
	@Autowired
	private OpenChatService openChatService;
	@Autowired
	private ChatService chatService;
	private SimpMessagingTemplate messagingTemplate;
	@GetMapping("/openChatList")
	public String selectOpenChatList(@RequestParam(required = false) String sido,
			@RequestParam(required = false) String sigun, @RequestParam(required = false) String gu,
			@RequestParam(required = false) String keyword, @RequestParam(defaultValue = "1") int page, Model model) {
		// ——— 시·도 리스트 준비 ———
		List<String> sidoList = locationService.findAllSido();
		model.addAttribute("sidoList", sidoList);
		model.addAttribute("selectedSido", sido == null ? "" : sido);
		// —── 시·군 리스트 준비 —──
		List<String> sigunList = locationService.findSigunListBySido(sido);
		if (sigunList != null && sigunList.size() == 1 && sigunList.get(0).equals(sigun)) {
			// 사실상 구만 있는 경우로 판단
			sigunList = Collections.emptyList();
		}
		model.addAttribute("sigunList", sigunList);
		model.addAttribute("selectedSigun", sigun != null ? sigun : gu != null ? gu : "");
		// —── 구 리스트 준비 —──
		List<String> guList = null;
		if (sigunList == null || sigunList.isEmpty()) {
			// 시 바로 아래 구가 있는 경우
			guList = locationService.findGuListBySidoIfDirect(sido);
		} else if (sigun != null && !sigun.isEmpty()) {
			// 일반적인 시/군 → 구 구조
			guList = locationService.findGuListBySigun(sido, sigun);
		}
		model.addAttribute("guList", guList);
		model.addAttribute("selectedGu", gu != null ? gu : "");
		// ── sigunguList 관련 전부 삭제됨
		// ——— 검색 키워드 유지 ———
		model.addAttribute("keyword", keyword == null ? "" : keyword);
		// ——— selectedSigungu 조합 후 한 번만 등록 ———
		String selectedSigungu = "";
		if (gu != null && !gu.isEmpty()) {
			if (sigun != null && !sigun.isEmpty()) {
				selectedSigungu = sigun + " " + gu; // 예: 수원시 권선구
			} else {
				selectedSigungu = gu; // 예: 서초구
			}
		} else if (sigun != null && !sigun.isEmpty()) {
			selectedSigungu = sigun;
		}
		model.addAttribute("selectedSigungu", selectedSigungu);
		String selectedSigun = "";
		if (sigun != null && !sigun.isEmpty()) {
			selectedSigun = sigun; // 서울 서초구 선택 시 → 서초구
		} else if (gu != null && !gu.isEmpty()) {
			selectedSigun = gu; //
		}
		model.addAttribute("selectedSigun", selectedSigun);
		// —── 조회 파라미터 맵에 모두 담기 —──
		Map<String, Object> params = new HashMap<>();
		params.put("sido", sido);
		params.put("sigun", sigun);
		params.put("gu", gu);
		params.put("sigungu", selectedSigungu);
		params.put("keyword", keyword);
		// ——— 필터 적용된 전체 리스트 조회 ———
		List<OpenChatRoom> allList = openChatService.selectOpenChatRoomList(params);
		// ——— 페이징 처리 ———
		int pageSize = 8;
		int pageLimit = 10;
		int offset = (page - 1) * pageSize;
		int total = allList.size();
		int totalPage = (int) Math.ceil((double) total / pageSize);
		int startPage = ((page - 1) / pageLimit) * pageLimit + 1;
		int endPage = Math.min(startPage + pageLimit - 1, totalPage);
		List<OpenChatRoom> pagedList = allList.stream().skip(offset).limit(pageSize).collect(Collectors.toList());
		model.addAttribute("openlist", pagedList);
		model.addAttribute("currentPage", page);
		model.addAttribute("totalPage", totalPage);
		model.addAttribute("startPage", startPage);
		model.addAttribute("endPage", endPage);
		model.addAttribute("listCount", total);
		return "openchat/openChatList";
	}
	@PostMapping("/createOpenChat")
	public String createChatList(@ModelAttribute OpenChatRoom room, @ModelAttribute Location loc,
			@RequestParam(value = "openImage", required = false) List<MultipartFile> openImages,
			@RequestParam(value = "tagContent", required = false) String tagContent, RedirectAttributes ra,
			HttpServletRequest request, Authentication authentication) {
		User u = (User) authentication.getPrincipal();
		if (u == null) {
			ra.addFlashAttribute("alertMsg", "로그인이 필요합니다.");
			return "redirect:/member/login";
		}
		room.setUserNum(u.getUserNum());
		room.setTagContent(tagContent);
		// 위치 저장
		log.debug("▶︎ loc.sido = {}, loc.sigungu = {}", loc.getSido(), loc.getSigungu());
		Long locId = locationService.findOrCreate(loc.getSido(), loc.getSigungu());
		room.setLocationId(locId);
		List<String> tags = tagContent != null
				? Arrays.stream(tagContent.split("[\\s,#]+")).map(t -> t.replaceAll("^#+", ""))
						.filter(t -> !t.isEmpty()).collect(Collectors.toList())
				: new ArrayList<>();
		int result = openChatService.createOpenChat(room, openImages, tags, request.getServletContext());
		if (result == 0)
			throw new RuntimeException("채팅방 생성 실패");
		ra.addFlashAttribute("alertMsg", "채팅방 생성 성공");
		return "redirect:/openchat/openChatList";
	}
	// 김성겸 => 채팅방 입장 시스템 메세지 삽입
	@GetMapping("/enter")
	public String enterChatRoom(@RequestParam("roomId") int roomId, Authentication authentication, Model model,
			RedirectAttributes ra) {
		// 세션에서 로그인 유저 정보 가져오기
		User loginUser = (User) authentication.getPrincipal();
		if (loginUser == null) {
			ra.addFlashAttribute("msg", "로그인 후 이용 가능합니다.");
			return "redirect:/";
		}
		int userNum = loginUser.getUserNum();
		// 채팅방 참여 처리
		OpenChatRoom room = openChatService.joinChatRoom(roomId, userNum);
		if (room == null) {
			ra.addFlashAttribute("msg", "입장할 수 없는 채팅방입니다.");
			return "redirect:/openchat/openChatList";
		}
		
		// ========================입장 성공 시 채팅방 정보 전달
		String nickName = loginUser.getNickName();
		log.info("입장하는 사람 이름 : {}", nickName);
		// 입장 메세지 전송용 객체
		ChatMessage systemMsg = new ChatMessage();
		systemMsg.setChatRoomId(roomId);
		systemMsg.setChatContent(nickName + "님이 채팅방을 입장했습니다.");
		systemMsg.setUserNum(0); // 시스템 메시지라면 userNum 0으로 처리
		// 시스템 메세지 DB에 저장
		chatService.sendMessage(systemMsg);
		messagingTemplate.convertAndSend("/topic/room/" + roomId, systemMsg);
		// ========================
		
		model.addAttribute("chatRoom", room);
		return "redirect:/chat/chatRoomList"; // → /WEB-INF/views/chat/chatroomList.jsp
	}
}