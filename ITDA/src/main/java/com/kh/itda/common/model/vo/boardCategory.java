package com.kh.itda.common.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class boardCategory {
	private int categoryId;          // CATEGORY_ID
    private String category;         // 카테고리명 (CATEGORY)
    private String categoryGubun;    // 구분 (rental, share, ...)
}
