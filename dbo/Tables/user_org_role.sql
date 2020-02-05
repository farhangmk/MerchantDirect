CREATE TABLE [dbo].[user_org_role] (
    [user_org_role_id] BIGINT IDENTITY (1, 1) NOT NULL,
    [generic_user_id]  BIGINT NOT NULL,
    [org_id]           BIGINT NOT NULL,
    [role_id]          BIGINT NOT NULL,
    PRIMARY KEY CLUSTERED ([user_org_role_id] ASC),
    FOREIGN KEY ([generic_user_id]) REFERENCES [dbo].[generic_user] ([generic_user_id]),
    FOREIGN KEY ([org_id]) REFERENCES [dbo].[org] ([org_id]),
    FOREIGN KEY ([role_id]) REFERENCES [dbo].[role] ([role_id])
);

