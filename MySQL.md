# MySQL

MySQL由Server端和存储引擎俩部分组成

![img](https://jums.gitbook.io/~gitbook/image?url=https%3A%2F%2Fstatic001.geekbang.org%2Fresource%2Fimage%2F0d%2Fd9%2F0d2070e8f84c4801adbfa03bda1f98d9.png&width=768&dpr=4&quality=100&sign=bb146dfe&sv=1)





## 连接MySQL服务器

```bash
### 从终端登录MySQL命令行
mysql -u root -h localhost -P 3306 -p #默认端口3306
mysql -u root -p #简写
```

- `mysql`：MySQL 命令行客户端的启动命令。

- `-u root`：指定用 `root` 这个用户名来连接数据库。

- `-h localhost`：指定连接的主机名为 `localhost`，也就是本地服务器。

- `-P 3306`：指定使用的端口号为 `3306`，这是 MySQL 的默认端口号。 **大写**

- `-p`：提示用户输入密码。你在运行这条命令后，会被要求输入与 `root` 用户名对应的密码。

  **MySQL本身是数据库管理的服务器，我们作为客户端登录，对数据库进行操作。**

  **MySQL最大支持的客户端连接数：151**

  **所有连接是**MySQL提供，而非我们创建

  **连接池**：一个连接，**可以**连接上多个数据库；但一次**只能**连上一个数据库

## 数据库结构

**MySQL数据库是关系型数据库**：数据库中的数据，**以表的形式存在**;多个表之间，**存在关系**（4种关系：1对1，多对1&1对多，多对多）

### 一对一

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/a2f35521154cf37ab35b6c410db614a6.png)

### 一对多&多对一

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/b9f58e65c42b1ce9be0839d864cd73c4.png)

### 多对多

