package com.kim.app.dto;

import java.text.SimpleDateFormat;
import java.util.Calendar;
import java.util.Date;

import lombok.Data;

@Data
public class MemberDTO { //VO
	private String mid; //PK회원아이디
	private String mpw;//회원비번
	private String memberName; //사용자이름
	private String auth; //권한코드
	private String authName; //권한이름
	private int rentCap; //최대도서개수
	private int rentPeriod; //도서대여기한
	private int currentRentalCount; //현재 대여중인 도서 수
	private int remainingRentalCount; //남은 대여 가능 수
	private String searchText; //서치내용
	private String userInputMid;
	private String userInputMpw;
	
	
	
	public MemberDTO() {
		// 남은 대여 가능 수 초기화
		this.remainingRentalCount = this.rentCap - this.currentRentalCount;
	}
	// 반납 예정일 계산 메서드
	public Date getDueDate() {
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		calendar.add(Calendar.DAY_OF_MONTH, rentPeriod);
		return calendar.getTime();
	}

	// 반납 예정일 계산 및 포맷 설정 메서드
	public String getReturnDueDate() {
		SimpleDateFormat dateFormat = new SimpleDateFormat("yyyy-MM-dd");
		Calendar calendar = Calendar.getInstance();
		calendar.setTime(new Date());
		calendar.add(Calendar.DAY_OF_MONTH, rentPeriod);
		return dateFormat.format(calendar.getTime());
	}

}
