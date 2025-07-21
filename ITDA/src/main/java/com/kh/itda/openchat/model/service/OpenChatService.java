package com.kh.itda.openchat.model.service;

import java.util.List;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.openchat.model.vo.openchatImg;

public interface OpenChatService {
	List<OpenChatRoom> selectOpenChatRoomList();

	int createOpenChat(OpenChatRoom room, List<openchatImg> openimgList, List<String> tags);
	
}
