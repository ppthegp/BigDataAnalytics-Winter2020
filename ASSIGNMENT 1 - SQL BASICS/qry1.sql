--select * from dumping limit 100
--drop function convertText(text) 

--CREATE TABLE EXP_RECORD ( row varchar);

set search_path = 'assignment1';

CREATE OR REPLACE FUNCTION assignment1.convertText(IN fileName text)  
   RETURNS INTEGER AS $$
    DECLARE
      lrow record;
	  restData text;
	  ldata text[];
	  lid text[];
	  lstage text[];
    BEGIN
		--Checked Max comma count with the help of below query
		--select max(array_length(regexp_split_to_array(row, ','), 1)) from DUMPING 
		--EXECUTE 'CREATE TABLE DUMPING1 (row varchar);';
		--EXECUTE 'COPY DUMPING1(row) FROM ' || quote_literal(fileName);
		FOR lrow in select * from DUMPING
			LOOP
				BEGIN
					IF LENGTH(lrow.row) = 0 THEN
   						RAISE EXCEPTION 'Line Empty';
					END IF;
					IF lrow.row = 'IOError' THEN
   						RAISE EXCEPTION 'IOError';
					END IF;
					ldata := regexp_split_to_array(lrow.row, ',');
					restData := ldata[3] || COALESCE (ldata[4],'') || COALESCE (ldata[5],'') || 
							COALESCE (ldata[6],'') || COALESCE (ldata[7],'') || COALESCE (ldata[8],'');
					lid := regexp_split_to_array(restData, '--');
					lstage := regexp_split_to_array(lid[2], '.rb');
					INSERT INTO assignment1.ghlogs(loglevel, logtime, downloaderid, retrivalstage, msg)
					VALUES (ldata[1]::varchar, ldata[2]::timestamp without time zone, TRIM(lid[1]::varchar)
						,TRIM(lstage[1]::varchar), TRIM(lstage[2]::varchar));
				EXCEPTION 
				WHEN others THEN    
        			--RAISE NOTICE 'ERROR %', SQLERRM ;
					INSERT INTO EXP_RECORD(row,exception) VALUES (lrow,SQLERRM);
				END;
			END LOOP;
		--EXECUTE 'DROP TABLE DUMPING1';
		RETURN 1;
    END;
  $$ LANGUAGE plpgsql VOLATILE;


--select convertText('G:\IIITD\Sem2\BDA\Assignment 1\data\ghtorrent-logs.txt')
--select count(*) from dumping
--select count(*) from ghlogs limit 100 --9669691
--select * from exp_record 
--truncate table ghlogs
--truncate table exp_record