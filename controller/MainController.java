package com.kim.app.controller;

import org.springframework.stereotype.Controller;
import org.springframework.ui.Model;
import org.springframework.web.bind.annotation.RequestMapping;

@Controller
public class MainController {
	
	@RequestMapping("/")//프로젝트실행
	public String root() {
		return "redirect:/main";
	}

	@RequestMapping("/main") //메인페이지로
	public String main(Model model) {
		System.out.println("main로그");
		return "main";
	}
}
