package com.kim.app.dto;

import lombok.Data;

@Data
public class ReturnConditionSettingDTO {
	private int exteriorConditionId;//외부상태
	private int interiorConditionId;//내부상태
	private String exteriorConditionDisplay;
	private String interiorConditionDisplay;
}
