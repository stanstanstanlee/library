package com.kim.app.controller;

import java.util.ArrayList;
import java.util.HashMap;
import java.util.List;
import java.util.Map;

import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.transaction.annotation.Transactional;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.bind.annotation.ResponseBody;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookRentalDTO;
import com.kim.app.dto.BookStkDTO;
import com.kim.app.dto.MemberDTO;
import com.kim.app.dto.RentalReturnDTO;
import com.kim.app.dto.ReturnConditionSettingDTO;
import com.kim.app.dto.ReturnRequestDTO;
import com.kim.app.dto.ReturnTargetDTO;
import com.kim.app.service.BookRentalService;
import com.kim.app.service.BookService;
import com.kim.app.service.BookStkService;
import com.kim.app.service.MemberService;
import com.kim.app.service.ReturnConditionSettingService;
import com.kim.app.service.SequenceGeneratorService;

import jakarta.servlet.http.HttpServletRequest;
import jakarta.servlet.http.HttpSession;
import lombok.RequiredArgsConstructor;

@Controller
@RequiredArgsConstructor
public class BookRentalController {

	private final BookRentalService bookRentalService;
	private final BookService bookService;
	private final BookStkService bookStkService;
	private final MemberService memberService;
	private final ReturnConditionSettingService rConditionService;

	private final SequenceGeneratorService sequenceGeneratorService;

	public List<Integer> convertToIntegerList(List<String> stringList) {
		List<Integer> integerList = new ArrayList<>();
		for (String str : stringList) {
			integerList.add(Integer.parseInt(str));
		}
		return integerList;
	}
	@GetMapping("/rentBookPage") //매인메뉴에서 책 대여 클릭시 책대여 페이지로
	public String rentBookPage() {
		System.out.println("rentBookPage로그");
		
		return "rentBook"; 
	}

	@PostMapping("/rentalConfirmationPage") //대여확인 페이지로 이동 
	public String rentalConfirmationPage(Model model,
			@RequestParam("mid") String mid,
			@RequestParam("bookStkNums") List<Integer> bookStkNum,
			MemberDTO mDTO 
			) {
		System.out.println("rentalConfirmationPage 로그");
		mDTO.setMid(mid);	    
		System.out.println("mid : " + mid);

		// Model을 사용하여 데이터 전달
		mDTO = memberService.getMemberById(mDTO);
		System.out.println("mDTO : " + mDTO);
		model.addAttribute("member", mDTO);

		List<BookDTO> bDTOList = new ArrayList<>();
		System.out.println("bookStkNum : " + bookStkNum);

		bDTOList = bookService.getAllBooksInfoByManyStkNums(bookStkNum);
		model.addAttribute("bookStkNums", bookStkNum);
		model.addAttribute("bDTOList", bDTOList);
		System.out.println("bDTOList : " + bDTOList);
		// 뷰 이름 반환
		return "rentalConfirmation";
	}

	@PostMapping("/rentBookGetMemberInfo") //대여할 사용자 입력 액션
	@ResponseBody //@RequestBody :  JSON 형식의 데이터를 매핑(구조화된 데이터 전송); HTTP 요청의 본문(body)에 있는 데이터를 메소드의 파라미터로 매핑
	public ResponseEntity<Map<String, Object>> rentBookGetMemberInfo(@RequestBody Map<String, Object> request) {
		System.out.println("rentBookGetMemberInfo로그");
		String mid = (String) request.get("mid");
		System.out.println("request : " + request);
		System.out.println("mid : " + mid);
		Map<String, Object> responseMap = new HashMap<>();
		try {
			// 서비스를 통해 사용자 정보 가져오기
			MemberDTO user = memberService.getMemberByIdSearch(mid);

			if (user != null) {
				System.out.println("사용자찾음");

				// 연체여부 조회 코드 추가
				if(user.getAuth().equals("overdue")) {
					System.out.println("auth : " + user.getAuth());
					responseMap.put("success", true);
					responseMap.put("message", "overdue");
				}

				responseMap.put("user", user);
				responseMap.put("success", true);
			} else {
				responseMap.put("success", false);
				responseMap.put("message", "없는사용자");
			}
		} catch (Exception e) {
			responseMap.put("success", false);
			responseMap.put("message", "사용자조회실패");
			e.printStackTrace(); // 에러 로깅
		}

		return new ResponseEntity<>(responseMap, HttpStatus.OK);
	}

