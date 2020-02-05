CREATE PROCEDURE summarize_offlinx_revenue @TransactionDate DATE
AS
INSERT INTO offlinx_revenue_summary (offlinx_site_id, moneris_customer_number, transaction_date, transaction_currency, offlinx_purchase_method, total_transaction_count, total_transaction_amount )
        SELECT ot.offlinx_site_id, t.moneris_customer_number, @TransactionDate AS transaction_date, t.transaction_currency, IIF(COALESCE(t.electronic_commerce_indicator,'') IN('5','6','7','8','9'), 'E', 'S') AS offlinx_purchase_method, COUNT_BIG(1) AS_total_transaction_count, SUM(t.transaction_amount) AS total_transaction_amount
        FROM offlinx_transaction ot
        INNER JOIN authorization_transaction t ON ot.authorization_transaction_source_code = t.authorization_transaction_source_code
                AND ot.authorization_transaction_source_id = t.authorization_transaction_source_id
        WHERE ot.site_transaction_date = @TransactionDate
        GROUP BY ot.offlinx_site_id, t.moneris_customer_number, t.transaction_currency, IIF(COALESCE(t.electronic_commerce_indicator,'') IN('5','6','7','8','9'), 'E', 'S');
