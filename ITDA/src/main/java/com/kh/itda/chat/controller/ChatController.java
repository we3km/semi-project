package com.kh.itda.chat.controller;

import java.io.File;
import java.util.HashMap;
import java.util.List;
import java.util.Map;
import java.util.UUID;

import javax.servlet.http.HttpServletRequest;
import javax.servlet.http.HttpServletResponse;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.messaging.simp.SimpMessagingTemplate;
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

import com.kh.itda.chat.model.service.ChatService;
import com.kh.itda.chat.model.vo.BidWinner;
import com.kh.itda.chat.model.vo.ChatMessage;
import com.kh.itda.chat.model.vo.ChatRoom;
import com.kh.itda.chat.model.vo.SelectBoardInfo;
import com.kh.itda.security.model.vo.UserExt;

import com.kh.itda.support.model.vo.Report;
import com.kh.itda.user.model.vo.User;
import lombok.extern.slf4j.Slf4j;

@Controller
@RequestMapping("/chat")
@Slf4j
@SessionAttributes({ "chatRoomNo" }) // model 영역에 추가하는 key값이 chatRoomNo인 데이터를 HttpSession에 저장
public class ChatController {

	@Autowired
	private ChatService chatService;
	private SimpMessagingTemplate messagingTemplate;

	// 로그인 한 회원이 접속중인 채팅방 보여줌
	@GetMapping("/chatRoomList")
	public String selectChatRoomList(Model model, Authentication authentication) {


        UserExt loginUser = (UserExt) authentication.getPrincipal();
		int userNum = loginUser.getUserNum();
		log.info("로그인한 회원정보 아이디 : {}", userNum);

		List<ChatRoom> chatRoomList = chatService.selectChatRoomList(userNum);
		model.addAttribute("chatRoomList", chatRoomList);
		// 신고 속성 model에 넣어줌
		model.addAttribute("report", new Report());
		
		if (chatRoomList.isEmpty()) {
			log.info("참여 중인 채팅방이 없습니다.");
		} else {
			log.info("채팅방 리스트 : {}", chatRoomList);
		}
		return "chat/chatRoomList";
	}
	
	// 현재 로그인한 회원 번호 보내서 회원 정보 가져오기
	@GetMapping("/getSenderInfo")
	@ResponseBody
	public Map<String, Object> getSenderInfo(int userNum, Authentication authentication) {
		// 챗 메세지 객체로 정보 할당
		User senderInfo = chatService.getSenderInfo(userNum);

		Map<String, Object> map = new HashMap<String, Object>();
		
		map.put("nickName", senderInfo.getNickName());
		map.put("imageUrl", senderInfo.getImageUrl());
		
		return map;
	}

	// 거래 채팅!!하고 있는 상대방 프로필 가져오기
	@GetMapping("/selectOpponentProfile")
	@ResponseBody
	public Map<String, Object> selectOpponentProfile(int chatRoomId, Authentication authentication) {
		// chatRoom 객체로 정보 할당
		UserExt loginUser = (UserExt) authentication.getPrincipal();
		int userNum = loginUser.getUserNum();

		Map<String, Object> opps = new HashMap<String, Object>();
		opps.put("chatRoomId", chatRoomId);
		opps.put("userNum", userNum);

		// 현재 로그인한 회원정보와 다른 상대 정보 가져오자
		ChatRoom opponentProfile = chatService.selectOpponentProfile(opps);

		Map<String, Object> map = new HashMap<String, Object>();
		map.put("nickName", opponentProfile.getNickName());
		map.put("imageUrl", opponentProfile.getImageUrl());
		map.put("opponentUserNum", opponentProfile.getUserNum());

		log.info("상대 프로필 정보 : {}", map);
		return map;
	}

	// 게시판 정보 불러오기
	@GetMapping("/selectBoardInfo")
	@ResponseBody
	public SelectBoardInfo selectBoardInfo(int boardId) {
		SelectBoardInfo boardInfo = chatService.selectBoardInfo(boardId);
		return boardInfo;
	}

	// 경매 낙찰자 정보 따오기
	@GetMapping("/getBiddingWinner")
	@ResponseBody
	public BidWinner getBiddingWinner(int boardId) {
		BidWinner bidWinner = chatService.getBiddingWinner(boardId);
		return bidWinner;
	}
	