	@PostMapping("/rentBookGetBookInfo") // 대여||반납 할 책들 확인 액션
	public ResponseEntity<Map<String, Object>> rentBookInputBook(@RequestBody Map<String, Object> request
			, BookStkDTO bStkDTO) {
		System.out.println("rentBookGetBookInfo 로그");
		System.out.println("request : " + request);
		String bookStkNumStr = (String) request.get("bookStkNum");
		Map<String, Object> responseMap = new HashMap<>();
		try {
			int bookStkNum = Integer.parseInt(bookStkNumStr);
			BookDTO bDTO = bookService.getBookInfoByStkNum(bookStkNum);
			System.out.println("getBookInfoByStkNum으로 bDTO 가져온거 : " + bDTO);
			bDTO = bookService.getBookByNum(bDTO);
			System.out.println("getBookByNum으로 bDTO 가져온거 : " + bDTO);
			System.out.println();
			if (bDTO != null) {
				System.out.println("재고번호있음");
				bDTO.setBookStkNum(bookStkNum);
				bStkDTO = bookStkService.getStkInfoByStkNum(bookStkNum);
				if(bStkDTO.isRented()||bStkDTO.isDisposed()) {
					System.out.println("진입 isRented||isDisposed");
					responseMap.put("success", true);
					responseMap.put("message", "notAvailable");
					System.out.println("responseMap.put(\"message\", \"notAvailable\"); 를 반환");
				}
				responseMap.put("bookInfo", bDTO);
				responseMap.put("success", true);
			} else {
				System.out.println("재고번호없음");
				responseMap.put("success", true);
				responseMap.put("message", "없는재고번호");

				return ResponseEntity.status(HttpStatus.NO_CONTENT).body(responseMap);
			}

		}catch (NumberFormatException e) {
			System.out.println("NumberFormatException");
			responseMap.put("success", false);
			responseMap.put("message", "잘못된 재고번호 형식");
			e.printStackTrace(); 

			return ResponseEntity.status(HttpStatus.BAD_REQUEST).body(responseMap);

		}catch (Exception e) {
			responseMap.put("success", false);
			responseMap.put("message", "재고조회실패");
			e.printStackTrace();
		}
		return new ResponseEntity<>(responseMap, HttpStatus.OK);
	}

	@PostMapping("/checkRenterIdAndPw")// 대여||반납하려는 사용자 서명 확인 액션
	public ResponseEntity<Map<String, Object>> checkRenterIdAndPw(@RequestBody Map<String, Object> request
			) {
		System.out.println("checkRenterIdAndPw로그");
		Map<String, Object> responseMap = new HashMap<>();
		String mid = (String) request.get("mid");
		String userInputMid = (String) request.get("userInputMid");
		String userInputMpw = (String) request.get("userInputMpw");
		String mpwDB = memberService.getPwById(mid);

		if(!(mid.equals(userInputMid))) {
			System.out.println("아이디 불일치");
			responseMap.put("success", false);
			responseMap.put("message", "userInfoMismatch");
			return ResponseEntity.status(HttpStatus.NO_CONTENT).body(responseMap);
		}
		else if(!(userInputMpw.equals(mpwDB))){
			System.out.println("비밀번호 불일치");
			responseMap.put("success", false);
			responseMap.put("message", "userInfoMismatch");
			return ResponseEntity.status(HttpStatus.NO_CONTENT).body(responseMap);
		}
		System.out.println("사용자 정보 일치");
		responseMap.put("success", true);
		responseMap.put("message", "userInfoMatches");
		System.out.println("responseMap" + responseMap);
		return new ResponseEntity<>(responseMap, HttpStatus.OK);
	}