![在这里插入图片描述](https://i-blog.csdnimg.cn/blog_migrate/e7ac5a9a1c8ce95746bffcab459c6683.png)
**中间表的创建规则：**
1、表名由多对多关系的两个表名称组成。
2、表中只有两个字段，分别建立外键关联到对应表的主键。
3、两个字段都是主键，组成联合主键。

## 命令：数据库操作

**MySQL命令：不区分大小写**

```mysql
# 查看数据库
show databases;
# 创建新的数据库db_name
create database db_name;
# 连接指定数据库
use db_name;
# 查看数据库中的表
show tables; #必须先执行use db01;
# 删除数据库
drop database db_name;
- 分号; 请不要忘记
```





## 表结构

数据表，由不同字段组成；字段由：不同类型的数据和一些约束条件构成

### 数据类型&约束条件

#### 数据类型

常用为以下三种类型（具体：请看使用手册https://mysql.net.cn/doc/refman/8.0/en/data-types.html）

- 数值型：

![img](https://i-blog.csdnimg.cn/direct/314f96af408e46ab952cd95b8cb29b32.png)

图片中，浮点数为：非精确值；精确浮点数DECIMAL

- 日期和时间类型：

![img](https://i-blog.csdnimg.cn/direct/8f3589f0f6c940329baf5e1d70611b98.png)

- 字符串类型：

![img](https://i-blog.csdnimg.cn/direct/63e02beb488647caa5d7d2a7329cd61b.png)



#### 约束条件

常用约束条件有以下这些

- **UNSIGNED** ：无符号，**值从0开始，无负数**
- **ZEROFILL**：零填充，当数据的显示长度不够的时候可以使**用前补0的效果填充至指定长度**,字段会自动添加UNSIGNED
- **NOT NULL**：非空约束，表示该字段的**值不能为空**
- **DEFAULT**：表示如果插入数据时没有给该字段赋值，那么就使用默认值
- **PRIMARY KEY**：主键约束，表示唯一标识，不能为空，且一个表只能有一个主键。一般都是用来约束id
- **AUTO_INCREMENT**：自增长，只能用于数值列，而且配合索引使用,默认起始值从1开始，每次增长1

- **UNIQUE KEY**：唯一值，表示该字段下的值不能重复，null除外。

  比如身份证号是一人一号的，一般都会用这个进行约束

  PRIMARY KEY 由 NOT NULL 和 UNIQUE KEY

- **FOREIGN KEY**：外键约束，目的是为了保证数据的完成性和唯一性，以及**实现多表：1对1或1对多关系**

- **INDEX**（别名**KEY**）:索引，常用分为：一般索引，唯一索引，主键索引，全文索引，组合索引，空间索引



## 命令：表结构操作 

#### 1创建表

**创建单独的表**

```mysql
-- 创建表
CREATE TABLE users (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 用户ID，自增，主键
    username VARCHAR(50) NOT NULL,     -- 用户名，长度最大为50，不允许为空
    email VARCHAR(100) NOT NULL,       -- 邮箱，长度最大为100，不允许为空
    password VARCHAR(255) NOT NULL,    -- 密码，长度最大为255，不允许为空
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP -- 创建时间，默认当前时间
);
```

**创建包含外键约束的多个表**

**一对多关系：**

```mysql
-- 创建 categories 表
CREATE TABLE categories (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 分类ID，自增，主键
    name VARCHAR(50) NOT NULL          -- 分类名称，长度最大为50，不允许为空
);

-- 创建 products 表，并添加外键约束
CREATE TABLE products (
    id INT AUTO_INCREMENT PRIMARY KEY, -- 产品ID，自增，主键
    name VARCHAR(100) NOT NULL,        -- 产品名称，长度最大为100，不允许为空
    price DECIMAL(10, 2) NOT NULL,     -- 价格，精度为10，小数点后2位，不允许为空
    category_id INT,                   -- 分类ID，外键
    created_at TIMESTAMP DEFAULT CURRENT_TIMESTAMP, -- 创建时间，默认当前时间
    FOREIGN KEY (category_id) REFERENCES categories(id) -- 外键约束
);
```

对于一对多关系，**多对应的表设置外键约束**：如公司和员工

**一对一关系：**

```mysql
CREATE TABLE user (
    id INT PRIMARY KEY,
    name VARCHAR(255),
   # user_detail_id INT UNIQUE,
   # FOREIGN KEY (user_detail_id) REFERENCES user_detail(id)
);

CREATE TABLE user_detail (
    id INT PRIMARY KEY,
    address VARCHAR(255),
    user_id INT UNIQUE,
    FOREIGN KEY (user_id) REFERENCES user(id)
);
```

对于一对一关系，怎么设置外键约束，看需求：

​	通常选择在一方设置外键（看约束），同时添加 `UNIQUE` 约束来确保一对一关系。

​	如果需要更强的约束，可以在双方表中互相设置外键。

**约束条件:**

- 设置默认值：`DEFAULT 值` 
- 非空：`NOT NULL`
- 自动递增：`AUTO_INCREMENT`
- 设置唯一约束：`定义字段 UNIQUE`;补充

- 主键：`PRIMARY KEY`

  默认表名对应的ID

- 外键：`FOREIGN KEY (category_id) REFERENCES categories(id)`

  

  

#### 2查看并修改表结构

```mysql
-- 1查看表
DESC 表名;

-- 2修改字段 
-- 2.1 添加字段：ADD
ALTER TABLE 表名 ADD (COLUMN) 字段名 字段类型;
-- 2.2 修改表字段：MODIFY/ALTER
# ALTER 修改：单独修改属性，不会影响列的其他属性。
ALTER TABLE 表名 ALTER (COLUMN) age DROP/SET DEFAULT;
# MODIFY 修改：需要重新声明约束条件，否则会重置
ALTER TABLE 表名 MODIFY 字段名 定义;
-- 2.3 修改字段名:RENAME COLUMN：
#修改字段名，旧外键约束不会改名；需要手动：删除旧命令，添加新命令
ALTER TABLE 表名 RENAME COLUMN 字段名 TO 新字段名;
ALTER TABLE 表名 CHANGE 字段名 新字段名 新的定义; #需要重新声明,即MODIFY+RENAME组合
-- 2.4 修改表名：RENAME
ALTER TABLE 表名 RENAME TO 新表名
-- 2.5 删除字段/外键约束：DROP 区分：删除约束条件（属于修改表字段）
ALTER TABLE 表名 DROP （COLUMN） 字段名; 

-- 3删除表
DROP TABLE 表名;
```

**命令的逻辑顺序：表结构-->字段结构/外键约束-->数据类型/字段约束条件**

关于修改约束条件

```mysql
-- 重定义：MODIFY
ALTER TABLE 表名 MODIFY (COLUMN) 字段名 字段类型 ...;
-- 添加/修改指定约束 ：ALTER
ALTER TABLE 表名 ADD  PRIMARY KEY (字段名) ; -- 添加主键
ALTER TABLE 表名 ADD  UNIQUE INDEX 索引名(字段) ; -- 添加唯一索引
-- 删除指定约束
ALTR TABLE 表名 DROP PRIMARY KEY; -- 删除表中建立的主键(一般一个表一个主键id) 
ALTER TABLE users DROP INDEX unique_email; -- 删除表中指定的唯一索引 
```





**案例：一对一关系**

```mysql
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

```



## 导入与导出数据表

**MySQL导入数据表：**MySQL导入数据，本质就是运行SQL文件；**MySQL高版本的SQL无法适配低版本的SQL**：如果使用的是MySQL57，为了日常使用，**请调换成MySQL80版本**

### 命令：导入与导出

```MySQL
# 导入：mysql
mysql -u username -p database_name < /path/to/imported_file.sql
# 导出：mysqldump
#导出单个表：结构+数据
mysqldump -u username -p database_name table_name > /path/to/exported_file.sql
#导出表结构，不导出数据
mysqldump -u username -p --no-data database_name table_name > /path/to/exported_file.sql
#导出数据，不导出表
mysqldump -u username -p --no-create-info database_name table_name > /path/to/exported_file.sql
#导出整个数据库
mysqldump -u username -p database_name > /path/to/exported_file.sql
#导出所有数据库
mysqldump -u username -p --all-databases > /path/to/exported_file.sql
```

### Navicat导入

![image-20240730091106072](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730091106072.png)



**右键数据库，点击运行SQL文件**

![image-20240730091223697](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730091223697.png)

![image-20240730091248588](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730091248588.png)

**在每个运行中，运行多个查询：**

勾选：Navicat会将SQL文件的语句，按照事务处理，批量执行；因为原子性，只要有一个操作失败，整个事务就会回滚到原状态。

不勾选：逐个执行SQL语句，即使遇到失败，之前操作的数据，也会保存在表中

**一般不勾选，确保导入成功率高；**如果失败，请参考https://blog.51cto.com/u_16099264/11739257

### Navicat导出

![image-20240730094731019](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730094731019.png)

结构和数据：得到表结构及表内数据；仅结构：只获得表结构。



## SQL语句---表数据

SQL：结构化查询语句；实现对表中数据的添加、修改、删除、查询操作

- 数字直接写
- 字符串用单引号‘ '（“ ”也可，但双引号一般用于标识符；为了区分，用' '）
-  SQL语句不区分大小写

### 添加--INSERT

#### 插入全部字段

**当插入部分字段：所有字段都有，且顺序与表结构相同——（字段...）省略**

- 添加数据的顺序，要与表结构顺序一致

```sql
在db02的表插入值（表结构）
INSERT INTO db02 VALUES(5,'小组','男');  
```

#### 插入部分字段

- 数据的顺序必须和指定字段的顺序一致、
- 部分字段，必须包括：非空字段

```sql
INSERT INTO db02(id,name) VALUES(6,'小李');
```

![image-20240723112446545](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240723112446545.png)

当之前的代码运行过了，需要：**选择未运行过的代码，点击运行选择的**

### 修改--UPDATE+WHERE

- 修改语句**必须添加where**条件，否则会修改表中的所有数据

  ```mysql
  //UPDATA 表 SET 修改字段名=值 WHERE 定位字段 ;
  UPDATE db02 SET name='abc',age=15 WHERE id =1;
  UPDATE db02 set age=22 WHERE name ='李四';
  ```

  

### 删除--DELETE+WHERE

- 删除语句必须添加where条件，否则会删除表中的所有数据

```sql
//RELETE FROM 表 WHERE 定位字段 ; 
DELETE FROM db02 WHERE id=5;
DELETE FROM db02 WHERE name='小丽';
```



### 查找--SELECT（+WHERE)

```mysql
--查看表的...数据: * 所有数据,字段名 查看特定字段的所有数据
SELECT * FROM 表名;
--查看特定条件（栏目）的数据
SELECT * FROM 表名 WHERE 定位字段;
```

### WHERE常用语句

`WHERE AND OR  IN  BETWEEN-ADN   LIKE  REGEXP`

```mysql
--1 WHERE AND OR
-- 查找id=1，栏目中所有的数据
SELECT * FROM 表名 WHERE ID=1;
-- 查找 1<id<5 栏目 中所有的数据
SELECT * FROM 表名 WHERE id > 1 AND id < 5;
-- 查找 id = 1，5
SELECT * FROM 表名 WHERE id = 1 OR id = 5;

--2 IN
--查找 id=1,5的栏目
SELECT * FROM 表名 WHERE ID IN (1,5);

--3 NOT 取反
SELECT * FROM 表名 WHERE ID NOT IN (1,5);

--4 BETWEEN AND
--查找[1,5]的栏目
SELECT * FROM 表名 WHERE ID BETWEEN 1 AND 5;

-- LIKE $任意个字符 _任意一个字符  "王$“姓王 "$王$"名字带王
SELECT * FROM 表名 WHERE 字段 LIKE “王$”;

--5 REGEXP 
-- 正则表达式  ^开头  $结尾   [abc]abc任意一个字符 [a-z]a-z任意一个字符  A|B A或者B
-- 查询姓王的所有栏目
SELECT * FROM 表名 WHERE 字段 REGEXP "^王$"; 
-- 查询名字里带王的数据
SELECT * FROM 表名 WHERE 字段 REGEXP "王";

--6 指定字段查询后，升序排列(降序)
--根据字段 默认升序排列ASC
SELECT * FROM 表名 ORDER BY 字段;
--根据字段 降序排列DESC
SELECT * FROM 表名 ORDER BY 字段 DESC;

--

```

#### 易错坑 null

`null`与所有值不相等，包括`null` 本身 ；

`null 不等于 空`

通过`IS NULL` 判断是不是NULL

```mysql
-- 查询值为NULL 的数据
SELECT * FROM 表名 WHERE 字段 IS NULL;
-- 查询为 空的数据
SELECT * FROM 表名 WHERE 字段 =''
```

#### 聚合函数---HAVING---GROUNP BY--ORDER BY

![image-20240730144405740](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730144405740.png)

![image-20240730144420601](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730144420601.png)

- 聚合函数 返回值，可以作为新字段
- `GROUP BY 字段` 以...分组
- `HAVING  condition` 表格只需要满足condition的栏目
- `ORDER BY 字段` 根据...排序，默认升序
- `LIMIT （值1，）值2`  值1 偏移量（默认为0）， 值2 限制在距离偏移量前多少名

`LIMIT 3,3  偏移量，查询数` 

#### UNION 

将 查询到的 数据，合并在一起---**会去除重复的数据**

![image-20240730144720934](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730144720934.png)

`UNION ALL` **不去除重复的数据**

#### DISTINCT

将 查询到 重复的数据，删去

![image-20240730144826063](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730144826063.png)

### 子查询

![image-20240730150104544](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730150104544.png)

`SELECT __ FROM 表名 AS 别名` **给查找__，返回的表 起别名**

**可以是 特定字段，聚合函数，子查询的表**

`SELECT/INSERT INTO/CREATE TABLE`的表名是一个`SELECT`语句，称为子查询



## 表连接

当俩个表时，我们会用父表的主键，赋值给子表的外键；

如何将这俩个表连接在一起。

### 内连接 (INNER JOIN)

内连接会返回两个表中满足连接条件的所有记录。

**语法：**

```mysql
SELECT columns
FROM table1
INNER JOIN table2
ON table1.column = table2.column;
```

**示例：**

假设有两个表 `employees` 和 `departments`，分别包含以下数据：

`employees` 表：

| id   | name | department_id |
| ---- | ---- | ------------- |
| 1    | John | 1             |
| 2    | Jane | 2             |
| 3    | Jack | 3             |

`departments` 表：

| id   | department_name |
| ---- | --------------- |
| 1    | HR              |
| 2    | IT              |

查询每个员工及其所属部门的名称：

```mysql
SELECT employees.name, departments.department_name
FROM employees
INNER JOIN departments
ON employees.department_id = departments.id;
```

结果：

| name | department_name |
| ---- | --------------- |
| John | HR              |
| Jane | IT              |

左连接---

### 左连接 (LEFT JOIN)

左连接会返回左表中的所有记录，以及右表中满足连接条件的记录。如果右表中没有匹配的记录，则返回 `NULL`。

**语法：**

```mysql
SELECT columns
FROM table1
LEFT JOIN table2
ON table1.column = table2.column;
```

**示例：**

```mysql
SELECT employees.name, departments.department_name
FROM employees
LEFT JOIN departments
ON employees.department_id = departments.id;
```

结果：

| name | department_name |
| ---- | --------------- |
| John | HR              |
| Jane | IT              |
| Jack | NULL            |

### 右连接 (RIGHT JOIN)

右连接会返回右表中的所有记录，以及左表中满足连接条件的记录。如果左表中没有匹配的记录，则返回 `NULL`。

**语法：**

```mysql
SELECT columns
FROM table1
RIGHT JOIN table2
ON table1.column = table2.column;
```

**示例：**

```mysql
SELECT employees.name, departments.department_name
FROM employees
RIGHT JOIN departments
ON employees.department_id = departments.id;
```

结果：

| name | department_name |
| ---- | --------------- |
| John | HR              |
| Jane | IT              |
| NULL | Marketing       |

### 语句格式

```mysql
---JOIN ON
-- 2查询新表格的指定字段
SELECT 字段
-- 1建立新表格
FROM 表1
___ JOIN  表2 
ON 表1.外键=表2.主键

方法2
--SELECT+WHERE 实现表连接
SELECT * FROM 表1(别名),表2(别名)
WHERE 表1.主键 = 表2.外键
```





## 索引

索引不一定提供约束，使用的目的是为了提高查找效率

### 案例

![image-20240730172420199](C:\Users\79042\AppData\Roaming\Typora\typora-user-images\image-20240730172420199.png)

### 具体格式

- 创建索引

```mysql
-- 创建普通索引
CREATE INDEX 索引名 ON 表名(字段名)

可以在创建表时，就创建 UNIQUE 和 PRIMARY KEY 约束
-- 创建唯一索引
CREATE UNIQUE INDEX idx_unique_column ON table_name(column_name);
-- 创建主键索引
ALTER TABLE table_name ADD PRIMARY KEY (column_name);
```

- 删除索引

```mysql
-- 删除普通和唯一索引
DROP INDEX index_name ON table_name;
-- 删除主键索引
ALTER TABLE table_name DROP PRIMARY KEY;
```



## 视图

视图是虚拟存在的表，会随着SELECT 语句返回的表 变化而变化

```mysql
-- 创建视图 CREATE VIEW - AS select语句
CREATE VIEW 视图名
AS
SELECT * FROM 表名 WHERE 指定字段 ;

-- 删除视图
DROP VIEW 视图名 ;
```

