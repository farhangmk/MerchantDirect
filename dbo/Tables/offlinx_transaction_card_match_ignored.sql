CREATE TABLE [dbo].[offlinx_transaction_card_match_ignored] (
    [icf]        CHAR (24)      NOT NULL,
    [browser_id] CHAR (50)      NOT NULL,
    [timestamp]  DATETIME2 (7)  NOT NULL,
    [user_agent] VARCHAR (1000) NULL
);


GO
CREATE CLUSTERED INDEX [offlinx_tx_card_match_ignored]
    ON [dbo].[offlinx_transaction_card_match_ignored]([timestamp] ASC);

