package com.kim.app.dao;

import java.util.List;
import java.util.Map;

import org.apache.ibatis.annotations.Mapper;

import com.kim.app.dto.BookRentalDTO;
import com.kim.app.dto.RentalReturnDTO;
import com.kim.app.dto.ReturnTargetDTO;

@Mapper
public interface BookRentalDAO {
	public List<BookRentalDTO> selectAll();
	public BookRentalDTO selectOne(BookRentalDTO rDTO);
	public List<BookRentalDTO> getRentalInfoByMid(String mid);
	
	public List<String> getOverdueMids();
	public List<String> getOverdueUsersWhoReturnedAllBooks();
	
	public List<BookRentalDTO> getAllDueDateByStkNums(List<Integer> bookStkNums);
	
	public boolean insertBookRental(BookRentalDTO bRentalDTO);
	public boolean update(BookRentalDTO rDTO);
	public boolean delete(BookRentalDTO rDTO);
	List<ReturnTargetDTO> selectRentalTarget(Map<String, Object> params);
	public List<ReturnTargetDTO> selectAllOverduedRentals();
	public List<ReturnTargetDTO> selectAllCloseToOverDues();
	
	public List<ReturnTargetDTO> selectAllRentalsByDates();
    public List<ReturnTargetDTO> selectAllRentalsByTextAndDate(ReturnTargetDTO rTargetDTO);
	public List<ReturnTargetDTO> selectAllRentalsButNotReturned();
    
    
    public List<ReturnTargetDTO> selectAllReturnedHistory();
    public List<ReturnTargetDTO> selectAllReturnedHistoryByTextAndDates(ReturnTargetDTO rTargetDTO);
    
    public List<ReturnTargetDTO> selectConditionsWhenReturned();
    public List<ReturnTargetDTO> searchConditionWhenReturned(ReturnTargetDTO rTargetDTO);
    
    
	public int updateReturn(RentalReturnDTO dto);
}
