create database dba_test;
use dba_test;

create table user (
                      id serial primary key,
                      username varchar(50) not null unique,
                      password varchar(255) not null,
                      email varchar(100) not null unique,
                      created_at timestamp default current_timestamp
);

select * from user;

select user.username as user_name, user.id as user_id, user.created_at as created_time from user;

create table role (
                      id serial primary key,
                      name varchar(50) not null unique,
                      description text
);

select * from role;

insert into user (username, password, email) values
                                                 ('admin', 'admin123', 'admin@email.com'),
                                                 ('user1', 'user123', 'user123@email.com');

# 向user表中添加一个新字段 city 类型为varchar(50)
alter table user add column city varchar(50);

alter table user add column score int default 0;

# 删除user表中的last_login字段
alter table user drop column last_login;

show columns from user;

alter table user
    add column last_login timestamp;

show table status
where name = 'user';

# 向user表中随机添加100条数据
INSERT INTO user (username, password, email)
SELECT
    CONCAT('user', LPAD(FLOOR(RAND() * 100000), 5, '0')),
    CONCAT('pass', LPAD(FLOOR(RAND() * 100000), 5, '0')),
    CONCAT('user', LPAD(FLOOR(RAND() * 100000), 5, '0'), '@test.com')
FROM
    information_schema.tables
        LIMIT 100;

update user set score = FLOOR(RAND() * 100);

select user.username, user.id as u_id, user.created_at as role_name from user;

# 将北京、上海、广州、武汉 随机添加到user表的city字段中
UPDATE user
SET city = CASE
               WHEN RAND() < 0.25 THEN '北京'
               WHEN RAND() < 0.5 THEN '上海'
               WHEN RAND() < 0.75 THEN '广州'
               ELSE '武汉'
    END
WHERE city IS NULL;

select distinct user.created_at from user;

select * from user where username like 'user_____' and user.city is not null;

select id as u_id,user.username as u_name from user where user.city = '北京';

# 查询每个城市的用户数量，并按数量升序排列
select count(*) as total_users, city from user group by city order by total_users;

# 查询所有城市数量
select count(distinct (user.city)) citys from user;

select distinct (user.city) from user;
