package com.kh.itda.openchat.model.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.transaction.annotation.Transactional;

import com.kh.itda.openchat.model.dao.OpenChatDao;
import com.kh.itda.openchat.model.vo.OpenChatRoom;

@Service
public class OpenChatServiceImpl implements OpenChatService {
	
	@Autowired
	private OpenChatDao dao;
	
	@Override
	public List<OpenChatRoom> selectOpenChatRoomList() {
		
		return dao.selectOpenChatRoomList();
	}

	@Override
	public int createOpenChat(OpenChatRoom room) {
		return dao.createOpenChat();
	}

	
}