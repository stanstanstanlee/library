package com.kim.app.service;

import java.time.LocalDateTime;
import java.util.ArrayList;
import java.util.List;

import org.springframework.scheduling.annotation.Scheduled;
import org.springframework.stereotype.Service;

import com.kim.app.dto.BookRentalDTO;
import com.kim.app.dto.MemberDTO;

import lombok.RequiredArgsConstructor;
import lombok.extern.slf4j.Slf4j;

@Service
@Slf4j
@RequiredArgsConstructor
public class TestScheduleService {

	private final BookRentalService bookRentalService;
	private final MemberService memberService;

	@Scheduled(cron = "0 0 0 * * *") //12시 0분 5초 AM
//	@Scheduled(cron = "*/5 * * * * *") 
	public void checkOverdueUsers() {
		log.info("스케줄 실행: {}", LocalDateTime.now());
		// 연체자 조회
		List<String> overdueMids = new ArrayList<String>();
		overdueMids = bookRentalService.getOverdueMids();

		// 사용자의 권한을 연체자로 변경처리
		MemberDTO mDTO = new MemberDTO();
		for(String mid : overdueMids) {
			mDTO.setAuth("overdue");
			mDTO.setMid(mid);
			memberService.updateOverdue(mDTO);
		}
		System.out.println("checkOverdueUsers done");
	}
	
	@Scheduled(cron = "5 0 0 * * *") //12시 0분 5초 AM
	public void checkIfOverdueUsersReturnedAllBooks() {
		log.info("스케줄 실행: {}", LocalDateTime.now());
		// 연체자중 모두 받납한사람 조회
		List<String> overdueMidsWhoReturnedAllBooks = new ArrayList<String>();
		overdueMidsWhoReturnedAllBooks = bookRentalService.getOverdueUsersWhoReturnedAllBooks();

		// 연체자의 권한을 사용자로 변경처리
		MemberDTO mDTO = new MemberDTO();
		for(String mid : overdueMidsWhoReturnedAllBooks) {
			mDTO.setAuth("user");
			mDTO.setMid(mid);
			memberService.updateOverdue(mDTO);
		}
		System.out.println("checkIfOverdueUsersReturnedAllBooks done");
	}
}
