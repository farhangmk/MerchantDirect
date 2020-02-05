CREATE TABLE [dbo].[offlinx_transaction_card_match_pool] (
    [visit_access_id]               CHAR (50)      NOT NULL,
    [card_match_timestamp]          DATETIME2 (7)  NULL,
    [browser_id]                    CHAR (50)      NULL,
    [user_agent]                    VARCHAR (1000) NULL,
    [new_browser_id]                BIT            NULL,
    [icf]                           CHAR (24)      NULL,
    [transaction_decline_indicator] BIT            NULL,
    PRIMARY KEY CLUSTERED ([visit_access_id] ASC)
);

