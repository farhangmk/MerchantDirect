CREATE PROCEDURE summarize_offlinx_tracking_impression @ImpressionDate DATE
AS
INSERT INTO offlinx_tracking_impression_summary (offlinx_site_id, impression_date, impression_count)
SELECT s.offlinx_site_id, @ImpressionDate AS impression_date, COUNT_BIG(1) AS impression_count
FROM offlinx_tracking_impression_v3 t INNER JOIN offlinx_site s ON t.offlinx_site_id = s.offlinx_site_id
WHERE impression_timestamp >= CAST(@ImpressionDate AS DATETIME2) AT TIME ZONE s.timezone AT TIME ZONE 'UTC' AND impression_timestamp < CAST(DATEADD(dd,1,@ImpressionDate) AS DATETIME2) AT TIME ZONE s.timezone AT TIME ZONE 'UTC'
GROUP BY s.offlinx_site_id
