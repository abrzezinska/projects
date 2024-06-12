
/*1. Create table ‘table_to_delete’ and fill it with the following query:*/

     CREATE TABLE table_to_delete AS
               SELECT 'veeeeeeery_long_string' || x AS col
               FROM generate_series(1,(10^7)::int) x; -- generate_series() creates 10^7 rows of sequential numbers from 1 to 10000000 (10^7)
               
                   
/*2. Lookup how much space this table consumes with the following query:*/

SELECT *, pg_size_pretty(total_bytes) AS total,
                                    pg_size_pretty(index_bytes) AS INDEX,
                                    pg_size_pretty(toast_bytes) AS toast,
                                    pg_size_pretty(table_bytes) AS TABLE
               FROM ( SELECT *, total_bytes-index_bytes-COALESCE(toast_bytes,0) AS table_bytes
                               FROM (SELECT c.oid,nspname AS table_schema,
                                                               relname AS TABLE_NAME,
                                                              c.reltuples AS row_estimate,
                                                              pg_total_relation_size(c.oid) AS total_bytes,
                                                              pg_indexes_size(c.oid) AS index_bytes,
                                                              pg_total_relation_size(reltoastrelid) AS toast_bytes
                                              FROM pg_class c
                                              LEFT JOIN pg_namespace n ON n.oid = c.relnamespace
                                              WHERE relkind = 'r'
                                              ) a
                                    ) a
               WHERE table_name LIKE '%table_to_delete%';
              
/*oid:16.881
 * row estimate:-1
 * total bytes:602.415.104
 * index bytes:0
 * toast bytes:8.192
 * table bytes 602.406.912
 * total:575 MB
 * index:0 bytes
 * toast:8192 bytes
 * table: 575 MB*/
              
/*3. Issue the following DELETE operation on ‘table_to_delete’:*/


    -- Execute the DELETE statement
    DELETE FROM table_to_delete
               WHERE REPLACE(col, 'veeeeeeery_long_string','')::int % 3 = 0; -- removes 1/3 of all rows

   

/*    a)  DELETE statement takes 12 seconds; 
      b) Lookup how much space this table consumes after previous DELETE;
 *oid:16.881
 * row estimate:9.999.697
 * total bytes:602.611.712
 * index bytes:0
 * toast bytes:8.192
 * table bytes 602.603.520
 * total:575 MB
 * index:0 bytes
 * toast:8192 bytes
 * table: 575 MB*/
      
  /*  c) Perform the following command (if you're using DBeaver, press Ctrl+Shift+O to observe server output (VACUUM results)): */
               
	VACUUM FULL VERBOSE table_to_delete;
               
          
 /*     d) Check space consumption of the table once again and make conclusions;
  *oid:16.861
 * row estimate:6.666.667
 * total bytes:401.620.992
 * index bytes:0
 * toast bytes:8.192
 * table bytes 401.612.800
 * total:383 MB
 * index:0 bytes
 * toast:8192 bytes
 * table: 383 MB*/

--  e) Recreate ‘table_to_delete’ table;

INSERT INTO table_to_delete (col)
SELECT 'veeeeeeery_long_string' || x AS col
FROM generate_series(1,(10^7)::int) x
WHERE REPLACE('veeeeeeery_long_string' || x, 'veeeeeeery_long_string','')::int % 3 = 0;

--4. Issue the following TRUNCATE operation:

               TRUNCATE table_to_delete;
              
              
 --    a) It taks less than 1 second
              
 --    b) Compare with previous results and make conclusion.
              
  /*    -TURNCATE takes defitely less time than DELETE (TTURNCATE <1s , DELETE = 12s)
  * 	-DELETE  scan the table or generate WAL (Write Ahead Log) entries for each row that's way its slower
  * 	-TRUNCATE cannot be rolled back and also cannot be used with a WHERE clause.
  * 	-DELETE rows from a table based on a specified condition, making it more flexible than TRUNCATE 
  
	   c) Check space consumption of the table once again and make conclusions;
	   
 *oid:16.881
 * row estimate:-1
 * total bytes:8.192
 * index bytes:0
 * toast bytes:8.192
 * table bytes 0
 * total:8192 MB
 * index:0 bytes
 * toast:8192 bytes
 * table: 0 MB

DELETE didn't deleted all rows from the table, based on the result before and after delete it shows that there is less
memory showed in total bytes and tables bytes than it was before th delete. The total memory is the same it wasn't reduced after delete.
After VACUUM the total memory was reduced from 575 to 383 so it was reduced by 1/3 (it is correcr becuse 1/3 of each row was delated)
Total bytes and tables bytes were reduced too.

TRUNCATE deleted all rows from the table. The total memory was reduced to 0.
  
*/