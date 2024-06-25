package com.kim.app.dto;

import java.time.LocalDate;
import java.util.List;

import lombok.Data;

@Data
public class BookRentalDTO {
	private long rentalNum; //pk 대여번호 NOT NULL
	private String mid; //fk 사용자아이디 NOT NULL
	private String bookNum;//fk 도서 번호 NOT NULL
	private int bookStkNum;//fk 재고번호 NOT NULL
	private LocalDate rentalDate; //대여일 NOT NULL
	private LocalDate returnDueDate; //반납 예정일 NOT NULL
	private boolean returnConfirmed;// 반납여부
	private LocalDate returnedDate; //반납된날
	private String exteriorConditionId;//외부상태
	private String interiorConditionId;//내부상태
	private String returnAdminMid; //반납받은 관리자 아이디
}
