CREATE TABLE [dbo].[offlinx_visit_revenue_summary] (
    [part_no]                     AS            ([dbo].[part_no_731]([to_date])) PERSISTED NOT NULL,
    [offlinx_site_id]             BIGINT        NOT NULL,
    [from_date]                   DATE          NOT NULL,
    [to_date]                     DATE          NOT NULL,
    [offlinx_channel_type_code]   CHAR (4)      NULL,
    [offlinx_channel_source_code] CHAR (4)      NULL,
    [offlinx_channel_network_id]  BIGINT        NULL,
    [offlinx_device_type_desktop] BIT           NOT NULL,
    [offlinx_device_type_mobile]  BIT           NOT NULL,
    [offlinx_device_type_tablet]  BIT           NOT NULL,
    [summary_data]                VARCHAR (MAX) NOT NULL,
    CHECK ([part_no]>=(1) AND [part_no]<=(731)),
    FOREIGN KEY ([offlinx_channel_network_id]) REFERENCES [dbo].[offlinx_channel_network] ([offlinx_channel_network_id]),
    FOREIGN KEY ([offlinx_channel_source_code]) REFERENCES [dbo].[offlinx_channel_source] ([offlinx_channel_source_code]),
    FOREIGN KEY ([offlinx_channel_type_code]) REFERENCES [dbo].[offlinx_channel_type] ([offlinx_channel_type_code]),
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
) ON [part_no_731] ([part_no]);


GO
CREATE UNIQUE CLUSTERED INDEX [visit_summary]
    ON [dbo].[offlinx_visit_revenue_summary]([offlinx_site_id] ASC, [from_date] ASC, [to_date] ASC, [offlinx_channel_type_code] ASC, [offlinx_channel_source_code] ASC, [offlinx_channel_network_id] ASC, [offlinx_device_type_desktop] ASC, [offlinx_device_type_mobile] ASC, [offlinx_device_type_tablet] ASC, [part_no] ASC)
    ON [part_no_731] ([part_no]);

