package com.kh.itda.community.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;
import lombok.ToString;


@Data
@ToString(callSuper = true)
public class CommunityReaction extends Community {
//	private int communityNo;	//target_id
	private int reactionNo;	// reaciton_num	//받은 고유번호
    private int userNum;	//reaction_user_num
    private String type; // reaction_type	// 싫어요/좋아요/none
//    private String targetType; // target_type 
    
    
    
//    private String communityCd; // redirect용
    

}