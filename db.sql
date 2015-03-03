use php28;
set names utf8;

#int            0~40多亿
#mediumint      0~1600多万
#smallint       0~65535
#tinyint        0~255
#varchar(5)和char（5）啥区别
#如存‘abc’ char（5） ->占5个字符，字节：gbk/汉字*2    utf8/汉字*3
#如存‘abc\0'varchar(5) ->占4个字符，字节：gbk/汉字*2   utf8/汉字*3
#char ： 最大能存255个字符
#varchar： 最大能存65535个字节
#text ： 最大能存65535个字符

#导入到数据库中
#方法一：在mysql中执行 source db.sql source source source db.sql
#方法二： 直接把sql复制到mysql中执行（注意要设置set names gbk）

DORP TABLE IF EXISTS php28_admin;
create table php28_admin
(
    id samllint unsigned not null auto_increment comment'id',
    username varchar(30) not null comment '用户名',
    password char(32) not null comment'密码',
    role_id mediumint unsigned not null default '0' comment '角色的id'，
    primary key (id)
）engine=MyISAM default charset=utf8 comment '管理员';
INSERT INTO php28_admin VALUES(1,'admin','212',1);

DROP TABLE IF EXISTS php28_privilege;
CREATE TABLE php28_privilege
(
    id mediumint unsigned not null auto_increment comment 'id',
    pri_name varchar(30) not null comment '权限名称',
    module_name varchar(30) not null comment '对应的模块名',
    controller_name varchar(30) not null ,
    action_name varchar(30) not null,
    parent_id mediumint unsigned not null default '0' comment '上级权限的id',
    pri_level tinyint unsigned not null default '0' comment '权限的级别',
    primary key (id)
)engine=MyISAM charset=utf8 comment '权限';

DROP TABLE IF EXISTS php28_role;
CREATE TABLE php28_role
(
    id mediumint unsigned not null auto_increment comment 'id',
    role_name varchar(30) not null comment '角色名称',
    pri_id varchar(150) not null default '' comment '权限的id，如果有多个
    primary key (id)
)engine=MyISAM default charset=utf8 comment '角色';
INSERT INTO php28_role VALUES(1,'admin','*');

#多对多 （现在是多对多）
#一个角色有多个权限
#一个权限可以被多个角色拥有

#一对多
#一个班级有多个学生
#一个学生只属于一个班级

DROP TABLE IF EXISTS php28_category;
CREATE TABLE php28_category
(
    id mediumint unsigned not null auto_increment comment 'id',
    cat_name varchar(30) not null comment '分类名称',
    parent_id mediumint unsigned not null default '0' comment '上级分类的id',
    price_section tinyint unsigned not null default '5' comment '价格区间',
    cat_keywords varchar(300) not null default '' comment '页面的关键字',
    cat_descriptio varchar(300) not null default '' comment '页面的描述',
    attr_id varchar(150) not null default '' comment '筛选属性id，多个用，隔开',
    rec_id varchar(150) not null default '' comment '推荐位的id，多个用，隔开',
    primary key (id)
)engine=MyISAM default charset=utf8 comment '商品分类';

DROP TABLE IF EXISTS php28_brand;
CREATE TABLE php28_brand
(
    id mediumint unsigned not null auto_increment comment 'id',
    brand_name varchar(30) not null comment '品牌名称',
    site_url varchar(150) not nulll comment '官方网站',
    brand_logo varchar(150) not null default '' comment '图片的logo',
    primary key (id)
)engine=MyISAM default charset=utf8 comment '商品品牌';

DROP TABLE IF EXISTS php28_type;
CREATE TABLE php28_type
(
    id mediumint unsigned not null auto_increment comment 'id',
    type_name varchar(30) not null comment '类型名称',
    primary key (id)
    )engine=InnoDB default charset=utf8 comment '商品类型';


DROP TABLE IF EXISTS php28_attribute;
CREATE TABLE php28_attribute
(
    id mediumint unsigned not null auto_increment comment 'id',
    attr_name varchar(30) not null comment ' 属性名称',
    attr_type enum("单选",'唯一') not null default '唯一' comment '属性类别',
    attr_option_value varchar(300) not null default '' comment '属性可选值',
    type_id mediumint unsigned not null default '0' comment '类型id',
    foreign key (type_id )references php28_type(id) on delete cascade,
    primary key (id)
    )engine=InnoDB default charset=utf8 comment '属性表';


DROP TABLE IF EXISTS php28_goods;
CREATE TABLE php28_goods
(
    id mediumint unsigned not null auto_increment commnet 'id',
    goods_name varchar(30) not null commnet '商品名称',
    sm_logo varchar(150) not null default '' comment '小图',
    mid_logo varchar(150) not null default '' comment '中图',
    big_logo varchar(150) not null defautl '' comment '大图',
    logo varchar(150) not null default '' comment '原图',
    cat_id mediumint unsigned not null default '0' comment '分类id',
    brand_id mediumint unsigned not null default '0' comment '品牌id',
    market_price decimal(10,2) not null default '0.00'comment'市场价',
    shop_price decimal(10,2) not null default '0.00' comment '本店价',
    is_on_sale enum('是','否') not null default '是' comment '是否上架',
    goods_desc text comment '商品描述',
    type_id mediumint unsigned not null default '0' comment '商品类型id',
    rec_id varchar(150) not null default '' comment '推荐位的id，多个用，隔开',
    primary key (id),
    key shop_price(shop_price)
    )engine=MyISAM default charset=utf8 comment '商品表';

DROP TABLE IF EXISTS php28_member_level;
CREATE TABLE php28_member_level
(
    id mediumint unsigned not null auto_increment comment 'id ',
    level_name varchar(30) not null comment '级别名称',
    top int unsigned not null default '0' comment '积分上限',
    bottom int unsigned not null default '0' comment '积分下限',
    rate int unsigned not null default '100' comment'折扣',
    primary key (id)
    )engine=MyISAM default charset=utf8 comment '会员级别';

DROP TABLE IF EXISTS php28_member_price;
CREATE TABLE php28_member_price
( 
    id mediumint unsigned not null auto_increment comment'id ',
    level_id mediumint unsigned not null default '0' comment '会员级别id',
    goods_id mediumint unsigned not null default '0' comment '商品的id',
    )engine=MyISAM default charset=utf8 comment '会员价格';

DROP TABLE IF EXISTS php28_goods_pic;
CREATE TABLE php28_pic
(
    id mediumint unsigned not null auto_increment comment 'id ',
    sm_logo varchar(150) not null default '' comment '小图',
    mid_logo varchar(150) not null default '' comment '中图',
    big_logo varchar(150) not null default '' comment '大图',
    logo varchar(150) not null default '' comment '原图',
    goods_id mediumint unsigned not null default '0' comment '商品的id',
    primary key (id)
    )engine=MyISAM default charset=utf8 comment '商品图片';
    
DROP TABLE IF EXISTS php28_goods_attr;
CREATE TABLE php28_goods_attr
(   
    id mediumint unsigned not null auto_increment comment 'id',
    goods_id mediumint unsigned not null default '0' comment'商品的id',
    attr_id mediumint unsigned not null default '0' comment '属性id',
    attr_value varchar(150) not null default '' comment '属性值',
    attr_price decimal(10,2) not null default'0.00' comment '属性的价格',
    primary key (id )
    )engine=MyISAM default charset=utf8 comment '商品库存';

DROP TABLE IF EXISTS php28_member;
CREATE TABLE php28_member
(
    id mediumint unsigned not null auto_increment comment 'id',
    username varchar(30) not null comment '会员名称',
    email varchar(150) not null comment 'Email',
    password char(32) not null comment '密码',
    email_code char(13) not null comment 'email验证码，如果这个字段为空，表示已经验证过了',
    email_code_time int unsigned not null comment '验证码生成的事件',
    jifen int unsigned not null default '0' comment '会员的积分',
    primary key (id ) 
    )engine=MyISAM default charset=utf8 comment '会员';

