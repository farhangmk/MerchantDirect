CREATE TABLE [dbo].[endpoint_function_type] (
    [endpoint_id]        BIGINT   NULL,
    [function_type_code] CHAR (4) NULL,
    FOREIGN KEY ([endpoint_id]) REFERENCES [dbo].[endpoint] ([endpoint_id]),
    FOREIGN KEY ([function_type_code]) REFERENCES [dbo].[function_type] ([function_type_code])
);

