package com.kim.app.controller;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.ModelAttribute;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RequestParam;
import org.springframework.web.servlet.mvc.support.RedirectAttributes;

import com.kim.app.dto.MemberDTO;
import com.kim.app.service.MemberService;

import jakarta.servlet.http.HttpSession;

@Controller//메모리적제
public class MemberController {

	@Autowired//Member서비스레이어의존주입
	private MemberService memberService;

	// ==================멤버=====================

	@PostMapping("/login")//로그인액션
	public String login(MemberDTO mDTO, HttpSession session, RedirectAttributes rattr) {
		System.out.println("login로그");
		System.out.println("mDTO로그 : "+ mDTO);
		String mpwInput = mDTO.getMpw(); //사용자가 입력한 비밀번호 값
		String mpwDB = memberService.getPwById(mDTO.getMid()); //DB에 있는 실제 비밀번호 가져오기
		System.out.println("mpwInput = " + mpwInput);
		System.out.println("mpwDB = " + mpwDB);
		
		mDTO = memberService.selectOne(mDTO); 
		if(mDTO != null && mpwDB != null && mpwInput.equals(mpwDB)) {//성공시
			session.setAttribute("member", mDTO.getMid());
			session.setAttribute("auth", mDTO.getAuth());
			session.setMaxInactiveInterval(3600); // 60 * 60
			/*
			 * // 권한 정보 활용 String auth = mDTO.getAuth(); // mDTO에서 권한 정보를 가져옴 // 권한 정보를 모델에
			 * 추가하여 로그인 페이지로 전달 model.addAttribute("auth", auth);
			 */
			//System.out.println("mDTO로그인 성공 auth의 값: "+ auth);
			System.out.println("mDTO로그인 성공: "+ mDTO);
			return "loginPage";//로그인 성공시 로그인 화면
		}
		rattr.addFlashAttribute("message","incorrectId");
		
		if(mpwDB != null) {
			if(!mpwInput.equals(mpwDB)) {
				rattr.addFlashAttribute("message","incorrectPw");
			}
		}
		
		return "redirect:main"; //

	}

	@GetMapping("/menu")//메뉴화면으로이동
	public String gotoMenu(HttpSession session) {
		System.out.println("gotoMenu메서드 로그");
		String memberId = (String) session.getAttribute("member");
		String auth = (String) session.getAttribute("auth");
		System.out.println("memberId : " + memberId);
		System.out.println("auth : " + auth);
		return "loginPage";
	}

	@RequestMapping("/logout")//로그아웃액션
	public String logout(HttpSession session) {
		System.out.println("logout로그");
		session.removeAttribute("member");//세션에서 삭제
		session.removeAttribute("auth");
		System.out.println("session remove 완료");
		return "redirect:/main";//로그아웃후 메인페이지로
	}

	@RequestMapping(value = "/signupPage", method = RequestMethod.GET)
	public String signupPage() {//회원가입페이지로가기액션
		System.out.println("signupPage로그");
		return "join";//회원가입페이지
	}

	@RequestMapping(value = "/signup", method = RequestMethod.POST)//회원가입 액션
	public String signup(MemberDTO mDTO, Model model, RedirectAttributes rattr) {
		System.out.println("signup로그");
		System.out.println("mDTO로그 : " + mDTO);

		MemberDTO mdata = memberService.getMemberById(mDTO);

		if (mdata == null) { //기존에 없는 아이디라면
			memberService.insert(mDTO);//insert메서드로 새로운 회원 추가
			System.out.println("singup로그 : 회원가입성공");
			rattr.addFlashAttribute("message", "joined");
			return "redirect:userlistPage";

		} else {//기존에 있던 아이디라면 아이디 중복이기 때문에 회원가입 실패
			System.out.println("singup로그 : 중복된아이디");
			rattr.addFlashAttribute("message", "duplicate");
			return "redirect:signupPage"; //
		}
	}

