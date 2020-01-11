set search_path = "assignment1";
select * from ghlogs limit 100

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

-- Anaalytics 5
select downloaderid,count(*) from ghlogs group by downloaderid order by count(*) desc limit 10 --

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
select split_part(msg, 'repos',2) as afterRepo,* from ghlogs   
	where loglevel = 'WARN' and retrivalstage = 'api_client'
)
select split_part(afterRepo, '?',1) as repo, count(split_part(afterRepo, '?',1)) as accesscount
	from cte where afterRepo != '' group by repo order by accesscount desc limit 5

-- Analytics 9
select downloaderid,msg from ghlogs order by sno desc limit 100

select downloaderid,msg from ghlogs where msg like ': Failed%' order by sno desc limit 100
group by downloaderid 
	order by count(*) desc 
