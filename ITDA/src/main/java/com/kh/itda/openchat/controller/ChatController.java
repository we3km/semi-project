package com.kh.itda.openchat.controller;

import org.springframework.messaging.handler.annotation.DestinationVariable;
import org.springframework.messaging.handler.annotation.MessageMapping;
import org.springframework.messaging.handler.annotation.SendTo;
import org.springframework.stereotype.Controller;

import com.kh.itda.openchat.model.vo.ChatMessage;

@Controller
public class ChatController {

    @MessageMapping("/chat/{roomId}")
    @SendTo("/topic/chat/{roomId}")
    public ChatMessage handleMessage(@DestinationVariable String roomId, ChatMessage message) {
        return message;  // 그대로 브로드캐스트
    }
}