	@RequestMapping("/check")//비밀번호 확인 페이지로
	public String checkPage() {
		System.out.println("check로그");
		return "check";//체크페이지로
	}

	@RequestMapping("/mypage")//마이페이지액션
	public String mypage(@RequestParam("mpw2") String enteredPassword,
			MemberDTO mDTO, Model model, HttpSession session, RedirectAttributes rattr) {
		System.out.println("mypage로그");
		System.out.println("mDTO로그 : "+ mDTO);

		mDTO.setMid((String)session.getAttribute("member"));//세션에 저장된 현재 로그인 회원아이디값을 불러와서 세팅
		System.out.println("mid : " + mDTO.getMid());


		mDTO = memberService.getMemberById(mDTO);
		//String mpwDB = memberService.getPwById(mDTO.getMid());//로그인된 회원의 실제 비밀번호 DB에서 가져오기
		String mpwDB = mDTO.getMpw();
		System.out.println("마이페이지 mDTO : " + mDTO);
		System.out.println("마이페이지 mpwDB : " + mpwDB);

		if(mDTO.getMpw() == null) {
			System.out.println("mDTO.getMpw() == null 로그");
			return "mypage";
		}

		if (!(enteredPassword.equals(mpwDB))) {
			rattr.addFlashAttribute("message", "incorrectPw");
			rattr.addFlashAttribute("mid", mDTO.getMid());
			return "redirect:check";
		}

		mDTO = memberService.selectOne(mDTO);
		System.out.println("selectOne 이후 mDTO : "+mDTO);
		model.addAttribute("data", mDTO);//성공 했다면 모델에 저장
		return "mypage";//마이페이지로 
	}

	@RequestMapping("/updateMember")//자기 비번 변경
	public String updateMember( MemberDTO mDTO, HttpSession session, Model model, RedirectAttributes rattr) {
		System.out.println("updateMember로그");
		mDTO.setMid((String)session.getAttribute("member"));//session에 저장된 현재 로그인한 회원의 아이디를 세팅 
		System.out.println("mDTO로그 : "+ mDTO);

		//boolean forceFail = true;

		if(memberService.update(mDTO)) {//새로 입력받은 비밀번호로 update메서드 수행 성공시
			System.out.println("updateMember로그 : 회원정보변경 성공");
			session.removeAttribute("member");//세션에서 제거 해서 로그아웃
			rattr.addFlashAttribute("message","changePwSuccess");
			return "redirect:main";
		}
		else {
			System.out.println("updateMember로그 : 회원정보변경 실패");
			rattr.addFlashAttribute("message","changePwFail");
			return "redirect:mypage"; 
		}
	}

	@RequestMapping("/updateMemberNew")//회원정보변경액션
	public String updateMemberNew( MemberDTO mDTO, Model model, RedirectAttributes rattr) {
		System.out.println("mDTO로그 : "+ mDTO);

		rattr.addFlashAttribute("mid", mDTO.getMid());
		if(memberService.updateMember(mDTO)) {
			System.out.println("updateMember로그 : 회원정보변경 성공");
			rattr.addFlashAttribute("message", "changedMember");
		}
		else {
			System.out.println("updateMember로그 : 회원정보변경 실패");
			rattr.addFlashAttribute("message", "memberChangeFail");
		}
		//return "redirect:userDetail?mid=" + mDTO.getMid();
		return "redirect:userDetail";
	}
	@RequestMapping("/deleteMemberSelf") //자기 아이디 회원탈퇴
	public String deleteMemberSelf(MemberDTO mDTO, HttpSession session, Model model, RedirectAttributes rattr) {
		System.out.println("deleteMemberSelf로그");
		System.out.println("삭제 할 mDTO: "+mDTO);
		mDTO.setMid((String)session.getAttribute("member"));//session에 저장된 현재 로그인한 회원의 아이디를 세팅 
		if(memberService.delete(mDTO)) {//삭제수행 성공시
			System.out.println("deleteMember로그 : 회원탈퇴 성공");
			session.removeAttribute("member");//세션에서 제거로 로그아웃
			System.out.println("deleteMember로그 : 세션제거 후");
			rattr.addFlashAttribute("message", "delMemSuccess");
			return "redirect:main";
		}
		else {
			System.out.println("deleteMember로그 : 사용자 삭제 실패");
			rattr.addFlashAttribute("message", "delMemFail");
			rattr.addFlashAttribute("mid", mDTO.getMid());
			return "redirect:mypage";
		}
	}