	@PostMapping("/confirmRentalFinal") //도서 최종대여 승인 액션
	@Transactional
	public String confirmRentalFinal(BookRentalDTO bRentalDTO,
			BookDTO bDTO, BookStkDTO bStkDTO, MemberDTO mDTO,
			@RequestParam("bookStkNums") List<Integer> bookStkNum,
			@RequestParam("bookNums") List<String> bookNum,
			RedirectAttributes rattr 
			) {
		System.out.println("confirmRentalFinal로그 ");
		System.out.println("bRentalDTO : " + bRentalDTO);
		System.out.println("bDTO : " + bDTO);
		System.out.println("bStkDTO : " + bStkDTO);
		System.out.println("MemberDTO : " + mDTO);
		System.out.println("bookStkNums : " + bookStkNum);
		System.out.println("bookNums : " + bookNum);

		int newRentalCnt = 0;
		Integer curRentalCnt = 0;
		boolean insertSuccess = false;
		// 시퀀스로부터 RENTAL_NUM 생성
		Long rentalNum = sequenceGeneratorService.getNextSequenceValue("SEQ");
		System.out.println("rentalNum : " + rentalNum);

		for (int i = 0; i < bookStkNum.size(); i++) {
			// BookRentalDTO 설정
			bRentalDTO.setRentalNum(rentalNum);
			bRentalDTO.setMid(mDTO.getMid());
			bRentalDTO.setBookNum(bookNum.get(i));
			bRentalDTO.setBookStkNum(bookStkNum.get(i));
			bRentalDTO.setRentalDate(bRentalDTO.getRentalDate());
			bRentalDTO.setReturnDueDate(bRentalDTO.getReturnDueDate());
			System.out.println("bRentalDTO after all set in forloop : " + bRentalDTO);

			if(bookRentalService.insertBookRental(bRentalDTO)) {
				System.out.println("insertBookRental(bRentalDTO) 진입");

				bStkDTO.setBookStkNum(bookStkNum.get(i));
				bStkDTO.setRented(true);
				System.out.println("bStkDTO" + bStkDTO);

				bookStkService.update(bStkDTO);
				insertSuccess = true;
				System.out.println("대여성공");
			}
		}


		if(insertSuccess == true) {
			System.out.println("대여중 책 숫자 업데이트 하기 전 mDTO : " + mDTO);
			String mid = mDTO.getMid();
			System.out.println("mid : " + mid);
			curRentalCnt = memberService.getCurRentalCntByMid(mid);
			if(curRentalCnt == null) {
				curRentalCnt = 0;
			}
			System.out.println("멤버 대여중인 책 숫자 업데이트 하기 전 curRentalCnt : " + curRentalCnt);
			newRentalCnt = (curRentalCnt + bookStkNum.size());
			System.out.println("새로 빌리는 재고 추가 후 mDTO.getCurrentRentalCount가 될 숫자 : " + newRentalCnt);
			mDTO.setCurrentRentalCount(newRentalCnt);
			memberService.updateCurrentRentalCount(mDTO);
		}
		rattr.addFlashAttribute("message","rentalSuccess");
		return "redirect:rentalAndReturnSearchPage";
	}

	//---------------------------------------------반납-------------------------------------

	@GetMapping("/returnBookPage") //매인메뉴에서 책 반납 클릭시 반납 페이지로 이동
	public String returnBookPage() {
		System.out.println("returnBookPage로그");
		return "returnBook"; 
	}

	@PostMapping("/returnBookGetMemberRentalInfo") //반납할 사용자 입력 액션
	@ResponseBody
	public ResponseEntity<Map<String, Object>> returnBookGetMemberRentalInfo(
			@RequestBody Map<String, Object> request
			) {
		System.out.println("returnBookGetMemberRentalInfo 로그");
		Map<String, Object> responseMap = new HashMap<>();
		//mid받아옴 키,벨류
		//bookRentalService 통해서 mid 값으로 대여정보 모두 조회
		String mid = (String) request.get("mid");
		System.out.println("mid : " + mid);
		List<BookRentalDTO> bRentalDTOList = new ArrayList<>();

		bRentalDTOList = bookRentalService.getRentalInfoByMid(mid);
		System.out.println("bRentalDTO : " + bRentalDTOList);

		responseMap.put("bRentalDTO", bRentalDTOList);
		responseMap.put("success", true);

		return new ResponseEntity<>(responseMap, HttpStatus.OK);
	}


