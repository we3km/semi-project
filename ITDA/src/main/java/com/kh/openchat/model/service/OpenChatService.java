package com.kh.openchat.model.service;

import java.util.List;
import com.kh.itda.openchat.model.vo.OpenChatRoom;

public interface OpenChatService {
    List<OpenChatRoom> getAllRooms();
    int createRoom(OpenChatRoom room);
    OpenChatRoom getRoomById(int roomId);
}
