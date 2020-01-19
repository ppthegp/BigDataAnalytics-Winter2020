set search_path = "assignment1";
select * from ghlogs limit 100

--Loading 2
select count(*) from ghlogs --9669634 
-- counting 3
select count(*) from ghlogs where loglevel = 'WARN' --132158

-- count 4
with cte as(
select split_part(msg, 'repos',2) as afterRepo,* from ghlogs   
	where loglevel = 'WARN' and retrivalstage = 'api_client' 
)
select count(*) from cte where afterRepo = ''  ; --2207

with cte as(
select split_part(msg, 'repos',2) as afterRepo,* from ghlogs   
	where loglevel = 'WARN' and retrivalstage = 'api_client'
)
select count(distinct split_part(afterRepo, '?',1)) from cte where afterRepo != '' ; --7545 

select  count(split_part(split_part(msg, 'repos/',2),'?',1)) as repoCount 
	    from ghlogs   
		where loglevel = 'WARN' and retrivalstage = 'api_client' and
		split_part(split_part(msg, 'repos/',2),'?',1) = ''
		

-- Anaalytics 5
select downloaderid,count(*) from ghlogs group by downloaderid order by count(*) desc limit 10

-- Analytics 6
select downloaderid,count(*) from ghlogs where msg like ': Failed%' group by downloaderid 
	order by count(*) desc limit 10

--Analytics 7
select  extract(hour from logtime)as hours ,count(logtime) as counting
 		from ghlogs 
 		group by hours 
	   	order by counting desc limit 1

--Analytics 8
with cte as(
	select split_part(split_part(msg, 'repos/',2),'?',1) as repo from ghlogs   
	)
select repo, count(repo) as accesscount from cte 
where repo != '' group by repo order by accesscount desc limit 1


-- Analytics 9
select split_part(split_part(msg, 'Access:',2),' IP',1) as accesss, 
	count(split_part(split_part(msg, 'Access:',2),' IP',1)) as counting 
	from ghlogs where msg like ': Failed%' group by accesss order by counting desc limit 1

--Indexing
create index in_ghlogs_downloader_id on ghlogs(downloaderid);

--Indexing 10
 
with cte as(
select split_part(msg, 'repos',2) as afterRepo,* from ghlogs   
	where loglevel = 'WARN' and retrivalstage = 'api_client'
)
select count(distinct split_part(afterRepo, '?',1)) from cte where downloaderid = 'ghtorrent-22'; --7545

explain analyse select count(distinct repos) from ghlogs where downloaderid = 'ghtorrent-22' ;
drop index in_ghlogs_downloader_id  

--joining 
select count(*) from repolist;


Alter table ghlogs add column repos varchar default ''

Update ghlogs set repos = split_part(split_part(msg, 'repos/',2),'?',1)
	--where loglevel = 'WARN' and retrivalstage = 'api_client'

COPY (select repos,count(*) from ghlogs group by repos order by count(*) desc )
TO 'G:\IIITD\Sem2\BDA\Assignment 1\reposwithout.csv' DELIMITER ',' CSV; 
--where repos != '' 

select * from repolist limit 100

Alter table repolist add column repos varchar default ''

Update repolist set repos = split_part(url, 'repos/',2)

--counting repos
select * from repolist; 

select count(*) from ghlogs as gh inner join repolist as rp 
	on gh.repos = rp.repos where gh.repos != '' --531

select gh.repos,count(*) from ghlogs as gh inner join repolist as rp 
	on gh.repos = rp.repos where gh.repos != '' and msg like ': Failed%' group by gh.repos 

select repos,msg from ghlogs where repos != '' limit 100

	



	


