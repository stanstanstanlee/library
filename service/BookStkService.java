package com.kim.app.service;

import java.util.List;
import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookStkDTO;

public interface BookStkService {
	
	public BookStkDTO getStkInfoByStkNum(int bookStkNum);
	public BookStkDTO getStkConditionByStkNum(int bookStkNum);
	public List<BookStkDTO> getAllStkInfoByStkNumList(List<Integer> bookStkNum);
	public List<BookStkDTO> getAllStkByStkNum(BookStkDTO bStkDTO);
	public List<BookStkDTO> getAllStkByStkNumWithBookNum(BookStkDTO bStkDTO);
	public List<BookStkDTO> getAllStkByBookNum(BookDTO bDTO);
	public boolean update(BookStkDTO bStkDTO);
	public boolean deleteAllStkByBookNum(BookDTO bDTO);
	public void updateReturn(BookStkDTO bStkDTO);
}
