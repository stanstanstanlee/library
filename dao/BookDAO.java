package com.kim.app.dao;

import java.util.List;
import org.apache.ibatis.annotations.Mapper;
import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookStkDTO;

@Mapper
public interface BookDAO {
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
	
	public int insert(BookDTO bDTO);
	public boolean update(BookDTO bDTO);
	public boolean delete(BookDTO bDTO);
	public boolean deleteBooks(List<Integer> bookNum);
	
	int insertStk(BookStkDTO bStkDTO);
}
