# Summer Coding 2019
https://sc2019.herokuapp.com/home

JDK: 1.8
framework: spring MVC
DB: MariaDB(MySQL)


DB Table(1��)

TABLE TODO(
	NO INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	VSEQ INT(11) UNSIGNED NOT NULL,
	TITLE VARCHAR(100) NOT NULL,
	NOTE VARCHAR(3000),
	DEADABLE TINYINT(1) UNSIGNED NOT NULL,
	DEADLINE DATETIME,
	PRIORITY TINYINT(1) UNSIGNED NOT NULL,
	COMPLETE TINYINT(1) UNSIGNED NOT NULL
);


* * *

��ġ �� �ٷ�ü����
https://sc2019.herokuapp.com/home


* * *

1. JDK 1.8 ��ġ
```sudo yum install java-1.8.0-openjdk.x86_64```


2. ȯ�溯�� �߰�
```vi /etc/profile```
JAVA_HOME=/usr/bin/java
CLASSPATH=.:$JAVA_HOME/lib/tools.jar
PATH=$PATH:$JAVA_HOME/bin
export JAVA_HOME CLASSPATH PATH


3. ���� ��ġ(tomcat8)
```sudo yum install tomcat8```


4. ��Ĺ ����(��ġ ����� �Ǿ��� Ȯ��)
```sudo service tomcat8 start```


5. ��Ĺ�� webapps ������ war���� �ű��
```mv ./SC2019.war /usr/share/tomcat8/webapps/SC2019.war```


6. ��Ĺ �����(war���� �ڵ�����)
```sudo service tomcat8 restart```


7. ����(��Ĺ �⺻ ������Ʈ�� 8080�� ���)
http://localhost:8080/SC2019/home


* * *

+ DB���� ��ġ�ϰ� �ʹٸ�,

1. MariaDB ��ġ ���� �ޱ�(/etc/yum/yum.repos.d/mariadb.repo)
```curl -sS https://downloads.mariadb.com/MariaDB/mariadb_repo_setup | sudo bash```


2. MariaDB ��ġ
```yum install MariaDB-server```


3. MariaDB ����
```systemctl start mariadb```


4. MariaDB root ��ȣ����
```mysql_secure_installation```


5. MariaDB root�� �α���
```mysql -u root -p```


6. mysql DB�� ���.
```use mysql```


6-1. ������ ����(show databases�� Ȯ�ΰ���)
```create database mysql```
```use mysql```


7. ���̺� ����
```CREATE TABLE TODO(
	NO INT(11) UNSIGNED PRIMARY KEY AUTO_INCREMENT,
	VSEQ INT(11) UNSIGNED NOT NULL,
	TITLE VARCHAR(100) NOT NULL,
	NOTE VARCHAR(3000),
	DEADABLE TINYINT(1) UNSIGNED NOT NULL,
	DEADLINE DATETIME,
	PRIORITY TINYINT(1) UNSIGNED NOT NULL,
	COMPLETE TINYINT(1) UNSIGNED NOT NULL
);```


8. ���� ����
```create user '���̵�'@'%' identified by '�н�����';```


9. ���� �ο�
```grant all privileges on mysql.todo to '�����Ѿ��̵�'@'%' identified by '�н�����';
flush privileges;```


10. DB ���� ������ ����(MariaDB �⺻��Ʈ 3306�� ��, ����ϱ�� �� database���� mysql�� ��)
```vi ./SC2019/WEB-INF/classes/properties/db.properties```
jdbc.url=jdbc:mariadb://localhost:3306/mysql
jdbc.username=���̵�
jdbc.password=�н�����


11. ��Ĺ �����(������ ���� ����)
```sudo service tomcat8 restart```