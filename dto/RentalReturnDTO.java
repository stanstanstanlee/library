package com.kim.app.dto;

import lombok.Data;

@Data
public class RentalReturnDTO {
	private Integer exConditionId;
	private Integer inConditionId;
	private String adminMid;
	private Integer bookStkNum;
}
