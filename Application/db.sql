DROP TABLE IF EXISTS php28_member;
CREATE TABLE php28_member 
(
    id mediumint unsigned not null auto_increment comment'id',
    username varchar(30) not null comment'会员名称',
    password char(32) not null comment'密码',
    email varchar(100) not null comment '邮箱',
    email_code char(13) not null comment'验证码,如果为空，表示已验证',
    email_time int unsigned  not null comment'验证时间',
    primary key (id)
)engine=MyISAM charset=utf8 comment'会员';