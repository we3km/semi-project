package com.kh.itda.board.model.vo;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class ProductCategory {
	private int productCategoryNum;
	private String categoryName;
	private int categoryTier;
	private int parentNum;
	
	
}
