CREATE TABLE [dbo].[offlinx_visit_v2] (
    [part_no]                            AS            ([dbo].[part_no_731]([visit_timestamp])) PERSISTED NOT NULL,
    [offlinx_visit_id]                   BIGINT        NOT NULL,
    [offlinx_site_id]                    BIGINT        NOT NULL,
    [offlinx_api_tracking_impression_id] BIGINT        NOT NULL,
    [browser_id]                         VARCHAR (50)  NOT NULL,
    [visit_timestamp]                    DATETIME2 (7) NOT NULL,
    [offlinx_device_type_code]           CHAR (4)      NOT NULL,
    [offlinx_channel_id]                 BIGINT        NULL,
    [offlinx_channel_rule_id]            BIGINT        NULL,
    PRIMARY KEY NONCLUSTERED ([offlinx_visit_id] ASC),
    CHECK ([part_no]>=(1) AND [part_no]<=(731)),
    FOREIGN KEY ([offlinx_channel_id]) REFERENCES [dbo].[offlinx_channel] ([offlinx_channel_id]),
    FOREIGN KEY ([offlinx_channel_rule_id]) REFERENCES [dbo].[offlinx_channel_rule] ([offlinx_channel_rule_id]),
    FOREIGN KEY ([offlinx_device_type_code]) REFERENCES [dbo].[offlinx_device_type] ([offlinx_device_type_code]),
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id]),
    CONSTRAINT [offlinx_visit2_api_id] UNIQUE NONCLUSTERED ([offlinx_site_id] ASC, [offlinx_api_tracking_impression_id] ASC, [part_no] ASC)
);


GO
CREATE CLUSTERED INDEX [offlinx_visit2_site_ts]
    ON [dbo].[offlinx_visit_v2]([visit_timestamp] ASC, [offlinx_site_id] ASC, [browser_id] ASC, [offlinx_device_type_code] ASC, [offlinx_channel_id] ASC, [part_no] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_visit2_browser_ts]
    ON [dbo].[offlinx_visit_v2]([browser_id] ASC, [visit_timestamp] ASC, [part_no] ASC);

