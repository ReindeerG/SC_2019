package com.summer.todo.service;

import java.util.List;

import com.summer.todo.entity.TodoDto;

public interface TodoService {
	public List<TodoDto> getAllList();
	
	public List<TodoDto> getDeadList();
	
	public List<TodoDto> setFired(List<TodoDto> allList, List<TodoDto> deadList);
	
	public boolean insert(String title, String note, int priority, boolean deadable, String deaddate, String deadtime);
	
	public boolean modify(int no, String title, String note, int priority, boolean deadable, String deaddate, String deadtime, int complete);
	
	public boolean order(int[] sequence);
	
	public boolean delete(int no);
}
