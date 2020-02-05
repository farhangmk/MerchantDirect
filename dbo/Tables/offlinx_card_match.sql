CREATE TABLE [dbo].[offlinx_card_match] (
    [browser_id]           CHAR (50)     NOT NULL,
    [icf]                  CHAR (24)     NOT NULL,
    [last_match_timestamp] DATETIME2 (7) NOT NULL,
    [num_matches]          BIGINT        NOT NULL,
    [visitor_id]           BIGINT        NULL
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_card_match_browser_icf]
    ON [dbo].[offlinx_card_match]([browser_id] ASC, [icf] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_card_match_icf]
    ON [dbo].[offlinx_card_match]([icf] ASC);

