package com.kim.app.service;

import java.util.List;

import com.kim.app.dto.ReturnConditionSettingDTO;

public interface ReturnConditionSettingService {
	List<ReturnConditionSettingDTO> getExteriorConditionSetting();
	List<ReturnConditionSettingDTO> getInteriorConditionSetting();
	public List<ReturnConditionSettingDTO> selectAllSetting();
	public int updateConditions(List<ReturnConditionSettingDTO> rConditionDTOList);
}
