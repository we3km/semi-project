package com.kh.openchat.model.dao;

import java.util.List;
import com.kh.itda.openchat.model.vo.OpenChatRoom;

public interface OpenChatDao {
    List<OpenChatRoom> findAll();
    int createRoom(OpenChatRoom room);
    OpenChatRoom findById(int roomId);
}
