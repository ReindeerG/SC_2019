package com.summer.todo.configuration;

import java.io.IOException;
import javax.sql.DataSource;
import org.apache.ibatis.session.SqlSessionFactory;
import org.mybatis.spring.SqlSessionFactoryBean;
import org.mybatis.spring.SqlSessionTemplate;
import org.springframework.context.ApplicationContext;
import org.springframework.context.annotation.Bean;
import org.springframework.context.annotation.Configuration;

@Configuration
public class MybatisConfig {
	@Bean
	public SqlSessionFactoryBean sqlSessionFactory(DataSource dbcpSource, ApplicationContext context) throws IOException {
		SqlSessionFactoryBean factory = new SqlSessionFactoryBean();
		factory.setDataSource(dbcpSource);
		factory.setConfigLocation(context.getResource("classpath:/mybatis/mybatis-config.xml"));
		factory.setMapperLocations(context.getResources("classpath:/mybatis/mapper/*-mapper.xml"));
		return factory;
	}
	
	@Bean
	public SqlSessionTemplate sqlSession(SqlSessionFactory sqlSessionFactory) {
		SqlSessionTemplate template= new SqlSessionTemplate(sqlSessionFactory);
		return template;
	}
}