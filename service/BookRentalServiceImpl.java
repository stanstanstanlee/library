package com.kim.app.service;

import java.time.LocalDate;
import java.time.temporal.ChronoUnit;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.kim.app.dao.BookRentalDAO;
import com.kim.app.dto.BookRentalDTO;
import com.kim.app.dto.RentalReturnDTO;
import com.kim.app.dto.ReturnTargetDTO;

@Service
public class BookRentalServiceImpl implements BookRentalService{

	@Autowired
	private BookRentalDAO bRentalDAO;
	@Override
	public List<BookRentalDTO> selectAll() {
		return bRentalDAO.selectAll();
	}
	@Override
	public BookRentalDTO selectOne(BookRentalDTO bRentalDTO) {
		return bRentalDAO.selectOne(bRentalDTO);
	}
	
	@Override
	public List<BookRentalDTO> getAllDueDateByStkNums(List<Integer> bookStkNums) {
		return bRentalDAO.getAllDueDateByStkNums(bookStkNums);
	}
	
	@Override
	public List<BookRentalDTO> getRentalInfoByMid(String mid) {
		return bRentalDAO.getRentalInfoByMid(mid);
	}
	@Override
	public List<String> getOverdueMids() {
		return bRentalDAO.getOverdueMids();
	}
	
	@Override
	public List<String> getOverdueUsersWhoReturnedAllBooks() {
		return bRentalDAO.getOverdueUsersWhoReturnedAllBooks();
	}
	
	@Override
	public boolean insertBookRental(BookRentalDTO bRentalDTO) {
		return bRentalDAO.insertBookRental(bRentalDTO);
	}
	@Override
	public boolean update(BookRentalDTO bRentalDTO) {
		return bRentalDAO.update(bRentalDTO);
	}
	@Override
	public boolean delete(BookRentalDTO bRentalDTO) {
		return bRentalDAO.delete(bRentalDTO);
	}
	
	@Override
	public List<ReturnTargetDTO> getRetrunTargetInfos(List<Integer> bookStkNum, String mid) {
		Map<String, Object> params = new HashMap<>();
		params.put("mid", mid);
		params.put("bookStkNum", bookStkNum);
		
		List<ReturnTargetDTO> result = bRentalDAO.selectRentalTarget(params);
		
		LocalDate today = LocalDate.now();
		for (int i = 0; i < result.size(); i++) {
			result.get(i).setOverDue(today.isAfter(result.get(i).getReturnDueDate()));
		}		
				
//		for(ReturnTargetDTO dto : result) {
//			dto.setOverDue(today.isAfter(dto.getReturnDueDate()));
//		}
		
		return result;
	}
	
	@Override
	public List<ReturnTargetDTO> selectAllOverduedRentals() {
		
		List<ReturnTargetDTO> result = bRentalDAO.selectAllOverduedRentals();
		
		for(ReturnTargetDTO book : result) {
			LocalDate returnDueDate = book.getReturnDueDate();
		    LocalDate now = LocalDate.now();
		    long daysBetween = ChronoUnit.DAYS.between(returnDueDate, now);
		    book.setOverdueDays((int) daysBetween);
		}
		
		return result;	
	}
	
	@Override
	public List<ReturnTargetDTO> selectAllCloseToOverDues() {
		
		List<ReturnTargetDTO> result = bRentalDAO.selectAllCloseToOverDues();
		
		for(ReturnTargetDTO book : result) {
			LocalDate returnDueDate = book.getReturnDueDate();
		    LocalDate now = LocalDate.now();
		    long daysBetween = ChronoUnit.DAYS.between(now, returnDueDate);
		    book.setLeftOverDueDays((int) daysBetween);
		}
		
		return result;
	}

	
	@Override
	public List<ReturnTargetDTO> selectAllRentalsByDates() {
		List<ReturnTargetDTO> result = bRentalDAO.selectAllRentalsByDates();
		return result;
	}
	
	@Override
	public List<ReturnTargetDTO> selectAllRentalsByTextAndDate(ReturnTargetDTO rTargetDTO) {
		List<ReturnTargetDTO> result = bRentalDAO.selectAllRentalsByTextAndDate(rTargetDTO);
		return result;
	}
	
	@Override
	public List<ReturnTargetDTO> selectAllRentalsButNotReturned() {
		List<ReturnTargetDTO> result = bRentalDAO.selectAllRentalsButNotReturned();
		return result;
	}
	
	
	@Override
	public List<ReturnTargetDTO> selectAllReturnedHistory() {
		List<ReturnTargetDTO> result = bRentalDAO.selectAllReturnedHistory();
		return result;
	}
	
	@Override
	public List<ReturnTargetDTO> selectAllReturnedHistoryByTextAndDates(ReturnTargetDTO rTargetDTO) {
		List<ReturnTargetDTO> result = bRentalDAO.selectAllReturnedHistoryByTextAndDates(rTargetDTO);
		return result;
	}
	
	@Override
	public List<ReturnTargetDTO> selectConditionsWhenReturned() {
		List<ReturnTargetDTO> result = bRentalDAO.selectConditionsWhenReturned();
		return result;
	}
	
	@Override
	public List<ReturnTargetDTO> searchConditionWhenReturned(ReturnTargetDTO rTargetDTO) {
		List<ReturnTargetDTO> result = bRentalDAO.searchConditionWhenReturned(rTargetDTO);
		return result;
	}
	
	@Override
	public void updateReturn(RentalReturnDTO dto) {
		bRentalDAO.updateReturn(dto);
	}

}
