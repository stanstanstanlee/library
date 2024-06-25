package com.kim.app.service;

import java.util.List;

import com.kim.app.dto.BookRentalDTO;
import com.kim.app.dto.RentalReturnDTO;
import com.kim.app.dto.ReturnTargetDTO;

public interface BookRentalService {

	public List<BookRentalDTO> selectAll();
	public BookRentalDTO selectOne(BookRentalDTO rDTO);
	public List<BookRentalDTO> getRentalInfoByMid(String mid);
	
	public List<String> getOverdueMids();
	public List<String> getOverdueUsersWhoReturnedAllBooks();
	
	public List<BookRentalDTO> getAllDueDateByStkNums(List<Integer> bookStkNums);
	
	public boolean insertBookRental(BookRentalDTO bRentalDTO);
	public boolean update(BookRentalDTO rDTO);
	public boolean delete(BookRentalDTO rDTO);
	public List<ReturnTargetDTO> getRetrunTargetInfos(List<Integer> bookStkNum, String mid);	
	public List<ReturnTargetDTO> selectAllOverduedRentals();
	public List<ReturnTargetDTO> selectAllCloseToOverDues();
	
	public List<ReturnTargetDTO> selectAllRentalsByDates();
	public List<ReturnTargetDTO> selectAllRentalsByTextAndDate(ReturnTargetDTO rTargetDTO);
	public List<ReturnTargetDTO> selectAllRentalsButNotReturned();
	
	public List<ReturnTargetDTO> selectAllReturnedHistory();
	public List<ReturnTargetDTO> selectAllReturnedHistoryByTextAndDates(ReturnTargetDTO rTargetDTO);
	
	public List<ReturnTargetDTO> selectConditionsWhenReturned();
	public List<ReturnTargetDTO> searchConditionWhenReturned(ReturnTargetDTO rTargetDTO);
	
	
	public void updateReturn(RentalReturnDTO dto); 
}
