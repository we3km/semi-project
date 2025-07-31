package com.kh.itda.location.model.vo;

import com.kh.itda.openchat.model.vo.OpenChatRoom;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class Location {
	 private Long locationId;
	 private String sido;
	 private String sigungu;
	 private Double lat;
	 private Double lng;
}
