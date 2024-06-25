package com.kim.app.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;
import org.apache.ibatis.annotations.Param;

import com.kim.app.dto.MemberDTO;

@Mapper
public interface MemberDAO {
	public List<MemberDTO> selectAll();
	
	public MemberDTO selectOne(Map<String, String> map);
	
	public MemberDTO getMemberByIdAndPwd(MemberDTO mDTO);
	
	public MemberDTO getMemberById(MemberDTO mDTO);
	
	public MemberDTO getMemberByIdSearch(String member);
	
	public List<MemberDTO> getMemberByIdOrName(String member);
	
	public String getPwById(String mid);
	
	public Integer getCurRentalCntByMid(String mid);
	

	
//	public boolean insert(Map<String, String> map);
	public boolean insert(MemberDTO mDTO);
	
	public boolean update(Map<String, String> map);
	public boolean updateCurrentRentalCount(MemberDTO mDTO);
	public boolean updateOverdue(MemberDTO mDTO);
	
	public boolean delete(@Param("MID")String mid);
	
	public boolean updateMember(MemberDTO mDTO);
}
