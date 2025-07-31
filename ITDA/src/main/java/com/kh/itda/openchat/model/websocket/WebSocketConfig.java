package com.kh.itda.openchat.model.websocket;

import org.springframework.context.annotation.Configuration;
import org.springframework.messaging.simp.config.MessageBrokerRegistry;
import org.springframework.web.socket.config.annotation.EnableWebSocketMessageBroker;
import org.springframework.web.socket.config.annotation.StompEndpointRegistry;
import org.springframework.web.socket.config.annotation.WebSocketMessageBrokerConfigurer;

@Configuration
@EnableWebSocketMessageBroker
public class WebSocketConfig implements WebSocketMessageBrokerConfigurer {

    @Override
    public void registerStompEndpoints(StompEndpointRegistry registry) {
        // contextPath가 있을 경우 /itda/ws 로 클라이언트가 접근해야 함
        registry.addEndpoint("/ws")  
                .setAllowedOriginPatterns("*")
                .withSockJS();  // SockJS 사용 시 꼭 붙이기
    }

    @Override
    public void configureMessageBroker(MessageBrokerRegistry config) {
        config.enableSimpleBroker("/topic");  // 구독 주소
        config.setApplicationDestinationPrefixes("/app");  // 메시지 보낼 때
    }
}
