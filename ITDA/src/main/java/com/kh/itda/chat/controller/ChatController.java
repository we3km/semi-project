package com.kh.itda.chat.controller;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import javax.servlet.http.HttpServletResponse;
import javax.servlet.http.HttpSession;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.bind.annotation.SessionAttributes;

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

	@GetMapping("/chatroomlist")
	public String selectChatRoomList(Model model, HttpSession session) {

		User loginUser = (User) session.getAttribute("loginUser");

		if (loginUser == null) {
			log.info("담긴 회원정보가 없습니다.");
		}

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
	public SelectBoardInfo selectBoardInfo(int boardId) {
		SelectBoardInfo boardInfo = chatService.selectBoardInfo(boardId);

		System.out.println("boardInfo: " + boardInfo);
		return boardInfo;
	}

	// 게시물 정보 받아와서 채팅방 생성
	@PostMapping("/openChatRoom")
	@ResponseBody
	public String openChatRoom(@RequestBody SelectBoardInfo boardInfo, HttpSession session) {
		// 현재 로그인한 회원 정보 받아옴
		User loginUser = (User) session.getAttribute("loginUser");
		if (loginUser == null) {
			log.info("로그인 유저 없음");
		}

		int userNum = loginUser.getUserNum();
		log.info("로그인한 회원정보 아이디 : {}", userNum);

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

	/*
	 * @PostMapping("/sendMessage")
	 * 
	 * @ResponseBody // CHATROOM_ID, CHAT_CONTENT, USER_NUM public ChatMessage
	 * sendMessage(@RequestBody Map<String, Object> messageMap, HttpSession session)
	 * { User loginUser = (User) session.getAttribute("loginUser"); if (loginUser ==
	 * null) { log.info("로그인 유저 없음"); }
	 * 
	 * 
	 * System.out.println("loginUser: " + loginUser);
	 * System.out.println("messageMap: " + messageMap);
	 * 
	 * 
	 * String chatContent = (String) messageMap.get("chatContent"); String
	 * chatRoomIdStr = (String) messageMap.get("chatRoomId"); int chatRoomId =
	 * Integer.parseInt(chatRoomIdStr);
	 * 
	 * 
	 * System.out.println("chatContent: " + chatContent);
	 * System.out.println("chatRoomId: " + chatRoomId);
	 * 
	 * 
	 * // 채팅방 번호, 채팅 내용, 로그인한 회원 번호 할당 ChatMessage chatMessage = new ChatMessage();
	 * 
	 * chatMessage.setChatRoomId(chatRoomId);
	 * chatMessage.setChatContent(chatContent);
	 * chatMessage.setUserNum(loginUser.getUserNum());
	 * 
	 * log.info("채팅방 정보 : {}", chatMessage);
	 * 
	 * int result = chatService.sendMessage(chatMessage);
	 * 
	 * if (result > 0) { log.info("채팅 정보 : {}", result); return chatMessage; } else
	 * { log.info("채팅 보내기 실패"); throw new RuntimeException("채팅 저장 실패"); } }
	 */

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

	@PostMapping("/insertManner")
	@ResponseBody
	// 매너 평가자, 매너 평가 받는 사람, 매너 점수(int), 후기 내용(String)
	public void insertManner(@RequestBody Map<String, Object> data, HttpSession session) {
		User loginUser = (User) session.getAttribute("loginUser");

		Integer mannerScore = (int) data.get("sliderValue");
		String reviewText = (String) data.get("reviewText");
		int boardId = (int) data.get("boardId");
		int reviewerUserNum = loginUser.getUserNum(); // 리뷰하는 사람
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
}
