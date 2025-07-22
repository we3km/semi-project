package com.kh.itda.board.model.vo;

import java.util.Date;

import lombok.Data;
import lombok.NoArgsConstructor;

@NoArgsConstructor
@Data
public class BoardRental {
	private int boardId;
	private int rentalFee;
	private int deposit;
	private Date rentalStartDate;
	private Date rentalEndDate;
}
