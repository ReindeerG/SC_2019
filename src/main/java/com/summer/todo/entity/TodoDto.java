package com.summer.todo.entity;

import java.util.Date;

import lombok.AllArgsConstructor;
import lombok.Builder;
import lombok.Data;
import lombok.NoArgsConstructor;

@Data
@NoArgsConstructor
@AllArgsConstructor
@Builder
public class TodoDto {
	private int no;
	private int vseq;
	private String title;
	private String note;
	private int deadable;
	private Date deadline;
	private int priority;
	private int complete;
	
	private String strdeadline;
	private boolean fired;
}
