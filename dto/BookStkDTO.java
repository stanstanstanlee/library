package com.kim.app.dto;

import lombok.Data;

@Data
public class BookStkDTO {
	private int bookStkNum;
	private String bookNum;
	private boolean rented;
	private boolean disposed;
	private String SearchText;
	private int exteriorConditionId;//외부상태
	private int interiorConditionId;//내부상태
	private String exteriorConditionDisplay;
	private String interiorConditionDisplay;
}
