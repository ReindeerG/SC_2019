package com.summer.todo.controller;

import java.util.List;

import javax.servlet.http.HttpServletRequest;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;

import com.summer.todo.entity.TodoDto;
import com.summer.todo.service.TodoService;

@Controller
public class HomeController {
	@Autowired
	private TodoService todoService;
	
	private static final Logger logger = LoggerFactory.getLogger(HomeController.class);
	
	/**
	 * DB에서 모든 목록과, 기한을 넘긴 목록을 불러옴.
	 * 총 목록 중 기한을 넘긴 목록에 속하는 항목은 추가적으로 fired boolean을 true로 표시.
	 * 
	 * 총 목록은 목록 출력에 사용,
	 * 기한을 넘긴 목록은 알림용으로 사용.
	 */
	@RequestMapping("/home")
	public String home(HttpServletRequest request) {
		List<TodoDto> allList = todoService.getAllList();
		List<TodoDto> deadList = todoService.getDeadList();
		if(!deadList.isEmpty()) allList = todoService.setFired(allList, deadList);
		request.setAttribute("alllist", allList);
		request.setAttribute("deadlist", deadList);
		return "/home";
	}
	
	// 에러처리 페이지는 구현하지 않음. 이 프로젝트에서 사용자에게 보여질 화면은 /home 밖에 없음.
	@RequestMapping("/error")
	public String error() {
		return "redirect:/home";
	}
}
