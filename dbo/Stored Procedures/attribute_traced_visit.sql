CREATE PROCEDURE attribute_traced_visit @OfflinxVisitID BIGINT,  @icf CHAR(24), @TransactionTimestamp DATETIME2, @OfflinxSiteID BIGINT
AS
        MERGE offlinx_attribution oa USING ( 
                SELECT ovt.offlinx_visit_trace_id , ot.offlinx_transaction_id   
                FROM  offlinx_visit_trace ovt    
                INNER JOIN offlinx_transaction ot ON ovt.icf = ot.icf 
                INNER JOIN offlinx_site os ON ot.offlinx_site_id = os.offlinx_site_id 
                WHERE  ovt.offlinx_visit_id = @OfflinxVisitID AND ovt.icf = @icf 
                AND ot.transaction_timestamp BETWEEN @TransactionTimestamp AND DATEADD(day,os.attribution_window_days, @TransactionTimestamp) AND ot.offlinx_site_id = @OfflinxSiteID    
        )  AS trans ON oa.offlinx_transaction_id = trans.offlinx_transaction_id and oa.offlinx_visit_trace_id = trans.offlinx_visit_trace_id 
        WHEN NOT MATCHED THEN INSERT (offlinx_transaction_id, offlinx_visit_trace_id) VALUES (trans.offlinx_transaction_id, trans.offlinx_visit_trace_id) 
        OUTPUT INSERTED.offlinx_transaction_id;

