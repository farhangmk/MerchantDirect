CREATE TABLE [dbo].[offlinx_channel_source] (
    [offlinx_channel_source_code] CHAR (4)     NOT NULL,
    [message_code]                INT          NOT NULL,
    [color]                       VARCHAR (25) NULL,
    PRIMARY KEY CLUSTERED ([offlinx_channel_source_code] ASC),
    FOREIGN KEY ([message_code]) REFERENCES [dbo].[message] ([message_code])
);

