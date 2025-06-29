-- 新建数据库 dba_test
create database dba_test;

-- 使用 dba_test 数据库
use dba_test;

-- 创建用户表 user
-- id：自增主键
-- username：用户名，唯一
-- password：密码，至少6位
-- email：电子邮件，唯一
-- created_at：创建时间，默认当前时间戳
create table user
(
    id         serial primary key,
    username   varchar(50)  not null unique,
    password   varchar(255) not null check (length(password) >= 6),
    email      varchar(100) not null unique,
    created_at timestamp default current_timestamp
);

-- 查询 user 表的所有数据
select *
from user;

-- 查询 user 表的部分字段
select user.username as user_name, user.id as user_id, user.created_at as created_time
from user;

-- 创建角色表 role
-- id：自增主键，不为空 且唯一
-- name：角色名称，唯一 不为空
-- description：角色描述
create table role
(
    id          serial primary key not null unique,
    name        varchar(50)        not null unique,
    description text
);

-- 查询 role 表的所有数据
select *
from role;

alter table role
    add column city varchar(50) default '未知';

show columns from role;

SHOW CREATE TABLE role;

-- 假设唯一约束名为 `name`，则删除唯一约束
ALTER TABLE role DROP INDEX name;

-- 插入指定列数据（用户名，密码，邮箱）到user表中
insert into user (username, password, email)
values ('admin', 'admin123', 'admin@email.com'),
       ('user1', 'user123', 'user123@email.com');

-- 向user表中添加一个新字段 city 类型为varchar(50)
alter table user
    add column city varchar(50);

-- 向user表中添加一个新字段 score 类型为int，默认值为0
alter table user
    add column score int default 0;

-- 查询user表的所有列
show columns from user;

-- 向user表中添加一个新字段 last_login 类型为timestamp
alter table user
    add column last_login timestamp;

-- 删除user表中的last_login字段
alter table user
    drop column last_login;

show table status
    where name = 'user';

-- 向user表中随机添加100条数据
INSERT INTO user (username, password, email)
SELECT CONCAT('user', LPAD(FLOOR(RAND() * 100000), 5, '0')),
       CONCAT('pass', LPAD(FLOOR(RAND() * 100000), 5, '0')),
       CONCAT('user', LPAD(FLOOR(RAND() * 100000), 5, '0'), '@test.com')
FROM information_schema.tables
LIMIT 100;

insert into role (name, description, city)
select CASE
           WHEN RAND() < 0.2 THEN '辅导员'
           WHEN RAND() < 0.7 THEN '班长'
           ELSE '学生'
           END,
       CONCAT('Description for role', LPAD(FLOOR(RAND() * 1000), 3, '0')),
       CASE
           WHEN RAND() < 0.25 THEN '北京'
           WHEN RAND() < 0.5 THEN '上海'
           WHEN RAND() < 0.75 THEN '广州'
           ELSE '武汉'
           END
from information_schema.tables
limit 100;

-- 将北京、上海、广州、武汉 随机添加到user表的city字段中
UPDATE user
SET city = CASE
               WHEN RAND() < 0.25 THEN '北京'
               WHEN RAND() < 0.5 THEN '上海'
               WHEN RAND() < 0.75 THEN '广州'
               ELSE '武汉'
    END
WHERE city IS NULL;

-- 查询user表中以created_at 去除重复的数据
select distinct user.created_at
from user;

-- 查询user表中 username 字段以 user 开头 后面同时跟着5个任意字符的用户 并且城市信息不为空
select *
from user
where username like 'user_____'
  and user.city is not null;

-- 查询user表中城市数据为北京的用户id和用户名
select id as u_id, user.username as u_name
from user
where user.city = '北京';

-- 查询user表中城市数据为北京的用户数量
select count(user.id)
from user
where user.city = '北京';

-- 查询user表中城市数据为北京的用户，并且分数大于等于50 的用户数量
select count(user.id)
from user
where user.score >= 50
  and user.city = '北京';

-- 查询每个城市的用户数量，并按数量升序排列
select count(*) as total_users, city
from user
group by city
order by total_users;

-- 查询所有城市数量
select count(distinct (user.city)) citys
from user;

-- 查询所有城市名称
select distinct (user.city)
from user;

-- 查询北京用户的平均分数
select avg(user.score) as avg_score
from user
where user.city = '北京';

-- 查询北京用户的总分数
select sum(user.score) as total_scores
from user
where user.city = '北京';

-- 查询北京用户的最高分和最低分
select max(user.score) as max_score, min(user.score) as min_score
from user
where user.city = '北京';

-- 查询北京用户的最高分和最低分差距
select max(user.score) - MIN(user.score) as score_diff
from user
where user.city = '北京';

-- 查询北京用户的最高分比上海用户的最高分差距多少
select (select max(score) from user where city = '北京') -
       (select max(score) from user where city = '上海') as score_difference;

select sum(user.score) as total_scores
from user
where user.city = '北京';

select sum(user.score) as total_scores
from user
where user.city = '上海';

-- 查询北京用户的平均分比上海用户的平均分差距多少
select (select avg(score) from user where city = '北京') -
       (select avg(score) from user where city = '上海') as score_difference;

select user.city       as user_score,
       sum(user.score) as total_scores,
       avg(user.score) as avg_scores,
       max(user.score) as max_scores,
       min(user.score) as min_scores
from user
group by user.city;