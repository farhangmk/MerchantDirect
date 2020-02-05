CREATE TABLE [dbo].[org_valid_function_type] (
    [org_valid_function_type_id] BIGINT   IDENTITY (1, 1) NOT NULL,
    [org_type_code]              CHAR (4) NOT NULL,
    [function_type_code]         CHAR (4) NOT NULL,
    PRIMARY KEY CLUSTERED ([org_valid_function_type_id] ASC),
    FOREIGN KEY ([function_type_code]) REFERENCES [dbo].[function_type] ([function_type_code]),
    FOREIGN KEY ([org_type_code]) REFERENCES [dbo].[org_type] ([org_type_code])
);

