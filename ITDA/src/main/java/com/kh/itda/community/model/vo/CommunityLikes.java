package com.kh.itda.community.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class CommunityLikes {
	private int reactionNum;         // REACTION_NUM (PK)
    private int reactionUserNum;     // REACTION_USER_NUM 
    private String targetType;       // TARGET_TYPE 
    private int targetId;            // TARGET_ID 
    private String reactionType;     // REACTION_TYPE

}
