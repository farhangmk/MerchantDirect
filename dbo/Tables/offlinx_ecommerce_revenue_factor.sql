CREATE TABLE [dbo].[offlinx_ecommerce_revenue_factor] (
    [offlinx_site_id]          BIGINT          NOT NULL,
    [site_transaction_date]    DATE            NOT NULL,
    [total_transaction_amount] BIGINT          NOT NULL,
    [total_attribution_amount] BIGINT          NOT NULL,
    [revenue_factor]           DECIMAL (19, 4) NOT NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_ecommerce_revenue_factor_1]
    ON [dbo].[offlinx_ecommerce_revenue_factor]([offlinx_site_id] ASC, [site_transaction_date] ASC);

