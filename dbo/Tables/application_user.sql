CREATE TABLE [dbo].[application_user] (
    [application_user_id] BIGINT        IDENTITY (1, 1) NOT NULL,
    [app_key]             VARCHAR (500) NOT NULL,
    [description]         VARCHAR (300) NULL,
    [expire]              DATETIME2 (7) NULL,
    [last_update]         DATETIME2 (7) NULL,
    PRIMARY KEY CLUSTERED ([application_user_id] ASC),
    CONSTRAINT [app_key] UNIQUE NONCLUSTERED ([app_key] ASC)
);


GO
CREATE NONCLUSTERED INDEX [idx_app_key]
    ON [dbo].[application_user]([app_key] ASC);

