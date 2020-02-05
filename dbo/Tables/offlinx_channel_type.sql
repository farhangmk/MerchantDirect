CREATE TABLE [dbo].[offlinx_channel_type] (
    [offlinx_channel_type_code] CHAR (4) NOT NULL,
    [message_code]              INT      NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_channel_type_code] ASC),
    FOREIGN KEY ([message_code]) REFERENCES [dbo].[message] ([message_code])
);

