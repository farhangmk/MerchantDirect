CREATE TABLE [dbo].[generic_user] (
    [generic_user_id]     BIGINT        IDENTITY (1, 1) NOT NULL,
    [language]            CHAR (2)      NOT NULL,
    [email]               VARCHAR (254) NULL,
    [enabled]             BIT           DEFAULT ((0)) NULL,
    [last_access]         DATETIME2 (7) NULL,
    [created]             DATETIME2 (7) NULL,
    [portal_user_id]      BIGINT        NULL,
    [application_user_id] BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([generic_user_id] ASC),
    CHECK ([language]='FR' OR [language]='EN'),
    FOREIGN KEY ([application_user_id]) REFERENCES [dbo].[application_user] ([application_user_id]),
    FOREIGN KEY ([portal_user_id]) REFERENCES [dbo].[portal_user] ([portal_user_id])
);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_generic_user_email]
    ON [dbo].[generic_user]([email] ASC) WHERE ([email] IS NOT NULL);


GO
CREATE NONCLUSTERED INDEX [idx_created]
    ON [dbo].[generic_user]([created] ASC);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_generic_user_app_user]
    ON [dbo].[generic_user]([application_user_id] ASC) WHERE ([application_user_id] IS NOT NULL);


GO
CREATE UNIQUE NONCLUSTERED INDEX [idx_generic_user_portal_user]
    ON [dbo].[generic_user]([portal_user_id] ASC) WHERE ([portal_user_id] IS NOT NULL);

