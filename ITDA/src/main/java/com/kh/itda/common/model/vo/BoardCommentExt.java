package com.kh.itda.common.model.vo;

import java.util.ArrayList;
import java.util.List;

import lombok.Data;
import lombok.ToString;

@Data
@ToString(callSuper = true)
public class BoardCommentExt extends BoardComment{
	private List<BoardCommentExt> replies = new ArrayList<>();
	
	public long getCmtWriteDateTimestamp() {
        if (getCmtWriteDate() != null) {
            return getCmtWriteDate().getTime();
        }
        return 0;
    }

}
