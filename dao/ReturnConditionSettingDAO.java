package com.kim.app.dao;

import java.util.List;

import org.apache.ibatis.annotations.Mapper;

import com.kim.app.dto.ReturnConditionSettingDTO;

@Mapper
public interface ReturnConditionSettingDAO {

	public List<ReturnConditionSettingDTO> getExteriorConditionSetting();
	
	public List<ReturnConditionSettingDTO> getInteriorConditionSetting();
	
	public List<ReturnConditionSettingDTO> selectAllSetting();
	
	public int updateConditions(List<ReturnConditionSettingDTO> rConditionDTOList);
}