	// 게시물 정보 받아와서 채팅방 생성
	@PostMapping("/openChatRoom")
	@ResponseBody
	public String openChatRoom(@RequestBody SelectBoardInfo boardInfo, Authentication authentication) {
		// 현재 로그인한 회원 정보 받아옴
		UserExt loginUser = (UserExt) authentication.getPrincipal();

		// 로그인한 회원 정보와, 게시물 주인 정보 번호 받아서 채팅방 생성 정보 할당
		int userNum = loginUser.getUserNum();
		int boardOwnerNum = boardInfo.getUserNum();
		int refNum = boardInfo.getTransactionRefNum();
		int boardId = boardInfo.getBoardId();

		log.info("채팅방 속성 :", boardInfo);
		
		int result = chatService.openChatRoom(userNum, boardOwnerNum, refNum, boardId);

		if (result > 0) {
			log.info("채팅방 성공! : {}", result);
			log.info("생성된 채팅방 정보 : {}", boardInfo);
		}
		return "success";
	}
	
	// 경매 채팅방 생성 
	@PostMapping("/openBidChatRoom")
	@ResponseBody
	public String openBidChatRoom(@RequestBody SelectBoardInfo boardInfo, Authentication authentication) {
		// 현재 로그인한 회원 정보 받아옴
		UserExt loginUser = (UserExt) authentication.getPrincipal();

		BidWinner bidWinner = chatService.getBiddingWinner(boardInfo.getBoardId());
		
		// boardOwnerNum에 경매 우승자 번호 넣어주자
		int userNum = loginUser.getUserNum();
		int bidWinnerNum = bidWinner.getUserNum();
		int refNum = boardInfo.getTransactionRefNum();
		int boardId = boardInfo.getBoardId();

		log.info("채팅방 속성 :", boardInfo);
		
		int result = chatService.openChatRoom(userNum, bidWinnerNum, refNum, boardId);

		if (result > 0) {
			log.info("채팅방 성공! : {}", result);
			log.info("생성된 채팅방 정보 : {}", boardInfo);
		}
		return "success";
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
	public void exitChatRoom(@PathVariable int chatRoomId, Authentication authentication) {
		UserExt loginUser = (UserExt) authentication.getPrincipal();
		String nickName = loginUser.getNickName();

		Map<String, Object> exit = new HashMap<String, Object>();
		exit.put("chatRoomId", chatRoomId);
		exit.put("userNum", loginUser.getUserNum());
		
		int result = chatService.exitChatRoom(exit);

		log.info("나가는 사람 이름 : {}", nickName);
		if (result > 0) {
			log.info(chatRoomId + "번 채팅방 STATUS N으로 변경 완료");

			// 퇴장 메세지 전송
			ChatMessage systemMsg = new ChatMessage();
			systemMsg.setChatRoomId(chatRoomId);
			systemMsg.setChatContent(nickName + "님이 채팅방을 나갔습니다.");
			systemMsg.setUserNum(0); // 시스템 메시지라면 userNum 0으로 처리 나 ENUM없음

			// 시스템 메세지 DB에 저장
			chatService.sendMessage(systemMsg);

			messagingTemplate.convertAndSend("/topic/room/" + chatRoomId, systemMsg);
		} else {
			log.info(chatRoomId + "번 채팅방 STATUS N으로 변경 실패ㅠㅠ");
		}
	}

	// 게시물 정보 번호 맞춰서 revieweeUserNum 할당해주자!!!!!!!!!!!
	@PostMapping("/insertManner")
	@ResponseBody
	// 매너 평가자, 매너 평가 받는 사람, 매너 점수(int), 후기 내용(String)
	public void insertManner(@RequestBody Map<String, Object> data, Authentication authentication) {
		UserExt loginUser = (UserExt) authentication.getPrincipal();

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
	public ChatMessage bringLastMessage(int chatRoomId, HttpServletResponse res) {
		ChatMessage lastMessage = chatService.bringLastMessage(chatRoomId);
		
		return lastMessage;
	}

	// 서버에 사진 파일 저장하자
	@PostMapping("/uploadImageMessage")
	@ResponseBody
	public Map<String, Object> uploadImageMessage(@RequestParam("image") MultipartFile image,
			@RequestParam("chatRoomId") int chatRoomId, HttpServletRequest request, Authentication authentication) {

		UserExt loginUser = (UserExt) authentication.getPrincipal();
		int userNum = loginUser.getUserNum();

		Map<String, Object> result = new HashMap<>();
		try {
			// 파일 저장 경로 설정
			String savePath = request.getServletContext().getRealPath("/resources/images/chattingImg/");
			File dir = new File(savePath);
			if (!dir.exists())
				dir.mkdirs();

			// 파일명 중복 방지하자
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
			
			// 로그인 정보 넘겨서 채팅메세지에 할당해주자			
			User u = chatService.getSenderInfo(userNum);
			chatMessage.setNickName(u.getNickName());
			chatMessage.setImageUrl(u.getImageUrl());

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
