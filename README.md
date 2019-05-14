# Summer Coding 2019
https://sc2019.herokuapp.com/home

JDK: 1.8

framework: spring MVC

DB: MariaDB(MySQL)



DB Table(1개)

>TABLE TODO(

>	NO INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,

>	VSEQ INT(11) UNSIGNED NOT NULL,

>	TITLE VARCHAR(100) NOT NULL,

>	NOTE VARCHAR(3000),

>	DEADABLE TINYINT(1) UNSIGNED NOT NULL,

>	DEADLINE DATETIME,

>	PRIORITY TINYINT(1) UNSIGNED NOT NULL,

>	COMPLETE TINYINT(1) UNSIGNED NOT NULL

>);


* * *

설치 외 바로체험은
https://sc2019.herokuapp.com/home


* * *

1. JDK 1.8 설치

```sudo yum install java-1.8.0-openjdk.x86_64```


2. 환경변수 추가

```vi /etc/profile```

>JAVA_HOME=/usr/bin/java

>CLASSPATH=.:$JAVA_HOME/lib/tools.jar

>PATH=$PATH:$JAVA_HOME/bin

>export JAVA_HOME CLASSPATH PATH


3. 서버 설치(tomcat8)

```sudo yum install tomcat8```


4. 톰캣 시작(설치 제대로 되었나 확인)

```sudo service tomcat8 start```


5. 톰캣의 webapps 폴더로 war파일 옮기기

```mv ./SC2019.war /usr/share/tomcat8/webapps/SC2019.war```


6. 톰캣 재시작(war파일 자동해제)

```sudo service tomcat8 restart```


7. 접속(톰캣 기본 접속포트가 8080일 경우)
http://localhost:8080/SC2019/home


* * *

+ DB까지 설치하고 싶다면,

1. MariaDB 설치 정보 받기(/etc/yum/yum.repos.d/mariadb.repo)

```curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash```


2. MariaDB 설치

```yum install MariaDB-server```


3. MariaDB 실행

```systemctl start mariadb```


4. MariaDB root 암호설정

```mysql_secure_installation```


5. MariaDB root로 로그인

```mysql -u root -p```


6. mysql DB를 사용.

```use mysql```


6-1. 없으면 생성(show databases로 확인가능)

```create database mysql```
```use mysql```


7. 테이블 생성

```CREATE TABLE TODO(NO INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT, VSEQ INT(11) UNSIGNED NOT NULL, TITLE VARCHAR(100) NOT NULL, NOTE VARCHAR(3000), DEADABLE TINYINT(1) UNSIGNED NOT NULL, DEADLINE DATETIME, PRIORITY TINYINT(1) UNSIGNED NOT NULL, COMPLETE TINYINT(1) UNSIGNED NOT NULL);```


8. 계정 생성

```create user '아이디'@'%' identified by '패스워드';```


9. 권한 부여

```grant all privileges on mysql.todo to '생성한아이디'@'%' identified by '패스워드';```
```flush privileges;```


10. DB 접속 정보를 수정(MariaDB 기본포트 3306일 때, 사용하기로 한 database명이 mysql일 때)

```vi ./SC2019/WEB-INF/classes/properties/db.properties```

>jdbc.url=jdbc:mariadb://localhost:3306/mysql

>jdbc.username=아이디

>jdbc.password=패스워드


11. 톰캣 재시작(수정된 정보 적용)

```sudo service tomcat8 restart```
