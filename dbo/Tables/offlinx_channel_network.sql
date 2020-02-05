CREATE TABLE [dbo].[offlinx_channel_network] (
    [offlinx_channel_network_id] BIGINT       IDENTITY (1, 1) NOT NULL,
    [offlinx_service_id]         BIGINT       NULL,
    [name]                       VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_channel_network_id] ASC),
    FOREIGN KEY ([offlinx_service_id]) REFERENCES [dbo].[offlinx_service] ([offlinx_service_id])
);

