package com.kim.app.dto;

import java.time.LocalDate;

import org.springframework.web.multipart.MultipartFile;

import lombok.Data;

@Data
public class BookDTO {
	private String bookNum; // ISBN 책 고유 번호 pk
	private String bookTitle; //책 제목-
	private String bookAuthor; //책 글쓴이
	private LocalDate bookRegisterDate; //책 등록일
	private String searchText; //서치내용
	private String searchDate;
	private LocalDate startDate;
	private LocalDate endDate;
	private int bookQty; 
	private String bookImg;
	private MultipartFile bookImgFile;
	private int bookStkNum;
}
