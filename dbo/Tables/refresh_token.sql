CREATE TABLE [dbo].[refresh_token] (
    [token_id]       BIGINT         IDENTITY (1, 1) NOT NULL,
    [portal_user_id] BIGINT         NOT NULL,
    [token]          VARCHAR (1000) NOT NULL,
    [expiry]         DATETIME2 (7)  NOT NULL,
    [action]         VARCHAR (20)   NOT NULL,
    PRIMARY KEY CLUSTERED ([token_id] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_token]
    ON [dbo].[refresh_token]([token] ASC);

