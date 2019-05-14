package com.summer.todo.repository;

import java.util.List;

import com.summer.todo.entity.TodoDto;

public interface TodoDao {
	public List<TodoDto> getAllList();
	public List<TodoDto> getDeadList();
	
	public void vseqUp();
	public void order(TodoDto todoDto);
	public void insert(TodoDto todoDto);
	public void update(TodoDto todoDto);
	public void delete(int no);
	
	public String setStrDeadline(TodoDto todoDto);
}
