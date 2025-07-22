package com.kh.itda.openchat.model.service;

import java.util.List;

import javax.servlet.ServletContext;

import org.springframework.web.multipart.MultipartFile;

import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.itda.openchat.model.vo.openchatImg;

public interface OpenChatService {
	List<OpenChatRoom> selectOpenChatRoomList();


	int createOpenChat(OpenChatRoom room, List<MultipartFile> openImages, List<String> tags,
			ServletContext servletContext);
	
}
