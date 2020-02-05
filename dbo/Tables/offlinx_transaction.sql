CREATE TABLE [dbo].[offlinx_transaction] (
    [offlinx_transaction_id]                BIGINT        IDENTITY (1, 1) NOT NULL,
    [authorization_transaction_source_code] CHAR (4)      NOT NULL,
    [authorization_transaction_source_id]   VARCHAR (32)  NOT NULL,
    [offlinx_site_id]                       BIGINT        NOT NULL,
    [site_transaction_date]                 DATE          NOT NULL,
    [icf]                                   CHAR (24)     NULL,
    [transaction_timestamp]                 DATETIME2 (7) NULL,
    PRIMARY KEY NONCLUSTERED ([offlinx_transaction_id] ASC),
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_transaction_site]
    ON [dbo].[offlinx_transaction]([offlinx_site_id] ASC, [authorization_transaction_source_code] ASC, [authorization_transaction_source_id] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_tx_site_tx_date]
    ON [dbo].[offlinx_transaction]([site_transaction_date] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_tx_icf_timestamp]
    ON [dbo].[offlinx_transaction]([icf] ASC, [transaction_timestamp] ASC);

