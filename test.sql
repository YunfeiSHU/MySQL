-- Active: 1725676203205@@127.0.0.1@3306@test
-- 表结构
#1 创建user_details表：注意EXISTS拼写；除最后一行，每行的`,`；每行命令`;`划分
CREATE TABLE IF NOT EXISTS user_details(
    ID int PRIMARY KEY AUTO_INCREMENT,
    Gender varchar(1) DEFAULT "男",
    Hobbies char(50)
);
CREATE TABLE IF NOT EXISTS user(
    ID int PRIMARY KEY AUTO_INCREMENT,
    Name char(8) NOT NULL DEFAULT "",
    Age int ,
    d_ID int UNIQUE,
    FOREIGN KEY (d_ID) REFERENCES user_details(ID)
);
#2 修改表中列结构：
#2.1 ADD 给 user_details 表，添加 user_ID 并设置UNIQUE
ALTER TABLE user_details ADD user_ID int UNIQUE;
#2.2 ALTER DROP 删除 user表 Name默认值的约束
ALTER TABLE user ALTER Name DROP  DEFAULT;
#2.3 ALTER ADD 给user_details创建外键约束，形成严格的一对一关系
ALTER TABLE user_details ADD FOREIGN KEY (user_ID) REFERENCES user(ID);
#2.4 修改user表的d_ID,为details_ID：
#MySQL 不会自动更新外键约束中的列名，因此你需要手动：删除旧约束，添加新约束
ALTER TABLE user RENAME COLUMN d_ID TO details_ID;
# 查找外键约束的id
SELECT CONSTRAINT_NAME 
FROM information_schema.KEY_COLUMN_USAGE 
WHERE TABLE_NAME = 'user' AND COLUMN_NAME = 'details_ID';#运行位置：修改表名前：用d_ID; 修改表名后：用details_ID
#   查询到的第一行，是旧字段名
#删除旧外键约束
ALTER TABLE user DROP FOREIGN KEY user_ibfk_1; # user_ibfk_1为查询到的外键约束id；（MySQL默认给我们的id）
#添加新外键约束
ALTER TABLE user ADD FOREIGN KEY (details_ID) REFERENCES user_details(ID);

ALTER TABLE user DROP details_ID;


-- 表数据
# 插入数据项
INSERT INTO user VALUES(1,'SYF',19,1);
INSERT INTO user_details VALUEs(1,'男','coding&reading',1);
INSERT INTO user VALUES(2,'syf',16,2);
INSERT INTO user_details VALUEs(2,'女','coding&reading',2);
INSERT INTO user VALUES(3,'syf',16,3);
# 删除
DELETE FROM  user WHERE ID=3;
# 修改字段值
#UPDATE user_details SET ID = 3 WHERE ID = 2;

-- 分组
SELECT `ID`,`Age` FROM user WHERE `ID` BETWEEN 1 AND 2 GROUP BY `Age`,`ID`;
SELECT MIN(Age) AS min_age FROM user  ;
SELECT MAX(Age)AS max_age,MIN(Age) AS min_age,COUNT(Age) AS count_age  FROM user HAVING min_age>0;
SELECT MAX(Age)AS max_age,MIN(Age) AS min_age,COUNT(Age) AS count_age  FROM user GROUP BY Age HAVING min_age>0;

-- 子查询
# 查找user表在user_details表有数据的ID Name Age
SELECT * FROM `user` WHERE ID IN (SELECT user_ID FROM user_details GROUP BY `user_ID` ) ;
# 查找user表中Age > AVG 的 信息
SELECT ID,Name,Age  FROM user WHERE Age > (SELECT AVG(Age) FROM user) 

-- 组合查询UNION
# 伪实现，查找user表在user_details表有数据的所有数据
# 伪实现；UNOIN的俩个查询是独立的，不能表名.字段
SELECT * FROM `user` WHERE ID IN (SELECT user_ID FROM user_details GROUP BY `user_ID` )  
UNION
SELECT user_ID ,Gender ,Hobbies  FROM user_details WHERE user_ID IN (SELECT ID FROM user GROUP BY ID); #发现user_ID,Gender,Hobbies 被竖向合并，而非横向扩展

-- 表连接
# 真实现：利用表连接，轻松实现查询所有数据
# WHERE,HAVING 都只能对单个表，进行条件约束
# ON 限制条件: ON 之后的限制条件，可以是多个表字段 
# INNER JOIN ... ON ... : 返回两表中满足ON约束的数据
SELECT  user.`ID`,user.`Name`,user.`Age`,user_details.`Gender`,user_details.`Hobbies` FROM user INNER JOIN user_details on user.`ID` = user_details.`user_ID`;
# LEFT JOIN ... ON ... : 返回左表中所有数据，右表中满足要求的数据
SELECT  user.`ID`,user.`Name`,user.`Age`,user_details.`Gender`,user_details.`Hobbies` FROM user LEFT JOIN user_details on user.`ID` = user_details.`user_ID`;
# RIGHT JOIN ... ON ... : 返回右表所有数据，左表满足要求的数据
SELECT  user.`ID`,user.`Name`,user.`Age`,user_details.`Gender`,user_details.`Hobbies` FROM user RIGHT JOIN user_details on user.`ID` = user_details.`user_ID`;

-- 排序
SELECT * FROM user ORDER BY age ASC;
SELECT * FROM user ORDER BY age DESC;

-- 限定前几个数据
# 升序LIMIT 1: min
SELECT * FROM user ORDER BY age Limit 1;
# 降序LIMIT1： max
SELECT * FROM user ORDER BY age DESC Limit 1;

# 综合使用连接，分组与排序
SELECT * FROM user INNER JOIN user_details ON user.`ID`=user_details.`user_ID` GROUP BY user.ID  ORDER BY Age LIMIT 2;
