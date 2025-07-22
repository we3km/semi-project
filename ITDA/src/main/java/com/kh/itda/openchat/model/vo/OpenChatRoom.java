package com.kh.itda.openchat.model.vo;



import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class OpenChatRoom {
	private int chatRoomID;
	private String chatName;
	private int chatCount;
	private int maxchatCount;
	private String description;
	private String tagContent;
	private int userNum;
	
	private int fileId;
	private int pathNum;
	
	private String filePath; 
	private String fileName;  
}
    
