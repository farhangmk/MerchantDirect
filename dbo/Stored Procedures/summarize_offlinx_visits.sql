CREATE PROCEDURE summarize_offlinx_visits @TransactionDate DATE
AS
INSERT INTO offlinx_transaction_visit_summary (offlinx_site_id, site_transaction_date, offlinx_channel_id, total_visits, total_traced_visits, total_attributed_visits )
	SELECT os.offlinx_site_id, @TransactionDate as site_transaction_date, ov.offlinx_channel_id, COUNT(distinct ov.offlinx_visit_id) AS total_visits, COUNT (DISTINCT ovt.offlinx_visit_id) AS total_traced_visits, COUNT (DISTINCT (CASE WHEN oa.offlinx_attribution_id IS NOT NULL THEN ovt.offlinx_visit_id END)) AS total_attributed_visits
	FROM offlinx_site os
	INNER JOIN offlinx_visit_v2 ov on os.offlinx_site_id = ov.offlinx_site_id
	LEFT JOIN offlinx_visit_trace ovt ON ov.offlinx_visit_id = ovt.offlinx_visit_id
	LEFT JOIN offlinx_attribution oa ON ovt.offlinx_visit_trace_id = oa.offlinx_visit_trace_id
	WHERE os.active = 1 AND os.deleted = 0
		AND ov.visit_timestamp BETWEEN DATEADD(dd, -1 * os.attribution_window_days, CAST(@TransactionDate AS DATETIME2)) AT TIME ZONE os.timezone AT TIME ZONE 'UTC' AND DATEADD(dd, 1, CAST(@TransactionDate AS DATETIME2)) AT TIME ZONE os.timezone AT TIME ZONE 'UTC'
	GROUP BY os.offlinx_site_id, ov.offlinx_channel_id;
	
