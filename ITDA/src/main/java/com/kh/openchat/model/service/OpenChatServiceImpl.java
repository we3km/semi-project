package com.kh.openchat.model.service;

import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import com.kh.itda.openchat.model.vo.OpenChatRoom;
import com.kh.openchat.model.dao.OpenChatDao;

@Service
public class OpenChatServiceImpl implements OpenChatService {

    @Autowired
    private OpenChatDao openChatDao;

    @Override
    public List<OpenChatRoom> getAllRooms() {
        return openChatDao.findAll();
    }

    @Override
    public int createRoom(OpenChatRoom room) {
        return openChatDao.createRoom(room);
    }

    @Override
    public OpenChatRoom getRoomById(int roomId) {
        return openChatDao.findById(roomId);
    }
}
