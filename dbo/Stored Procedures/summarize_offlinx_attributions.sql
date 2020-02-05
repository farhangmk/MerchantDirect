CREATE PROCEDURE summarize_offlinx_attributions @TransactionDate DATE
AS
INSERT INTO offlinx_transaction_attribution_summary
SELECT oa.offlinx_transaction_id, COUNT(1) AS attribution_count FROM offlinx_transaction ot
INNER JOIN offlinx_attribution oa ON oa.offlinx_transaction_id = ot.offlinx_transaction_id
WHERE ot.site_transaction_date = @TransactionDate
GROUP BY oa.offlinx_transaction_id 
