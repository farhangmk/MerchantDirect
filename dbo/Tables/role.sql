CREATE TABLE [dbo].[role] (
    [role_id]       BIGINT       IDENTITY (1, 1) NOT NULL,
    [org_id]        BIGINT       NULL,
    [org_type_code] CHAR (4)     NULL,
    [name]          VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([role_id] ASC),
    FOREIGN KEY ([org_id]) REFERENCES [dbo].[org] ([org_id]),
    FOREIGN KEY ([org_type_code]) REFERENCES [dbo].[org_type] ([org_type_code])
);

