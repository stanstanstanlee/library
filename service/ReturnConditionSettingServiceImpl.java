package com.kim.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kim.app.dao.ReturnConditionSettingDAO;
import com.kim.app.dto.ReturnConditionSettingDTO;

@Service
public class ReturnConditionSettingServiceImpl implements ReturnConditionSettingService{

	@Autowired
	private ReturnConditionSettingDAO rConditionDAO;
	
	public List<ReturnConditionSettingDTO> getExteriorConditionSetting() {
		return rConditionDAO.getExteriorConditionSetting();
	}
	
	public List<ReturnConditionSettingDTO> getInteriorConditionSetting() {
		return rConditionDAO.getInteriorConditionSetting();
	}
	
	public List<ReturnConditionSettingDTO> selectAllSetting() {
		return rConditionDAO.selectAllSetting();
	}
	
	public int updateConditions(List<ReturnConditionSettingDTO> rConditionDTOList) {
		return rConditionDAO.updateConditions(rConditionDTOList);
	}
}
