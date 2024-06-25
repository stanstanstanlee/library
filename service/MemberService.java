package com.kim.app.service;

import java.util.List;

import com.kim.app.dto.MemberDTO;

public interface MemberService {
	public List<MemberDTO> selectAll();
	public MemberDTO selectOne(MemberDTO mDTO);
	public MemberDTO getMemberByIdAndPwd(MemberDTO mDTO);
	public MemberDTO getMemberById(MemberDTO mDTO);
	public MemberDTO getMemberByIdSearch(String member);
	public List<MemberDTO> getMemberByIdOrName(String member);
	public String getPwById(String mid);
	
	public Integer getCurRentalCntByMid(String mid);
	
	public boolean insert(MemberDTO mDTO);
	
	public boolean update(MemberDTO mDTO);
	public boolean updateCurrentRentalCount(MemberDTO mDTO);
	public boolean updateOverdue(MemberDTO mDTO);
	
	public boolean delete(MemberDTO mDTO);
	
	public boolean updateMember(MemberDTO mDTO);
	
	
}
