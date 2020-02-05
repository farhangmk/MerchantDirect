CREATE TABLE [dbo].[offlinx_channel] (
    [offlinx_channel_id]               BIGINT   IDENTITY (1, 1) NOT NULL,
    [offlinx_service_id]               BIGINT   NOT NULL,
    [offlinx_channel_source_type_code] CHAR (4) NOT NULL,
    [offlinx_channel_network_id]       BIGINT   NULL,
    PRIMARY KEY CLUSTERED ([offlinx_channel_id] ASC),
    FOREIGN KEY ([offlinx_channel_network_id]) REFERENCES [dbo].[offlinx_channel_network] ([offlinx_channel_network_id]),
    FOREIGN KEY ([offlinx_channel_source_type_code]) REFERENCES [dbo].[offlinx_channel_source_type] ([offlinx_channel_source_type_code]),
    FOREIGN KEY ([offlinx_service_id]) REFERENCES [dbo].[offlinx_service] ([offlinx_service_id])
);