	@PostMapping("/returnConfirmationPage") //반납확인 페이지로 이동 
	public String returnConfirmationPage(Model model,
			@RequestParam("mid") String mid,
			@RequestParam("bookStkNums") List<Integer> bookStkNum,
			MemberDTO mDTO 
			) {
		System.out.println("returnConfirmationPage 로그");
		mDTO.setMid(mid);	    
		System.out.println("mid : " + mid);

		// Model을 사용하여 데이터 전달
		mDTO = memberService.getMemberById(mDTO);
		System.out.println("mDTO : " + mDTO);
		model.addAttribute("member", mDTO);

		//		List<BookDTO> bDTOList = new ArrayList<>();
		//		System.out.println("bookStkNum : " + bookStkNum);

		List<ReturnTargetDTO> targets = bookRentalService.getRetrunTargetInfos(bookStkNum, mid);

		//		bDTOList = bookService.getAllBooksInfoByManyStkNums(bookStkNum);
		//		model.addAttribute("bookStkNums", bookStkNum);
		//		model.addAttribute("bDTOList", bDTOList);
		//		System.out.println("bDTOList : " + bDTOList);

		List<BookStkDTO> bStkDTOList = new ArrayList<>();
		bStkDTOList = bookStkService.getAllStkInfoByStkNumList(bookStkNum);
		System.out.println("bStkDTOList : " + bStkDTOList);
		model.addAttribute("bStkDTOList",bStkDTOList);

		//		List<BookRentalDTO> bRentalDTOList = new ArrayList<>();
		//		bRentalDTOList = bookRentalService.getAllDueDateByStkNums(bookStkNum);
		//		System.out.println("bRentalDTOList: "+ bRentalDTOList);
		//		model.addAttribute("bRentalDTOList",bRentalDTOList);

		List<ReturnConditionSettingDTO> exConditionDTOList = rConditionService.getExteriorConditionSetting();
		List<ReturnConditionSettingDTO> inConditionDTOList = rConditionService.getInteriorConditionSetting();

		model.addAttribute("bookList", targets);
		model.addAttribute("exConditionList", exConditionDTOList);
		model.addAttribute("inConditionList", inConditionDTOList);

		// 뷰 이름 반환
		return "returnConfirmation";
	}

	@PostMapping("/checkAdminIdAndPw")// 관리자 서명 확인 액션 
	public ResponseEntity<Map<String, Object>> checkAdminIdAndPw(@RequestBody Map<String, Object> request,
			HttpServletRequest httpRequest
			) {
		System.out.println("checkAdminIdAndPw로그");
		Map<String, Object> responseMap = new HashMap<>();

		HttpSession session = httpRequest.getSession();
		String sessionMid = (String) session.getAttribute("member");
		System.out.println("sessionMid : " + sessionMid);

		String userInputAdminMid = (String) request.get("userInputAdminMid");
		String userInputAdminMpw = (String) request.get("userInputAdminMpw");
		String mpwDB = memberService.getPwById(sessionMid);

		if(!(sessionMid.equals(userInputAdminMid))) {
			System.out.println("관리자 아이디 불일치");
			responseMap.put("success", false);
			responseMap.put("message", "adminInfoMismatch");
			return ResponseEntity.status(HttpStatus.NO_CONTENT).body(responseMap);
		}
		else if(!(userInputAdminMpw.equals(mpwDB))){
			System.out.println("관리자 비밀번호 불일치");
			responseMap.put("success", false);
			responseMap.put("message", "adminInfoMismatch");
			return ResponseEntity.status(HttpStatus.NO_CONTENT).body(responseMap);
		}
		System.out.println("관리자 정보 일치");
		responseMap.put("success", true);
		responseMap.put("message", "adminInfoMatches");
		System.out.println("responseMap" + responseMap);
		return new ResponseEntity<>(responseMap, HttpStatus.OK);
	}

