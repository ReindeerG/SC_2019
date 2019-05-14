package com.summer.todo.controller;

import java.io.IOException;

import javax.servlet.http.HttpServletResponse;

import org.slf4j.Logger;
import org.slf4j.LoggerFactory;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Controller;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestParam;

import com.summer.todo.service.TodoService;

/**
 * ajax를 통한 데이터 전송을 모아둠.
 * 항목추가, 삭제, 수정, 순서변경이 있음.
 */
@Controller
@RequestMapping("/ajax")
public class AjaxController {
	@Autowired
	private TodoService todoService;
	
	private static final Logger logger = LoggerFactory.getLogger(AjaxController.class);
	
	@RequestMapping("/new")
	public String ajaxnew(@RequestParam String title,
						@RequestParam(required=false) String note,
						@RequestParam int priority,
						@RequestParam boolean deadable,
						@RequestParam(required=false) String deaddate,
						@RequestParam(required=false) String deadtime,
						HttpServletResponse response) throws IOException {
		boolean result = todoService.insert(title, note, priority, deadable, deaddate, deadtime);
		response.setContentType("text/plain; charset=UTF-8");
		if(result) {
			response.getWriter().print("OK");
		} else {
			response.getWriter().print("FAIL");
		}
		return null;
	}
	
	@RequestMapping("/del")
	public String ajaxdel(@RequestParam int no,
							HttpServletResponse response) throws IOException {
		boolean result = todoService.delete(no);
		response.setContentType("text/plain; charset=UTF-8");
		if(result) {
			response.getWriter().print("OK");
		} else {
			response.getWriter().print("FAIL");
		}
		return null;
	}
	
	@RequestMapping("/mod")
	public String ajaxmod(@RequestParam int no,
						@RequestParam String title,
						@RequestParam(required=false) String note,
						@RequestParam int priority,
						@RequestParam boolean deadable,
						@RequestParam(required=false) String deaddate,
						@RequestParam(required=false) String deadtime,
						@RequestParam int complete,
						HttpServletResponse response) throws IOException {
		boolean result = todoService.modify(no, title, note, priority, deadable, deaddate, deadtime, complete);
		response.setContentType("text/plain; charset=UTF-8");
		if(result) {
			response.getWriter().print("OK");
		} else {
			response.getWriter().print("FAIL");
		}
		return null;
	}
	
	/**
	 * 사용자가 순서를 설정하면, 항목들의 고유번호를 위에서 아래로 순서대로 배열로 하여 값을 받음.
	 * 이 값 순서를 토대로 순서를 재설정함.
	 */
	@RequestMapping("/order")
	public String ajaxorder(@RequestParam int[] sequence,
						HttpServletResponse response) throws IOException {
		boolean result = todoService.order(sequence);
		response.setContentType("text/plain; charset=UTF-8");
		if(result) {
			response.getWriter().print("OK");
		} else {
			response.getWriter().print("FAIL");
		}
		return null;
	}
}
