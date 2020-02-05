CREATE TABLE [dbo].[offlinx_visit_expanded] (
    [part_no]                     AS       ([dbo].[part_no_62]([site_visit_date])) PERSISTED NOT NULL,
    [offlinx_visit_id]            BIGINT   NOT NULL,
    [offlinx_site_id]             BIGINT   NOT NULL,
    [site_visit_date]             DATE     NOT NULL,
    [offlinx_channel_type_code]   CHAR (4) NOT NULL,
    [offlinx_channel_source_code] CHAR (4) NOT NULL,
    [offlinx_channel_network_id]  BIGINT   NULL,
    [offlinx_device_type_code]    CHAR (4) NOT NULL,
    [desktop]                     BIT      NOT NULL,
    [mobile]                      BIT      NOT NULL,
    [tablet]                      BIT      NOT NULL,
    [visitor_id]                  BIGINT   NULL,
    CHECK ([part_no]>=(1) AND [part_no]<=(62))
) ON [part_no_62] ([part_no]);


GO
CREATE CLUSTERED INDEX [ove_ix1]
    ON [dbo].[offlinx_visit_expanded]([site_visit_date] ASC, [offlinx_site_id] ASC, [desktop] ASC, [mobile] ASC, [tablet] ASC, [offlinx_channel_type_code] ASC, [offlinx_channel_source_code] ASC, [offlinx_channel_network_id] ASC)
    ON [part_no_62] ([part_no]);

