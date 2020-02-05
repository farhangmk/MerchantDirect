CREATE TABLE [dbo].[offlinx_revenue_summary] (
    [offlinx_site_id]          BIGINT    NOT NULL,
    [moneris_customer_number]  CHAR (13) NOT NULL,
    [transaction_date]         DATE      NOT NULL,
    [transaction_currency]     CHAR (3)  NOT NULL,
    [offlinx_purchase_method]  CHAR (1)  NOT NULL,
    [total_transaction_count]  BIGINT    NOT NULL,
    [total_transaction_amount] BIGINT    NOT NULL,
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_revenue_summmary_1]
    ON [dbo].[offlinx_revenue_summary]([offlinx_site_id] ASC, [moneris_customer_number] ASC, [transaction_date] ASC, [transaction_currency] ASC, [offlinx_purchase_method] ASC);

