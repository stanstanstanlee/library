package com.kim.app.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookStkDTO;

@Mapper
public interface BookStkDAO {
	
	public BookStkDTO getStkInfoByStkNum(int bookStkNum);
	public BookStkDTO getStkConditionByStkNum(int bookStkNum);
	public List<BookStkDTO> getAllStkInfoByStkNumList(List<Integer> bookStkNum);
	public List<BookStkDTO> getAllStkByStkNum(BookStkDTO bStkDTO);
	public List<BookStkDTO> getAllStkByStkNumWithBookNum(BookStkDTO bStkDTO);
	public List<BookStkDTO> getAllStkByBookNum(BookDTO bDTO);
	public boolean update(BookStkDTO bStkDTO);
	public boolean deleteAllStkByBookNum(BookDTO bDTO);
	public int updateReturn(BookStkDTO bStkDTO);
	
}
