package com.kim.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kim.app.dao.BookDAO;
import com.kim.app.dao.BookStkDAO;
import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookStkDTO;
import com.kim.app.util.FileService;

@Service
public class BookServiceImpl implements BookService { //서비스(인터페이스) 클래스에 대한 구현체를 구현한다
	@Autowired
	private BookStkDAO	bStkDAO;
	
	@Autowired
	private BookDAO	bDAO;
	
	@Autowired
	private FileService fileService;
	
	@Override
	public List<BookDTO> selectAll() {
		return bDAO.selectAll();
	}
	
	@Override
	public List<BookDTO> getAllBooksInfoByManyStkNums(List<Integer> bookStkNum) {
		return bDAO.getAllBooksInfoByManyStkNums(bookStkNum);
	}

	@Override
	public BookDTO getBookByNum(BookDTO bDTO) {
		return bDAO.getBookByNum(bDTO);
	}

	@Override
	public BookDTO getBookInfoByStkNum(int bookStkNum) {
		return bDAO.getBookInfoByStkNum(bookStkNum);
	}
	
	@Override
	public List<BookDTO> getBookByIsbn() {
		return bDAO.getBookByIsbn();
	}
	
	@Override
	public int countBookStkByBookNum(BookDTO bDTO) {
		return bDAO.countBookStkByBookNum(bDTO);
	}
	
	@Override
	public BookDTO getBookByStkNum(BookStkDTO bStkDTO) {
		return bDAO.getBookByStkNum(bStkDTO);
	}
	
	@Override
	public BookDTO getBookByTitle(BookDTO bDTO) {
		return bDAO.getBookByTitle(bDTO);
	}
	
	@Override
	public BookDTO getBookByTitleAndAuthor(BookDTO bDTO) {
		return bDAO.getBookByTitleAndAuthor(bDTO);
	}
	
	@Override
	public List<BookDTO> getBookBySearchText(String book) {
		return bDAO.getBookBySearchText(book);
	}
	
	@Override
	public List<BookDTO> getBookBySearchTextAndDate(BookDTO bDTO) {
		return bDAO.getBookBySearchTextAndDate(bDTO);
	}
	
	@Override
	public boolean insert(BookDTO bDTO) {
		 //이미 존재 하는 똑같은 isbn은 도서테이블에 추가 못해야 함 --> 재고 추가임
		 BookDTO bdata = getBookByNum(bDTO);
		 String bookImg = fileService.saveFile(bDTO.getBookImgFile());
		 bDTO.setBookImg(bookImg);
		
		 if(bdata == null) {//기존에 존재 하지 않는 도서면 도서테이블에 새로운 책 추가
		 //알림 : 신규 도서 등록. 저장? 취소?
			 bDAO.insert(bDTO); 
		 } else {
			 bDTO.setBookNum(bdata.getBookNum()); //기존에 존재 하는 도서면 그 도서번호 가져와서 세팅
		 }
		 //알림 : 이미 등록된 도서. 기존 도서에 재고 추가 저장? 취소?
		 
		 // 재고 테이블에 추가. bookQty loop
		 for(int i=0; i<bDTO.getBookQty(); i++) {
			 BookStkDTO bStkDTO = new BookStkDTO();
			 bStkDTO.setBookNum(bDTO.getBookNum()); //재고 객체에 어떤 도서 인지 도서번호 세팅 
			 bStkDTO.setDisposed(false);
			 bStkDTO.setRented(false);
			 bStkDTO.setExteriorConditionId(1);
			 bStkDTO.setInteriorConditionId(1);
			 bDAO.insertStk(bStkDTO);
			 
		 }		 
		 
		 return true;
	}

	@Override
	public boolean update(BookDTO bDTO) {
		
		String bookImg = fileService.saveFile(bDTO.getBookImgFile());
		bDTO.setBookImg(bookImg);
		
		return bDAO.update(bDTO);
	}

	@Override
	public boolean delete(BookDTO bDTO) {
		return bDAO.delete(bDTO);
	}

	@Override
	public boolean deleteBooks(List<Integer> bookNum) {
		return bDAO.deleteBooks(bookNum);
	}

	


}
