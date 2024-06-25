package com.kim.app.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kim.app.dao.BookStkDAO;
import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookStkDTO;

@Service
public class BookStkServiceImpl implements BookStkService{

	@Autowired
	private BookStkDAO	bStkDAO;
	
	
	@Override
	public BookStkDTO getStkInfoByStkNum(int bookStkNum) {
		return bStkDAO.getStkInfoByStkNum(bookStkNum);
	}
	
	public BookStkDTO getStkConditionByStkNum(int bookStkNum) {
		return bStkDAO.getStkConditionByStkNum(bookStkNum);
	}
	
	@Override
	public List<BookStkDTO> getAllStkInfoByStkNumList(List<Integer> bookStkNum) {
		return bStkDAO.getAllStkInfoByStkNumList(bookStkNum);
	}	
	
	@Override
	public List<BookStkDTO> getAllStkByStkNum(BookStkDTO bStkDTO) {
		return bStkDAO.getAllStkByStkNum(bStkDTO);
	}
	
	@Override
	public List<BookStkDTO> getAllStkByStkNumWithBookNum(BookStkDTO bStkDTO) {
		return bStkDAO.getAllStkByStkNumWithBookNum(bStkDTO);
	}
	
	@Override
	public List<BookStkDTO> getAllStkByBookNum(BookDTO bDTO) {
		return bStkDAO.getAllStkByBookNum(bDTO);
	}
	
	@Override
	public boolean update(BookStkDTO bStkDTO) {
		return bStkDAO.update(bStkDTO);
	}

	@Override
	public boolean deleteAllStkByBookNum(BookDTO bDTO) {
		return bStkDAO.deleteAllStkByBookNum(bDTO);
	}

	@Override
	public void updateReturn(BookStkDTO bStkDTO) {
		bStkDAO.updateReturn(bStkDTO);
	}




}