	@PostMapping("/confirmReturnFinal") //도서 최종반납 승인 액션
	@Transactional
	public String confirmReturnFinal(
			@RequestParam("mid") String mid,
			ReturnRequestDTO returnRequestDto,
			HttpServletRequest httpRequest,
			RedirectAttributes rattr
			) {

		HttpSession session = httpRequest.getSession();
		String sessionMid = (String) session.getAttribute("member");

		System.out.println(returnRequestDto);
		int bookCnt = 0;
		for (ReturnRequestDTO.ReturnItem returnItem : returnRequestDto.getReturnItems()) {
			RentalReturnDTO rentalReturnDTO = new RentalReturnDTO();
			rentalReturnDTO.setAdminMid(sessionMid);
			rentalReturnDTO.setBookStkNum(returnItem.getBookStkNum());
			rentalReturnDTO.setExConditionId(returnItem.getExConditionId());
			rentalReturnDTO.setInConditionId(returnItem.getInConditionId());

			BookStkDTO bookStkDTO = new BookStkDTO();
			bookStkDTO.setBookStkNum(returnItem.getBookStkNum());
			bookStkDTO.setExteriorConditionId(returnItem.getExConditionId());
			bookStkDTO.setInteriorConditionId(returnItem.getInConditionId());

			bookRentalService.updateReturn(rentalReturnDTO);
			bookStkService.updateReturn(bookStkDTO);
			bookCnt++;
		}
		int curRentalCnt = 0;
		MemberDTO mDTO = new MemberDTO();
		mDTO.setMid(mid);
		System.out.println("mid : " + mid);
		System.out.println("mDTO : " + mDTO);
		curRentalCnt = memberService.getCurRentalCntByMid(mid);
		System.out.println("curRentalCnt : " + curRentalCnt);

		int newRentalCnt = curRentalCnt - bookCnt;
		System.out.println("newRentalCnt : " + newRentalCnt);

		mDTO.setCurrentRentalCount(newRentalCnt);
		System.out.println("bookCnt : " + bookCnt);
		memberService.updateCurrentRentalCount(mDTO);
		rattr.addFlashAttribute("message","returnSuccess");
		
		return "redirect:returnHistorySearchPage";
	}

	//=======================연체 정보 / 반납 기한 만기 임박 정보=========================================================

	@GetMapping("/goToOverdueBooksPage")
	public String goToOverdueBooks(Model model) {
		System.out.println("goToOverdueBooks 로그");

		List<ReturnTargetDTO> overduedRentals = bookRentalService.selectAllOverduedRentals();
		System.out.println("overduedRentals : " + overduedRentals);
		model.addAttribute("bookList",overduedRentals);

		return "overDueBooks";
	}

	@GetMapping("/closeToReturnDateList")
	public String closeToReturnDateList(Model model) {
		System.out.println("closeToReturnDateList로그");

		List<ReturnTargetDTO> almostOverDueList = bookRentalService.selectAllCloseToOverDues();

		model.addAttribute("bookList",almostOverDueList);
		return "closeToRentalPeriodExpiring";
	}

	//==================== 대여 및 반납 이력 조회 ======================================================================
	@GetMapping("/rentalAndReturnSearchPage") //전체 대여목록
	public String rentalAndReturnSearchPage(Model model) {
		System.out.println("rentalAndReturnSearchPage GET 로그");
		List<ReturnTargetDTO> allRentalsByDates = bookRentalService.selectAllRentalsByDates();

		model.addAttribute("bookList",allRentalsByDates);

		return "rentalAndReturnSearchPage";
	}

	@PostMapping("/rentalAndReturnSearchPage")//검색
	public String rentalAndReturnSearchPagePost(ReturnTargetDTO rTargetDTO, Model model) {
		System.out.println("rentalAndReturnSearchPage POST 로그");

		List<ReturnTargetDTO> allRentalsByDates = bookRentalService.selectAllRentalsByTextAndDate(rTargetDTO);

		model.addAttribute("bookList",allRentalsByDates);
		return "rentalAndReturnSearchPage";
	}

	@GetMapping("/rentalsNotReturned") //미반납 대여 목록
	public String rentalsNotReturned(ReturnTargetDTO rTargetDTO, Model model) {
		System.out.println("rentalsNotReturned 로그");

		List<ReturnTargetDTO> rentedButNotReturned = bookRentalService.selectAllRentalsButNotReturned();
		model.addAttribute("bookList",rentedButNotReturned);
		return "rentalAndReturnSearchPage";
	}


	//----- 반납내역 확인

	@GetMapping("/returnHistorySearchPage")
	public String returnSearchPage(Model model) { //전체반납목록
		System.out.println("returnHistorySearchPage GET 로그");

		List<ReturnTargetDTO> returnHistories = bookRentalService.selectAllReturnedHistory();

		model.addAttribute("bookList",returnHistories);
		return "returnHistorySearchPage";
	}

