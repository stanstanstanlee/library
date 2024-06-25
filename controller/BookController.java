package com.kim.app.controller;

import com.kim.app.dto.BookDTO;
import com.kim.app.dto.BookStkDTO;
import com.kim.app.service.BookService;
import com.kim.app.service.BookStkService;
import lombok.RequiredArgsConstructor;
import org.springframework.http.HttpStatus;
import org.springframework.http.ResponseEntity;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.*;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import java.util.HashMap;
import java.util.List;
import java.util.Map;

@RequiredArgsConstructor
@Controller
public class BookController {

    private final BookService bookService;
    private final BookStkService bookStkService;

    @GetMapping("/bookPage") //책 관리 목록 //전체조회
    public String bookPage(Model model) {
        System.out.println("bookPageGET로그");
        List<BookDTO> bList = bookService.selectAll();
        System.out.println("bList : " + bList);
        model.addAttribute("bList", bList);
        return "book";
    }
    
    @PostMapping("/bookPage") //책 목록, 검색
    public String bookPagePost(BookDTO bDTO, Model model) {
        System.out.println("bookPagePost메서드 로그: " + bDTO);
        //List<BookDTO> bList = bookService.getBookBySearchText(bDTO.getSearchText());
        List<BookDTO> bList = bookService.getBookBySearchTextAndDate(bDTO);
        System.out.println("bList 로그 : " + bList);
        model.addAttribute("bList", bList);
        return "book";
    }

    //	@PostMapping("/stockDetailSearch") // 재고검색
//	@ResponseBody
//	public ResponseEntity<Map<String, Object>> stockDetailSearch(@ModelAttribute BookStkDTO bStkDTO, Model model) {
//	    System.out.println("stockDetailSearch 로그");
//	    Map<String, Object> response = new HashMap<>();
//
//	    try {
//	        int bookStkNum = Integer.parseInt(bStkDTO.getSearchText());
//	        bStkDTO.setBookStkNum(bookStkNum);
//	        System.out.println("bStkDTO after set : " + bStkDTO);
//	        List<BookStkDTO> bStkList = bookStkService.getAllStkByStkNumWithBookNum(bStkDTO);
//	        response.put("bStkList", bStkList);
//	    } catch (NumberFormatException e) {
//	        e.printStackTrace();
//	    }
//
//	    return ResponseEntity.ok(response);
//	}
//	
    @GetMapping("/goToStockSearchPage") //재고탐색 화면으로 이동
    public String goToStockSearchPage() {
        System.out.println("goToStockSearchPage로그");
        return "stockSearchPage";
    }

