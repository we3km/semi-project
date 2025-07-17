package com.kh.itda.openchat.controller;

import java.util.ArrayList;
import java.util.List;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;

import com.kh.itda.openchat.model.vo.OpenChatRoom;

@Controller
@RequestMapping("/openchat")
public class OpenChatController {

    // 채팅방 목록 페이지
    @GetMapping("/openChatList")
    public String openChatList(Model model) {
        List<OpenChatRoom> roomList = new ArrayList<>();

        // DB 대신 임시 데이터
        for (int i = 1; i <= 5; i++) {
            OpenChatRoom room = new OpenChatRoom();
            room.setRoomId(i);
            room.setTitle("채팅방 " + i);
            room.setTags("#스터디 #자유");
            room.setCurrentMembers(i * 2);
            room.setMaxMembers(10);
            roomList.add(room);
        }

        model.addAttribute("roomList", roomList);
        return "openchat/openChatList";
    }

    // 채팅방 입장
    @GetMapping("/room/{roomId}")
    public String enterChatRoom(@PathVariable int roomId, Model model) {
        // DB 대신 임시 데이터
        OpenChatRoom room = new OpenChatRoom();
        room.setRoomId(roomId);
        room.setTitle("채팅방 " + roomId);
        model.addAttribute("room", room);
        return "openchat/openchat";
    }
}
