package com.kim.app.service;

import java.util.List;
import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookStkDTO;

public interface BookService { //interface : 충전기 어답터 (붕어빵 틀)
	public List<BookDTO> selectAll();
	public List<BookDTO> getAllBooksInfoByManyStkNums(List<Integer> bookStkNum);
	public BookDTO getBookByNum(BookDTO bDTO);
	public List<BookDTO> getBookByIsbn();
	public int countBookStkByBookNum(BookDTO bDTO);
	
	public BookDTO getBookInfoByStkNum(int bookStkNum);
	public BookDTO getBookByStkNum(BookStkDTO bStkDTO);
	
	public BookDTO getBookByTitle(BookDTO bDTO);
	public BookDTO getBookByTitleAndAuthor(BookDTO bDTO);
	public List<BookDTO> getBookBySearchText(String book);
	public List<BookDTO> getBookBySearchTextAndDate(BookDTO bDTO);
	
	public boolean insert(BookDTO bDTO);
	public boolean update(BookDTO bDTO);
	public boolean delete(BookDTO bDTO);
	public boolean deleteBooks(List<Integer> bookNum);
}
