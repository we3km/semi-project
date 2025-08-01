package com.kh.itda.chat.controller;

import java.io.File;
import java.net.http.HttpClient.Redirect;
import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.Authentication;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;
import org.springframework.web.multipart.MultipartFile;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kh.itda.chat.model.service.ChatService;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.SelectBoardInfo;
import com.kh.itda.user.model.vo.User;

import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/chat")
@Slf4j
@SessionAttributes({ "chatRoomNo" }) // model 영역에 추가하는 key값이 chatRoomNo인 데이터를 HttpSession에 저장
public class ChatController {
	@Autowired
	private ChatService chatService;

	@GetMapping("/chatRoomList")
	public String selectChatRoomList(Model model, Authentication authentication) {
		User loginUser = (User) authentication.getPrincipal();
		int userNum = loginUser.getUserNum();
		log.info("로그인한 회원정보 아이디 : {}", userNum);
		List<ChatRoom> chatRoomList = chatService.selectChatRoomList(userNum);
		model.addAttribute("chatRoomList", chatRoomList);
		model.addAttribute("loginUser", loginUser);
		if (chatRoomList.isEmpty()) {
			log.info("참여 중인 채팅방이 없습니다.");
		} else {
			log.info("채팅방 리스트 : {}", chatRoomList);
		}
		return "chat/chatRoomList"; // /WEB-INF/views/chat/chatRoomList.jsp
	}

	// 게시판 정보 불러오기
	@GetMapping("/selectBoardInfo")
	@ResponseBody
	public SelectBoardInfo selectBoardInfo(
			@RequestParam("boardId") int boardId,
			Authentication authentication,
			Model model,
			RedirectAttributes ra
			) {
		
		//세션에서 로그인 유저 정보 가져오기
		User loginUser = (User) authentication.getPrincipal();
		if(loginUser == null) {
			ra.addFlashAttribute("msg", "로그인 후 이용 가능합니다.");
			return null;
		}
		
		SelectBoardInfo boardInfo=chatService.selectBoardInfo(boardId);
		System.out.println("boardInfo 반환 객체: " + boardInfo);
		return boardInfo;
	}

	// 게시물 정보 받아와서 채팅방 생성
	@PostMapping("/openChatRoom")
	@ResponseBody
	public String openChatRoom(@RequestBody SelectBoardInfo boardInfo, Authentication authentication) {
		// 현재 로그인한 회원 정보 받아옴
		User loginUser = (User) authentication.getPrincipal();
		int userNum = loginUser.getUserNum();
		log.info("로그인한 회원정보 : {}", loginUser);
		int refNum = boardInfo.getTransactionRefNum();
		log.info("거래 유형 번호 : {}", refNum);
		int boardId = boardInfo.getBoardId();
		log.info("게시판 번호 : {}", boardId);
		int result = chatService.openChatRoom(userNum, refNum, boardId);
		if (result > 0) {
			log.info("채팅방 성공! : {}", result);
		}
		log.info("생성된 채팅방 정보 : {}", boardInfo);
		return "/chat/chatroomlist";
	}

	// 메세지 받아와서 채팅방 오른쪽에 출력하자이
	@GetMapping("/messages/{chatRoomId}")
	@ResponseBody // JSP에서 데이터만 받겠다
	public List<ChatMessage> getMessages(@PathVariable int chatRoomId) {
		return chatService.getMessagesByChatRoomId(chatRoomId);
	}

	// 채팅방 나가기 -> 단순히 나가는 것이기 때문에 채팅방의 STATUS값만 바꿔줌
	@PostMapping("/exit/{chatRoomId}")
	@ResponseBody
	public void exitChatRoom(@PathVariable int chatRoomId) {
		int result = chatService.exitChatRoom(chatRoomId);
		if (result > 0) {
			log.info(chatRoomId + "번 채팅방 STATUS N으로 변경 완료");
		} else {
			log.info(chatRoomId + "번 채팅방 STATUS N으로 변경 실패ㅠㅠ");
		}
	}

	// 게시물 정보 번호 맞춰서 revieweeUserNum 할당해주자!!!!!!!!!!!
	@PostMapping("/insertManner")
	@ResponseBody
	// 매너 평가자, 매너 평가 받는 사람, 매너 점수(int), 후기 내용(String)
	public void insertManner(@RequestBody Map<String, Object> data, Authentication authentication) {
		User loginUser = (User) authentication.getPrincipal();
		int userNum = loginUser.getUserNum();
		Integer mannerScore = (int) data.get("sliderValue");
		String reviewText = (String) data.get("reviewText");
		int boardId = (int) data.get("boardId");
		int reviewerUserNum = userNum; // 리뷰하는 사람, 로그인한 회원
		int revieweeUserNum = (int) data.get("userNum"); // 리뷰받는 사람
		log.info("매너 평가 하는 사람 : {}", reviewerUserNum);
		Map<String, Object> map = new HashMap<>();
		map.put("reviewText", reviewText);
		map.put("mannerScore", mannerScore);
		map.put("boardId", boardId);
		map.put("reviewerUserNum", reviewerUserNum);
		map.put("revieweeUserNum", revieweeUserNum);
		int result = chatService.insertManner(map);
		if (result > 0) {
			log.info("후기 등록 성공!!");
		} else {
			log.info("후기 등록 실패!!");
		}
	}

	// 각 채팅방 마다 메세지 마지막메세지 가져오기
	@GetMapping("/bringLastMessage")
	@ResponseBody
	public Map<String, Object> bringLastMessage(int chatRoomId, HttpServletResponse res) {
		String text = chatService.bringLastMessage(chatRoomId);
		Map<String, Object> map = new HashMap<String, Object>();
		map.put("lastMessage", text);
		return map;
	}

	// 서버에 사진 파일 저장하자
	@PostMapping("/uploadImageMessage")
	@ResponseBody
	public Map<String, Object> uploadImageMessage(@RequestParam("image") MultipartFile image,
			@RequestParam("chatRoomId") int chatRoomId, HttpServletRequest request, Authentication authentication) {
		User loginUser = (User) authentication.getPrincipal();
		int userNum = loginUser.getUserNum();
		Map<String, Object> result = new HashMap<>();
		try {
			// 파일 저장 경로 설정
			String savePath = request.getServletContext().getRealPath("/resources/images/chattingImg/");
			File dir = new File(savePath);
			if (!dir.exists())
				dir.mkdirs();
			// 파일명 중복 방지를 위한 UUID
			String originalFilename = image.getOriginalFilename();
			String ext = originalFilename.substring(originalFilename.lastIndexOf("."));
			String renamedFilename = UUID.randomUUID().toString() + ext;
			// 서버 직접 저장
			File dest = new File(savePath + renamedFilename);
			image.transferTo(dest);
			String chatImgUrl = "/resources/images/chattingImg/" + renamedFilename;
			// ChatMessage 새로운 객체 구성 -> 이미지 파일도 메세지로 치부
			ChatMessage chatMessage = new ChatMessage();
			chatMessage.setChatRoomId(chatRoomId);
			chatMessage.setChatContent("");
			chatMessage.setUserNum(userNum);
			chatMessage.setChatImg(chatImgUrl);
			int insertResult = chatService.sendMessage(chatMessage);
			result.put("success", insertResult > 0);
			result.put("chatMessage", chatMessage);
			// 메세지 자체를 리턴 (이미지의 경우, chatContent : null, chatImg : 사진 경로
			log.info("이미지 파일 : {}", chatMessage);
			log.info("저장될 파일 전체 경로 : {}", savePath);
		} catch (Exception e) {
			e.printStackTrace();
			result.put("success", false);
		}
		return result;
	}
}