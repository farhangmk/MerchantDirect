CREATE TYPE [dbo].[offlinx_transaction_table] AS TABLE (
    [authorization_transaction_source_code] CHAR (4)     NOT NULL,
    [authorization_transaction_source_id]   VARCHAR (32) NOT NULL,
    [moneris_customer_number]               CHAR (13)    NOT NULL,
    [icf]                                   CHAR (24)    NOT NULL,
    [transaction_timestamp]                 BIGINT       NOT NULL);