    @PostMapping("/searchStock") //재고탐색에서 재고번호로만 검색 액션
    public ResponseEntity<Map<String, Object>> searchStock(@ModelAttribute BookStkDTO bStkDTO, Model model) {
        System.out.println("searchStock액션로그");
        Map<String, Object> response = new HashMap<>();
        try {
            // 검색어가 null이거나 빈 문자열이면 전체 재고를 불러오기
            if (bStkDTO.getSearchText() == null || bStkDTO.getSearchText().trim().isEmpty()) {
                System.out.println("searchStock 액션 : searchAll 로그");
                List<BookStkDTO> bStkList = bookStkService.getAllStkByStkNum(bStkDTO);
                response.put("bStkList", bStkList);
            } else {
                // 검색어가 숫자로 변환 가능한 경우에만 검색 수행
                int bookStkNum = Integer.parseInt(bStkDTO.getSearchText());
                bStkDTO.setBookStkNum(bookStkNum);
                System.out.println("bStkDTO after set : " + bStkDTO);
                List<BookStkDTO> bStkList = bookStkService.getAllStkByStkNum(bStkDTO);
                response.put("bStkList", bStkList);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }
        return ResponseEntity.ok(response);
    }

    @PostMapping("/stockDetailSearch") // 재고상세에서 ISBN이 강제된 재고번호 검색 액션
    @ResponseBody
    public ResponseEntity<Map<String, Object>> stockDetailSearch(@ModelAttribute BookStkDTO bStkDTO, BookDTO bDTO, Model model) {
        System.out.println("stockDetailSearch 로그");
        Map<String, Object> response = new HashMap<>();
        try {
            // 검색어가 null이거나 빈 문자열이면 전체 재고를 불러오기
            if (bStkDTO.getSearchText() == null || bStkDTO.getSearchText().trim().isEmpty()) {
                System.out.println("stockDetailSearch: searchAll 로그");
                bDTO.setBookNum(bStkDTO.getBookNum());
                List<BookStkDTO> bStkList = bookStkService.getAllStkByBookNum(bDTO);
                response.put("bStkList", bStkList);
            } else {
                // 검색어가 숫자로 변환 가능한 경우에만 검색 수행
                int bookStkNum = Integer.parseInt(bStkDTO.getSearchText());
                bStkDTO.setBookStkNum(bookStkNum);
                System.out.println("bStkDTO after set : " + bStkDTO);
                List<BookStkDTO> bStkList = bookStkService.getAllStkByStkNumWithBookNum(bStkDTO);
                response.put("bStkList", bStkList);
            }
        } catch (NumberFormatException e) {
            e.printStackTrace();
        }

        return ResponseEntity.ok(response);
    }


    @GetMapping("/bookDetail") //책 1권 상세
    public String bookDetail(@RequestParam("bookNum") String bookNum,
                             //@ModelAttribute("bookNum") int bookNum,
                             BookDTO bDTO, Model model) {
        System.out.println("bookDetail 로그");
        System.out.println("bDTO 전 : " + bDTO);
        bDTO.setBookNum(bookNum);
        bDTO = bookService.getBookByNum(bDTO);
        bDTO.setBookQty(bookService.countBookStkByBookNum(bDTO)); //재고 카운트한 후 셋
        System.out.println("bDTO 후 : " + bDTO);
        model.addAttribute("data", bDTO);
        return "bookDetail";
    }

    @GetMapping("/stockDetail") //재고 상세
    public String stockDetail(@RequestParam("bookNum") String bookNum, BookDTO bDTO, Model model) {
        System.out.println("stockDetail 로그");
        System.out.println("bDTO : " + bDTO);
        //bDTO.setBookNum(bookNum);

        bDTO = bookService.getBookByNum(bDTO);

        List<BookStkDTO> bStkList = bookStkService.getAllStkByBookNum(bDTO);
        System.out.println("bStkList : " + bStkList);
        model.addAttribute("bStkList", bStkList);
        model.addAttribute("data", bDTO);
        return "stockDetail";
    }

    @GetMapping("/addBookPage") //도서 추가 화면 이동
    public String addBookPage() {
        System.out.println("addBookPage로그");
        return "addBook";
    }

    @PostMapping("/insertBook") //도서 추가 액션
    public String addBook(BookDTO bDTO, Model model, RedirectAttributes rattr) {
        System.out.println("addBook 로그");
        System.out.println("bDTO : " + bDTO);
        
        /*
         * BookDTO bdata = bookService.getBookByTitleAndAuthor(bDTO);
         *
         * if(bdata == null) { if(bookService.insert(bDTO)) {
         * System.out.println("addBook로그 : 도서 추가 성공");
         * rattr.addFlashAttribute("message","addBookSuccess"); return
         * "redirect:/bookPage"; } else { System.out.println("addBook 로그 : 추가 실패");
         * rattr.addFlashAttribute("message","addBookFail"); return
         * "redirect:/addBookPage"; } } System.out.println("addBook 로그 : 도서 + 저자 중복");
         * rattr.addFlashAttribute("message","addBookDuplicate");
         * return "redirect:/addBookPage";
         */

        bookService.insert(bDTO);
        System.out.println("addBook로그 : 도서 추가 성공");
        rattr.addFlashAttribute("message", "addBookSuccess");
        return "redirect:/bookPage";

//		System.out.println("addBook 로그 : 도서 추가 실패");
//		rattr.addFlashAttribute("message","addbookFail");
//		return "redirect:/addbook";
    }

    @PostMapping("/updateBook")//도서 정보 변경
    public String updateBook(BookDTO bDTO, Model model, RedirectAttributes rattr) {
        System.out.println("updateBook 로그");
        System.out.println("bDTO : " + bDTO);

        //이미 존재 하는 똑같은 책저자 + 책이름으로 변경 못해야 함
        //BookDTO bdata = bookService.getBookByTitleAndAuthor(bDTO);

        //if(bdata == null) {
        if (bookService.update(bDTO)) {
            System.out.println("책 정보 변경 성공");
            rattr.addFlashAttribute("message", "updateBookSuccess");
        } else {
            System.out.println("책 정보 변경 실패");
            rattr.addFlashAttribute("message", "updateBookFail");
        }
        //}
//		else {
//			System.out.println("책 이름 + 저자 중복");
//			rattr.addFlashAttribute("message", "updateBookFailDuplicate");
//		}
        return "redirect:/bookDetail?bookNum=" + bDTO.getBookNum();
    }

    @GetMapping("/deleteBook")//1개 삭제 (상세페이지에서 삭제)
    public String deleteBook(BookDTO bDTO, Model model, RedirectAttributes rattr) {
        System.out.println("deleteBook 로그");
        System.out.println("bDTO : " + bDTO);

        if (bookService.delete(bDTO)) {//도서삭제
            if (bookStkService.deleteAllStkByBookNum(bDTO)) {//재고 삭제
                System.out.println("재고 삭제 성공");
            } else {
                System.out.println("재고삭제실패");
                rattr.addFlashAttribute("message", "deleteStkFail");
                return "redirect:/bookDetail?bookNum=" + bDTO.getBookNum();
            }
            System.out.println("책 정보 삭제 성공");
            rattr.addFlashAttribute("message", "deleteBookSuccess");
            return "redirect:/bookPage";
        }

        System.out.println("책 정보 삭제 실패");
        rattr.addFlashAttribute("message", "deleteBookFail");
        return "redirect:/bookDetail?bookNum=" + bDTO.getBookNum();
    }

    @PostMapping("/deleteSelectedBooks") //일괄삭제
    public ResponseEntity<String> deleteSelectedBooks(@RequestBody List<Integer> selectedBooks) {
        System.out.println("deleteSelectedBooks 로그");
        System.out.println("selectedBooks : " + selectedBooks);
        try {
            bookService.deleteBooks(selectedBooks);
            System.out.println("selectedBooks" + selectedBooks);
            System.out.println("일괄 삭제 성공");
            return new ResponseEntity<>("삭제 성공", HttpStatus.OK);
        } catch (Exception e) {
            System.out.println("일괄 삭제 실패");
            return new ResponseEntity<>("삭제 실패", HttpStatus.INTERNAL_SERVER_ERROR);
        }
    }
    

}
