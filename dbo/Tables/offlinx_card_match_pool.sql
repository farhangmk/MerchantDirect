CREATE TABLE [dbo].[offlinx_card_match_pool] (
    [visit_access_id]      CHAR (50)     NOT NULL,
    [card_match_timestamp] DATETIME2 (7) NULL,
    [browser_id]           CHAR (50)     NULL,
    [icf]                  CHAR (24)     NULL,
    PRIMARY KEY NONCLUSTERED ([visit_access_id] ASC)
);


GO
CREATE UNIQUE CLUSTERED INDEX [card_match_visit_access_id]
    ON [dbo].[offlinx_card_match_pool]([visit_access_id] ASC);

