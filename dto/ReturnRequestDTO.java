package com.kim.app.dto;

import java.util.List;

import lombok.Data;

@Data
public class ReturnRequestDTO {
	private List<ReturnItem> returnItems;
	
	@Data
	public static class ReturnItem {
		private Integer bookStkNum;
		private Integer exConditionId;
		private Integer inConditionId;
	}
}
