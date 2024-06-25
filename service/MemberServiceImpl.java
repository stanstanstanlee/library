package com.kim.app.service;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kim.app.dao.MemberDAO;
import com.kim.app.dto.MemberDTO;

@Service //컨트롤러한테 꽃혀야 함; Component를 상속받은 Service
public class MemberServiceImpl implements MemberService {
	
	@Autowired
	private MemberDAO mDAO;
	
	@Override
	public List<MemberDTO> selectAll() {
		return mDAO.selectAll();
	}

	@Override
	public MemberDTO selectOne(MemberDTO mDTO) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("MID", mDTO.getMid());
		map.put("MPW", mDTO.getMpw());
//		map.put("sc", mDTO.getSc());
		return mDAO.selectOne(map);
	}
	
	@Override
	public MemberDTO getMemberByIdAndPwd(MemberDTO mDTO) {
		return mDAO.getMemberByIdAndPwd(mDTO);
	}
	
	@Override
	public MemberDTO getMemberById(MemberDTO mDTO) {
		return mDAO.getMemberById(mDTO);
	}
	
	@Override
	public MemberDTO getMemberByIdSearch(String member) {
		return mDAO.getMemberByIdSearch(member);
	}

	@Override
	public List<MemberDTO> getMemberByIdOrName(String member) {
		return mDAO.getMemberByIdOrName(member);
	}
	
	@Override
	public String getPwById(String mid) {
		return mDAO.getPwById(mid);
	}
	
	@Override
	public Integer getCurRentalCntByMid(String mid) {
		return mDAO.getCurRentalCntByMid(mid);
	}
	
	@Override
	public boolean insert(MemberDTO mDTO) {
//		Map<String, String> map = new HashMap<String, String>();
//		map.put("MID", mDTO.getMid());
//		map.put("MPW", mDTO.getMpw());
//		return mDAO.insert(map);
		return mDAO.insert(mDTO);
	}

	@Override
	public boolean update(MemberDTO mDTO) {
		Map<String, String> map = new HashMap<String, String>();
		map.put("MID", mDTO.getMid());
		map.put("MPW", mDTO.getMpw());
		return mDAO.update(map);
	}
	
	@Override
	public boolean updateCurrentRentalCount(MemberDTO mDTO) {
		return mDAO.updateCurrentRentalCount(mDTO);
	}


	@Override
	public boolean updateMember(MemberDTO mDTO) {
		return mDAO.updateMember(mDTO);
	}

	@Override
	public boolean updateOverdue(MemberDTO mDTO) {
		return mDAO.updateOverdue(mDTO);
	}

	@Override
	public boolean delete(MemberDTO mDTO) {
		return mDAO.delete(mDTO.getMid());
	}
	

}
