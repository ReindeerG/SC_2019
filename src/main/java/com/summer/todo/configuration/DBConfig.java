package com.summer.todo.configuration;

import javax.sql.DataSource;

import org.apache.commons.dbcp2.BasicDataSource;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;
import org.springframework.context.annotation.PropertySource;
import org.springframework.core.env.Environment;
import org.springframework.jdbc.core.JdbcTemplate;
import org.springframework.jdbc.datasource.DriverManagerDataSource;

@Configuration
@PropertySource({"classpath:/properties/db.properties"})
public class DBConfig {
	@Autowired
	private Environment env;
	
	@Bean
	public DataSource dataSource() {
		DriverManagerDataSource dataSource = new DriverManagerDataSource();
		dataSource.setDriverClassName(env.getProperty("jdbc.driver"));
		dataSource.setUrl(env.getProperty("jdbc.url"));
		dataSource.setUsername(env.getProperty("jdbc.username"));
		dataSource.setPassword(env.getProperty("jdbc.password"));
		return dataSource;
	}
	
	@Bean
	public DataSource dbcpSource() {
		BasicDataSource dbcpSource = new BasicDataSource();
		dbcpSource.setDriverClassName(env.getProperty("jdbc.driver"));
		dbcpSource.setUrl(env.getProperty("jdbc.url"));
		dbcpSource.setUsername(env.getProperty("jdbc.username"));
		dbcpSource.setPassword(env.getProperty("jdbc.password"));
		dbcpSource.setMaxTotal(Integer.parseInt(env.getProperty("jdbc.max-total")));
		dbcpSource.setMaxIdle(Integer.parseInt(env.getProperty("jdbc.max-idle")));
		dbcpSource.setMaxWaitMillis(Long.parseLong(env.getProperty("jdbc.max-wait")));
		return dbcpSource;
	}
	
	@Bean
	public JdbcTemplate jdbcTemplate(DataSource dataSource) {
		JdbcTemplate jdbcTemplate = new JdbcTemplate();
		jdbcTemplate.setDataSource(dataSource);
		return jdbcTemplate;
	}
}