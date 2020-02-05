CREATE TABLE [dbo].[role_function] (
    [role_function_id] BIGINT         IDENTITY (1, 1) NOT NULL,
    [role_id]          BIGINT         NOT NULL,
    [function_type_id] CHAR (4)       NOT NULL,
    [rank]             SMALLINT       DEFAULT ((0)) NOT NULL,
    [segment_id]       BIGINT         NULL,
    [parameters]       VARCHAR (4000) NULL,
    PRIMARY KEY CLUSTERED ([role_function_id] ASC),
    FOREIGN KEY ([function_type_id]) REFERENCES [dbo].[function_type] ([function_type_code]),
    FOREIGN KEY ([role_id]) REFERENCES [dbo].[role] ([role_id]),
    FOREIGN KEY ([segment_id]) REFERENCES [dbo].[segment] ([segment_id]),
    CONSTRAINT [role_function_u] UNIQUE NONCLUSTERED ([role_id] ASC, [function_type_id] ASC, [rank] ASC)
);

