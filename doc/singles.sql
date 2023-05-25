-- 推荐：utf8mb4,utf8mb4_unicode_ci，ci表示大小写不敏感（character insensitive）
-- 数据库级别设置，如果库级别没有设置，则使用默认设置
-- CREATE DATABASE <db_name> DEFAULT CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
-- 表级别设置，如果表级别没有设置，则继承库级别设置
-- CREATE TABLE (
--
-- ) ENGINE=InnoDB DEFAULT CHARSET=utf8mb4 COLLATE=utf8mb4_unicode_ci;
-- 列级别设置，如果列级别没有设置CHARSET和COLLATE，则列级别会继承表级别的CHARSET与COLLATE
-- CREATE TABLE (
--     `field1` VARCHAR（64） CHARACTER SET utf8mb4 COLLATE utf8mb4_general_ci NOT NULL DEFAULT '',
-- )


-- 服务端表结构
create table user (
    id bigint not null,
    name varchar(32) not null comment 'username',
    email varchar(32) not null comment 'email',
    phone varchar(16) not null comment 'phone',
    password varchar(255) not null comment 'password',
    sex tinyint not null default 1 comment 'sex, 1-man, 2-woman, 3-other',
    avatar varchar(255) default null comment 'avatar',
    birthday date default null comment 'birthday',
    type tinyint default 1 not null comment 'user type,1-common user,2-system user',
    create_time datetime default current_timestamp not null comment 'create time',
    constraint user_pk primary key (id)
) DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci comment 'user';
create unique index user_idx_email on user (email);
create unique index user_idx_phone on user (phone);

create table contact (
    id bigint not null,
    apply_user_id bigint not null comment 'apply user',
    agree_user_id bigint not null comment 'agree user',
    state tinyint not null default 0 comment 'status,0-applying, 1-agree',
    create_time datetime default current_timestamp not null comment 'create time',
    update_time datetime null on update current_timestamp comment 'update time',
    constraint contact_pk primary key (id)
) DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci comment 'contact';
create index contact_idx_apply on contact (apply_user_id);
create index contact_idx_agree on contact (agree_user_id);

create table group (
    id bigint not null,
    name varchar(32) not null comment 'group name',
    create_user_id bigint not null comment 'creator',
    owner_id bigint not null comment 'owner',
    announcement varchar(256) default null comment 'announce',
    create_time datetime default  current_timestamp not null comment 'create time',
    constraint group_pk primary key (id)
) DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci comment 'group';

create table group_member (
    group_id bigint not null comment 'group',
    user_id bigint not null comment 'user',
    constraint group_member_pk primary key (group_id, user_id)
) DEFAULT CHARACTER SET = utf8mb4 COLLATE = utf8mb4_unicode_ci comment 'group member';

-- 用户离线无法收到消息，登录时，主动同步消息
create table message_receive (
    id bigint not null,
    from_user_id bigint not null comment 'send user',
    to_user_id bigint not null comment 'to user',
    group_id bigint default null comment 'group',
    content varchar(255) not null comment 'content',
    type tinyint not null comment 'message type',
    delivered tinyint not null default 0 comment 'deliver',
    create_time datetime default current_timestamp comment 'create time',
    constraint message_receive_pk primary key (id)
) default character set = utf8mb4 collate = utf8mb4_unicode_ci comment 'message receive, including group and personal';
create index message_receive_idx_to_user on message_receive (to_user_id);

create table message_send (
    id bigint not null,
    from_user_id bigint not null comment 'send user',
    to_user_id bigint not null comment 'receive user',
    group_id bigint default null comment 'group',
    content varchar(255) not null comment 'content',
    type tinyint not null comment 'message type',
    create_time datetime default current_timestamp comment 'create time',
    constraint message_send_pk primary key (id)
) default character set = utf8mb4 collate = utf8mb4_unicode_ci comment 'message send, including group and personal';

create table moment (
    id bigint not null,
    user_id bigint not null comment 'creator',
    content text not null comment 'share moment content',
    pictures varchar(1024) default null comment 'pictures',
    create_time datetime default current_timestamp comment 'create time',
    constraint moment_pk primary key (id)
) default character set = utf8mb4 collate = utf8mb4_unicode_ci comment 'user share moment';
create index moment_idx_user on moment (user_id);

create table moment_favour (
    moment_id bigint not null,
    user_id bigint not null,
    create_time datetime default current_timestamp comment 'favour time',
    constraint moment_favour_pk primary key (moment_id, user_id)
) default character set = utf8mb4 collate = utf8mb4_unicode_ci comment 'moment favour';

create table moment_comment (
    moment_id bigint not null,
    user_id bigint not null,
    content varchar(255) not null comment 'comment content',
    create_time datetime default current_timestamp comment 'comment time',
    constraint moment_comment_pk primary key (moment_id, user_id)
) default character set = utf8mb4 collate = utf8mb4_unicode_ci comment 'moment comment';


-- 客户端表结构
-- 客户端登录，主动拉取 离线消息和分享内容
create table if not exists contact (
    user_id integer,
    contact_id integer,
    name text,
    birthday text,
    sex integer,
    photo blob
);

create table if not exists message (
    user_id integer,
    sender_id integer,
    name text,
    send_time text,
    content text,
    unread integer,
    type integer
);

create table if not exists chat_message (
    user_id integer,
    contact_id integer,
    type integer,
    send_time text,
    content text
);
