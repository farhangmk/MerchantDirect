CREATE TABLE [dbo].[function_type] (
    [function_type_code]           CHAR (4)     NOT NULL,
    [name]                         VARCHAR (50) NOT NULL,
    [applicable_segment_type_code] CHAR (4)     NULL,
    PRIMARY KEY CLUSTERED ([function_type_code] ASC),
    FOREIGN KEY ([applicable_segment_type_code]) REFERENCES [dbo].[segment_type] ([segment_type_code])
);

