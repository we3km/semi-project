package com.kh.itda.openchat.model.vo;



import com.kh.itda.location.model.vo.Location;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class OpenChatRoom {
	private int chatRoomID;
	private String chatName;
	private int chatCount;
	private int maxchatCount;
	private String explanation;
	private String tagContent;
	private int userNum;
	
	private int fileId;
	private String fileName;
	
	private long locationId;
	private Location location;
	
	private String sido;
    private String sigungu;
	
}
    
