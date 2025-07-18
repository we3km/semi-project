package com.kh.itda.openchat.model.service;

import java.util.List;
import com.kh.itda.openchat.model.vo.OpenChatRoom;

public interface OpenChatService {
	List<OpenChatRoom> selectOpenChatRoomList();

	int createOpenChat(OpenChatRoom room);

	
	
}
