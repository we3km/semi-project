package com.kh.itda.openchat.model.dao;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.kh.itda.openchat.model.vo.OpenChatRoom;

@Repository
public class OpenChatDao {
	
	@Autowired SqlSessionTemplate session;

	public List<OpenChatRoom> selectOpenChatRoomList() {
		return session.selectList("openchat.selectOpenChatRoomList") ;
	}

	public int createOpenChat() {
		return session.insert("openchat.createOpenChat");
	}

}

