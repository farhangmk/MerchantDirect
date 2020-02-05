CREATE PROCEDURE generate_offlinx_visit_ids @HowMany SMALLINT
AS

WITH gen AS (

        SELECT 1 AS num
        UNION ALL
        SELECT num+1 FROM gen WHERE num < @HowMany
        
        
)
SELECT NEXT VALUE FOR offlinx_visit_id AS offlinx_visit_id FROM gen OPTION (MAXRECURSION 32767)