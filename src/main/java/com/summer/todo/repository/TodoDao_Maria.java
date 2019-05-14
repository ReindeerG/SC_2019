package com.summer.todo.repository;

import java.text.SimpleDateFormat;
import java.util.List;

import org.apache.ibatis.session.SqlSession;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Repository;

import com.summer.todo.entity.TodoDto;

@Repository("todoDao")
public class TodoDao_Maria implements TodoDao {
	@Autowired
	private SqlSession sqlSession;
	
	private SimpleDateFormat format = new SimpleDateFormat("yyyy-MM-dd HH:mm");
	
	public void vseqUp() {
		sqlSession.update("db_maria_todo.vseq_1up");
	}
	
	public void insert(TodoDto todoDto) {
		this.vseqUp();
		sqlSession.insert("db_maria_todo.insert", todoDto);
	}
	
	public void update(TodoDto todoDto) {
		sqlSession.update("db_maria_todo.update", todoDto);
	}
	
	public void delete(int no) {
		sqlSession.delete("db_maria_todo.delete", no);
	}
	
	public void order(TodoDto todoDto) {
		sqlSession.update("db_maria_todo.order", todoDto);
	}
	
	/**
	 * OracleDB의 Date값(수로 표현된)을 날짜형식(yyyy-MM-dd HH:mm)에 맞춰 문자열로 저장.
	 */
	public String setStrDeadline(TodoDto todoDto) {
		String strdeadline = format.format(todoDto.getDeadline());
		return strdeadline;
	}
	
	public List<TodoDto> getAllList() {
		List<TodoDto> list = sqlSession.selectList("db_maria_todo.getalllist");
		for(TodoDto todoDto : list) {
			// 마감 기한이 있는 항목이라면 날짜형식 문자열을 사용하기 위해 설정해줌.
			if(todoDto.getDeadable()==1) todoDto.setStrdeadline(this.setStrDeadline(todoDto));
		}
		return list;
	}
	
	public List<TodoDto> getDeadList() {
		List<TodoDto> list = sqlSession.selectList("db_maria_todo.getdeadlist");
		for(TodoDto todoDto : list) {
			// 마감 기한이 있는 항목이라면 날짜형식 문자열을 사용하기 위해 설정해줌.
			if(todoDto.getDeadable()==1) todoDto.setStrdeadline(this.setStrDeadline(todoDto));
		}
		return list;
	}
}
