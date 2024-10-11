create database if not exists wabydb;

use wabydb;

create user if not exists admin@'%' identified by 'renalessiSql21!';
grant select, update, insert, delete, create on wabydb.* to admin@'%';