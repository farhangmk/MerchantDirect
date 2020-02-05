CREATE TABLE [dbo].[offlinx_channel_source_type] (
    [offlinx_channel_source_type_code] CHAR (4) NOT NULL,
    [offlinx_channel_source_code]      CHAR (4) NOT NULL,
    [offlinx_channel_type_code]        CHAR (4) NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_channel_source_type_code] ASC),
    FOREIGN KEY ([offlinx_channel_source_code]) REFERENCES [dbo].[offlinx_channel_source] ([offlinx_channel_source_code]),
    FOREIGN KEY ([offlinx_channel_type_code]) REFERENCES [dbo].[offlinx_channel_type] ([offlinx_channel_type_code])
);

