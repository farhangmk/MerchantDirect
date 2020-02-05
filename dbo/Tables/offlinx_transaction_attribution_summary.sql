CREATE TABLE [dbo].[offlinx_transaction_attribution_summary] (
    [offlinx_transaction_id] BIGINT NOT NULL,
    [total_attributions]     INT    NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_transaction_id] ASC)
);

