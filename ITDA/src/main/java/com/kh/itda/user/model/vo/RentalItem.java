package com.kh.itda.user.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class RentalItem {
	private String productName;	// title
	private String imageUrl;	// imageUrl
	private Date rentalEndDate;	// endDate
	private int leftDays;		// leftDays
}
