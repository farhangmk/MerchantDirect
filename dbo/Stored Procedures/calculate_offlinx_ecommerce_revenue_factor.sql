CREATE PROCEDURE calculate_offlinx_ecommerce_revenue_factor @TransactionDate DATE
AS
INSERT INTO offlinx_ecommerce_revenue_factor
SELECT rev.offlinx_site_id, @TransactionDate AS site_transaction_date, total_transaction_amount, total_attribution_amount, CONVERT(DECIMAL(19,4), ROUND( IIF(total_attribution_amount = 0, 0.0, 1.0 * total_transaction_amount / total_attribution_amount), 4)) AS revenue_factor
FROM (
        SELECT os.offlinx_site_id, SUM(total_transaction_amount) AS total_transaction_amount
        FROM 
        offlinx_site os
        INNER JOIN
        offlinx_revenue_summary ors ON os.offlinx_site_id = ors.offlinx_site_id
        WHERE os.active = 1 AND os.deleted = 0  AND ors.transaction_date = @TransactionDate AND ors.offlinx_purchase_method = 'E'
        GROUP BY os.offlinx_site_id
) rev
INNER JOIN (
        SELECT oae.offlinx_site_id, SUM(attribution_amount) AS total_attribution_amount
        FROM offlinx_attribution_expanded oae
        INNER JOIN offlinx_transaction_visit_summary otvc ON  oae.offlinx_site_id = otvc.offlinx_site_id AND oae.site_transaction_date = otvc.site_transaction_date AND oae.offlinx_channel_id = otvc.offlinx_channel_id
        WHERE oae.site_transaction_date = @TransactionDate and purchase_method = 'E'
        AND desktop = 1 and mobile = 1 and tablet = 1
        GROUP BY oae.offlinx_site_id
) attr ON rev.offlinx_site_id = attr.offlinx_site_id;
