package com.kim.app.dto;

import java.time.LocalDate;

import lombok.Data;

@Data
public class ReturnTargetDTO {
	private String mid;
	private int rentalNum; 
	private String bookNum;
	private int bookStkNum; 
	private LocalDate rentalDate; 
	private LocalDate returnDueDate; 
	private LocalDate returnedDate;
	private String returnAdminMid;
	private String bookTitle;
	private String bookAuthor; 
	private LocalDate bookRegisterDate;
	private boolean overDue;
	private int overdueDays;
	private int leftOverDueDays;
	private String searchText; //서치내용
	private String searchDate;
	private LocalDate startDate;
	private LocalDate endDate;
	private int exteriorConditionId;
	private int interiorConditionId;
	private String exteriorConditionDisplay;
	private String interiorConditionDisplay;
	
}