	@RequestMapping("/deleteMember")//관리자가 다른 사용자 삭제 액션
	public String deleteMember( MemberDTO mDTO, HttpSession session, Model model, RedirectAttributes rattr) {
		System.out.println("deleteMember로그");
		System.out.println("삭제 할 mDTO: "+mDTO);

		if(memberService.delete(mDTO)) {//삭제수행 성공시
			System.out.println("deleteMember로그 : 사용자 삭제 성공");	
			rattr.addFlashAttribute("message", "delMemSuccess");
			return "redirect:userlistPage";
		}
		else {//삭제 수행 실패 
			System.out.println("deleteMember로그 : 사용자 삭제 실패");
			rattr.addFlashAttribute("message", "delMemFail");
			rattr.addFlashAttribute("mid", mDTO.getMid());
			return "redirect:userDetail";
		}
	}

	@GetMapping("/userlistPage") //사용자 목록, 전체불러오기
	public String userListPage(Model model) {
		List<MemberDTO> list = memberService.selectAll();
		model.addAttribute("list", list);
		return "userlist";
	}

	@PostMapping("/userlistPage") //사용자 목록, 검색
	public String userListPagePost(MemberDTO memberDTO, Model model) {
		List<MemberDTO> list = memberService.getMemberByIdOrName(memberDTO.getSearchText());
		model.addAttribute("list", list);
		return "userlist";
	}

	@GetMapping("/userDetail") //사용자 1명 상세 
	public String userDetail(@ModelAttribute("mid") String mid,MemberDTO mDTO, Model model,HttpSession session,RedirectAttributes rattr) {
		System.out.println("userDetail 로그");
		mDTO.setMid(mid);
		System.out.println("mid : " + mid);
		System.out.println("mDTO 셀렉트 전"+ mDTO);
		mDTO = memberService.getMemberById(mDTO);
		System.out.println("mDTO 셀렉트 후:" + mDTO);

		model.addAttribute("data",mDTO);
		return "userDetail";
	}

	@RequestMapping("/resetPw") //비밀번호 초기화
	public String pwReset(MemberDTO mDTO, Model model, RedirectAttributes rattr) {
		System.out.println("resetPw 로그");
		System.out.println("mDTO : "+mDTO);
		mDTO.setMpw(mDTO.getMid());

		if(!memberService.update(mDTO)) {
			System.out.println("resetPw 로그 : 비밀번호 리셋 실패");
			rattr.addFlashAttribute("message","resetPwFail");
			rattr.addFlashAttribute("mid",mDTO.getMid());
		}
		System.out.println("resetPw 로그 : 비밀번호 리셋 성공");
		rattr.addFlashAttribute("message","resetPwSuccess");
		rattr.addFlashAttribute("mid",mDTO.getMid());
		return "redirect:userDetail";
	}

	//	@GetMapping("/searchMember") //사용자 검색 
	//	public String searchMember(@RequestParam(name = "member") String member, Model model) {
	//	    System.out.println("searchMember 메서드 로그");
	//		System.out.println("검색어: " + member);
	//	 
	//		List<MemberDTO> searchList = memberService.getMemberByIdOrName(member);
	//		System.out.println("검색 후 불러운 목록 : " + searchList);
	//		model.addAttribute("searchList", searchList);
	//	    return "searchUserList"; 
	//	}
	//	
}

