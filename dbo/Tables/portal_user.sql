CREATE TABLE [dbo].[portal_user] (
    [portal_user_id]         BIGINT         IDENTITY (1, 1) NOT NULL,
    [first_name]             VARCHAR (50)   NOT NULL,
    [last_name]              VARCHAR (50)   NOT NULL,
    [username]               VARCHAR (254)  NOT NULL,
    [password]               VARCHAR (100)  NULL,
    [last_password]          NVARCHAR (MAX) NULL,
    [password_expiry]        DATETIME2 (7)  NULL,
    [authentication_attempt] INT            NOT NULL,
    [token_reset_password]   TEXT           NULL,
    [phone_number]           VARCHAR (50)   NOT NULL,
    PRIMARY KEY CLUSTERED ([portal_user_id] ASC),
    CONSTRAINT [portal_username] UNIQUE NONCLUSTERED ([username] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_username]
    ON [dbo].[portal_user]([username] ASC);

