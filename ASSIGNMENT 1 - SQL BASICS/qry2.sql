set search_path = assignment1
 
-- drop table ghlogs
CREATE TABLE ghlogs
(
	sno bigserial primary key, 
  	logLevel varchar(20),
  	logTime timestamp without time zone,
  	downloaderID varchar,
	retrivalStage varchar,
	msg varchar
);

CREATE TABLE DUMPING ( row varchar);
 
COPY DUMPING(row) FROM 'G:\IIITD\Sem2\BDA\Assignment 1\data\ghtorrent-logs.txt' 

select * from dumping limit 100

CREATE TABLE exp_record
(
    row varchar,
	exception varchar
)

--COPY log(loglevel,logtime,message,remaining,total)
--FROM 'G:\IIITD\Sem2\BDA\Assignment 1\data\ghtorrent-logs.txt' 
--DELIMITER  
--USING DELIMITERS ',' WITH NULL AS 'null_string';


--drop table repolist
CREATE TABLE repolist
(
	id int ,
	url varchar,
	ownerId int,
	rname varchar,
	langName varchar,
	createdAt timestamp without time zone,
	forkedFrom varchar ,
	deleted int,
	updatedAt varchar
)

COPY repolist(id,url,ownerId,rname,langName, createdAt, forkedFrom,deleted,updatedAt) 
FROM 'G:\IIITD\Sem2\BDA\Assignment 1\important-repos.csv' DELIMITER ',' CSV HEADER NULL AS 'null' 
 