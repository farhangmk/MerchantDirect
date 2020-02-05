CREATE PROCEDURE expand_offlinx_transactions @TransactionDate DATE
AS
INSERT INTO #offlinx_transaction_expanded (offlinx_transaction_id,authorization_transaction_source_code ,authorization_transaction_source_id,offlinx_site_id,site_transaction_date,icf,	transaction_timestamp,moneris_customer_number,	transaction_currency,transaction_amount,card_type_code,	purchase_method,outlier_adjusted_transaction_amount,transaction_traces)
SELECT ot.offlinx_transaction_id, ot.authorization_transaction_source_code, ot.authorization_transaction_source_id, ot.offlinx_site_id, ot.site_transaction_date, ot.icf,ot.transaction_timestamp,
        at.moneris_customer_number,at.transaction_currency,at.transaction_amount,at.card_type_code,IIF(COALESCE(at.electronic_commerce_indicator,'') IN('5','6','7','8','9'), 'E', 'S') AS purchase_method, 
        CASE WHEN transaction_amount > ots.outlier_threshold_upper THEN ots.outlier_threshold_upper WHEN transaction_amount < ots.outlier_threshold_lower THEN ots.outlier_threshold_lower ELSE transaction_amount END AS outlier_adjusted_transaction_amount,
        count(ott.offlinx_transaction_trace_id) AS transaction_traces
FROM offlinx_transaction ot
INNER JOIN authorization_transaction at 
        ON ot.authorization_transaction_source_code = at.authorization_transaction_source_code 
                AND ot.authorization_transaction_source_id = at.authorization_transaction_source_id
INNER JOIN #offlinx_transaction_statistics ots
        ON ot.offlinx_site_id = ots.offlinx_site_id AND ot.site_transaction_date = ots.site_transaction_date AND at.moneris_customer_number = ots.moneris_customer_number
LEFT JOIN #offlinx_transaction_trace ott ON ot.offlinx_transaction_id = ott.offlinx_transaction_id
WHERE ot.site_transaction_date = @TransactionDate and COALESCE(at.electronic_commerce_indicator,'') NOT IN('5','6','7','8','9') -- non-ecom only?
GROUP BY
ot.site_transaction_date, ot.offlinx_site_id, ot.authorization_transaction_source_code, ot.authorization_transaction_source_id, ot.offlinx_transaction_id, ot.icf,ot.transaction_timestamp,
at.moneris_customer_number,at.transaction_currency,at.transaction_amount,at.card_type_code,IIF(COALESCE(at.electronic_commerce_indicator,'') IN('5','6','7','8','9'), 'E', 'S'),CASE WHEN transaction_amount > ots.outlier_threshold_upper THEN ots.outlier_threshold_upper WHEN transaction_amount < ots.outlier_threshold_lower THEN ots.outlier_threshold_lower ELSE transaction_amount END
; 
