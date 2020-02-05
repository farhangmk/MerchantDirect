CREATE PROCEDURE calculate_offlinx_transaction_stats @TransactionDate DATE
AS
INSERT INTO #offlinx_transaction_statistics (offlinx_site_id, site_transaction_date, moneris_customer_number, transaction_count, outlier_threshold_lower, outlier_threshold_upper, max_transaction_amount, mean_transaction_amount, median_transaction_amount, quartile_1_transaction_amount, quartile_3_transaction_amount, transaction_amount_inter_quartile_range)
SELECT DISTINCT ot.offlinx_site_id, ot.site_transaction_date, at.moneris_customer_number, COUNT(1) OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number) AS transaction_count,
os.offlinx_minimum_transaction_amount AS outlier_threshold_lower,
((
(PERCENTILE_DISC (0.75) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number)) - 
(PERCENTILE_DISC (0.25) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number))
) * 3)
+ 
(PERCENTILE_DISC (0.75) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number)) As outlier_threshold_upper,

MAX(transaction_amount) OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number) as max_transaction_amount,

AVG(transaction_amount) OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number) as mean_transaction_amount,

PERCENTILE_DISC (0.5) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number) AS median_transaction_amount,
PERCENTILE_DISC (0.25) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number) AS quartile_1_transaction_amount,
PERCENTILE_DISC (0.75) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number) AS quartile_3_transaction_amount,
(PERCENTILE_DISC (0.75) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number)) - 
(PERCENTILE_DISC (0.25) WITHIN GROUP (ORDER BY transaction_amount)
OVER (PARTITION BY ot.offlinx_site_id, site_transaction_date, moneris_customer_number)) AS transaction_amount_inter_quartile_range




FROM offlinx_transaction ot 
INNER JOIN #offlinx_site_temp os ON os.offlinx_site_id = ot.offlinx_site_id
INNER JOIN authorization_transaction at 
        ON ot.authorization_transaction_source_code = at.authorization_transaction_source_code 
                AND ot.authorization_transaction_source_id = at.authorization_transaction_source_id
WHERE ot.site_transaction_date = @TransactionDate AND COALESCE(at.electronic_commerce_indicator,'') NOT IN('5','6','7','8','9') AND os.active = 1