	@PostMapping("/returnHistorySearchPage") //검색
	public String returnHistorySearchPagePost(ReturnTargetDTO rTargetDTO, Model model) {
		System.out.println("returnHistorySearchPage POST 로그");

		List<ReturnTargetDTO> returnHistoryByDates = bookRentalService.selectAllReturnedHistoryByTextAndDates(rTargetDTO);
		model.addAttribute("bookList", returnHistoryByDates);
		return "returnHistorySearchPage";
	}

	//========== 반납 점검 이력 관리 ==============

	@GetMapping("/gotoReturnConditionSettingDetailPage") //점검이력관리페이지로이동
	public String gotoReturnConditionSettingDetailPage(ReturnConditionSettingDTO rConditionDTO,
			Model model) {
		System.out.println("gotoReturnConditionSettingDetailPage 로그");

		List<ReturnConditionSettingDTO> rConditionDTOList = rConditionService.selectAllSetting();
		model.addAttribute("rConditionDTOList",rConditionDTOList);

		return "returnConditionSettingDetailPage";
	}

	@PostMapping("/updateConditionSetting")// 반납 점검 항목 내용 수정
	public String updateConditionSetting(
			@RequestParam("exteriorConditionId") List<Integer> exteriorConditionIds,
			@RequestParam("interiorConditionId") List<Integer> interiorConditionIds,
			@RequestParam("exteriorConditionDisplay") List<String> exteriorConditionDisplays,
			@RequestParam("interiorConditionDisplay") List<String> interiorConditionDisplays,
			RedirectAttributes rattr
			) {
		System.out.println("updateConditionSetting로그");
		System.out.println("exteriorConditionId : " + exteriorConditionIds);
		System.out.println("interiorConditionId : " + interiorConditionIds);
		System.out.println("exteriorConditionDisplay : " + exteriorConditionDisplays);
		System.out.println("interiorConditionDisplay : " + interiorConditionDisplays);

		int biggerLength = 0;

		if(exteriorConditionIds.size() >= interiorConditionIds.size()) {
			biggerLength = exteriorConditionIds.size();
		} else biggerLength = interiorConditionIds.size();
		
		List<ReturnConditionSettingDTO> rConditionDTOList = new ArrayList<>();    	

		for(int i = 0; i < biggerLength; i++) {
			ReturnConditionSettingDTO dto = new ReturnConditionSettingDTO();
	        dto.setExteriorConditionId(exteriorConditionIds.get(i));
	        dto.setInteriorConditionId(interiorConditionIds.get(i));
	        dto.setExteriorConditionDisplay(exteriorConditionDisplays.get(i));
	        dto.setInteriorConditionDisplay(interiorConditionDisplays.get(i));
	        rConditionDTOList.add(dto);
		}

		rConditionService.updateConditions(rConditionDTOList);
		System.out.println("rConditionDTOList : " + rConditionDTOList);
		rattr.addFlashAttribute("message","returnConditionsChanged");
		
		return "redirect:gotoReturnConditionSettingDetailPage";
	}

	//반납할 때 점검한 이력 조회
	@GetMapping("/returnConditionHistoryPage")
	public String returnConditionHistoryPage(Model model) {
		System.out.println("returnConditionHistoryPage 로그");
		
		List<ReturnTargetDTO> conditionsOnReturnList = bookRentalService.selectConditionsWhenReturned();
		model.addAttribute("bookList",conditionsOnReturnList);
		System.out.println("conditionsOnReturnList : " + conditionsOnReturnList);
		
		
		List<ReturnConditionSettingDTO> rConditionDTOList = rConditionService.selectAllSetting();
		model.addAttribute("rConditionDTOList",rConditionDTOList);
		
		return "returnConditionHistory";
	}
	
	@PostMapping("/returnConditionHistoryPage") //반납할 때 점검한 이력 검색 조회
	public String returnConditionHistoryPagePost(Model model, ReturnTargetDTO rTargetDTO) {
		System.out.println("returnConditionHistoryPage Post 로그 ");
		
		List<ReturnTargetDTO> conditionsOnReturn = bookRentalService.searchConditionWhenReturned(rTargetDTO);
		model.addAttribute("bookList",conditionsOnReturn);
		System.out.println("bookList : " + conditionsOnReturn);
		
		List<ReturnConditionSettingDTO> rConditionDTOList = rConditionService.selectAllSetting();
		model.addAttribute("rConditionDTOList",rConditionDTOList);
		
		return "returnConditionHistory";
	}
	
}
