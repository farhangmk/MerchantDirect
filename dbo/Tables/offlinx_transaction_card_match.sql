CREATE TABLE [dbo].[offlinx_transaction_card_match] (
    [icf]                       CHAR (24)      NOT NULL,
    [browser_id]                CHAR (50)      NOT NULL,
    [last_match_timestamp]      DATETIME2 (7)  NOT NULL,
    [last_match_year_dayofyear] AS             (datepart(year,[last_match_timestamp])*(1000)+datepart(dayofyear,[last_match_timestamp])) PERSISTED NOT NULL,
    [last_user_agent]           VARCHAR (1000) NULL,
    [num_matches]               BIGINT         NOT NULL,
    [visitor_id]                BIGINT         NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_tx_card_match_icf_browser]
    ON [dbo].[offlinx_transaction_card_match]([icf] ASC, [browser_id] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_tx_card_match_browser_id]
    ON [dbo].[offlinx_transaction_card_match]([browser_id] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_tx_card_match_delete]
    ON [dbo].[offlinx_transaction_card_match]([last_match_year_dayofyear] ASC, [num_matches] ASC);

