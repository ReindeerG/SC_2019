package com.summer.todo.service;

import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

import com.summer.todo.entity.TodoDto;
import com.summer.todo.repository.TodoDao;

@Service("todoService")
public class TodoService_Oracle implements TodoService {
	@Autowired
	private TodoDao todoDao;
	
	public List<TodoDto> getAllList() {
		return todoDao.getAllList();
	}
	
	public List<TodoDto> getDeadList() {
		return todoDao.getDeadList();
	}
	
	/**
	 * 총 목록에서 기한을 넘긴 항목이 있다면,
	 * 그 항목의 fired라는 boolean을 true로 세팅. 
	 */
	public List<TodoDto> setFired(List<TodoDto> allList, List<TodoDto> deadList) {
		for(TodoDto todoDto : allList) {
			if(deadList.contains(todoDto)) todoDto.setFired(true);
		}
		return allList;
	}
	
	public boolean insert(String title, String note, int priority, boolean deadable, String deaddate, String deadtime) {
		try {
			TodoDto todoDto = TodoDto.builder().title(title).note(note).priority(priority).build();
			if(deadable) {
				// 마감기한을 설정했을 경우, "YYYY/MM/DD 24HH:MI:SS"로 Oracle DB의 Date형식에 맞게 문자열을 설정.
				todoDto.setDeadable(1);
				todoDto.setStrdeadline(deaddate+" "+deadtime+":00");
			} else {
				todoDto.setDeadable(0);
			}
			todoDao.insert(todoDto);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	public boolean modify(int no, String title, String note, int priority, boolean deadable, String deaddate, String deadtime, int complete) {
		try {
			TodoDto todoDto = TodoDto.builder().no(no).title(title).note(note).priority(priority).complete(complete).build();
			if(deadable) {
				// 마감기한을 설정했을 경우, "YYYY/MM/DD 24HH:MI:SS"로 Oracle DB의 Date형식에 맞게 문자열을 설정.
				todoDto.setDeadable(1);
				todoDto.setStrdeadline(deaddate+" "+deadtime+":00");
			} else {
				todoDto.setDeadable(0);
			}
			todoDao.update(todoDto);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	/**
	 * 사용자가 정한 순서가 담긴 배열을 이용하여,
	 * 항목 하나씩 순서를 0부터 오름차순으로 재설정.
	 */
	public boolean order(int[] sequence) {
		try {
			TodoDto todoDto = new TodoDto();
			int index = 0;
			for(int i=0; i<sequence.length; i++) {
				todoDto.setNo(sequence[i]);
				todoDto.setVseq(index++);
				todoDao.order(todoDto);
			}
		} catch (Exception e) {
			return false;
		}
		return true;
	}
	
	public boolean delete(int no) {
		try {
			todoDao.delete(no);
		} catch (Exception e) {
			return false;
		}
		return true;
	}
}
