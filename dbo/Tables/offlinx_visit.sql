CREATE TABLE [dbo].[offlinx_visit] (
    [offlinx_visit_id]         BIGINT        IDENTITY (1, 1) NOT NULL,
    [offlinx_site_id]          BIGINT        NOT NULL,
    [browser_id]               VARCHAR (50)  NOT NULL,
    [visit_timestamp]          DATETIME2 (7) NOT NULL,
    [offlinx_device_type_code] CHAR (4)      NOT NULL,
    [offlinx_channel_id]       BIGINT        NULL,
    [offlinx_channel_rule_id]  BIGINT        NULL,
    PRIMARY KEY CLUSTERED ([offlinx_visit_id] ASC),
    FOREIGN KEY ([offlinx_channel_id]) REFERENCES [dbo].[offlinx_channel] ([offlinx_channel_id]),
    FOREIGN KEY ([offlinx_channel_rule_id]) REFERENCES [dbo].[offlinx_channel_rule] ([offlinx_channel_rule_id]),
    FOREIGN KEY ([offlinx_device_type_code]) REFERENCES [dbo].[offlinx_device_type] ([offlinx_device_type_code]),
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);


GO
CREATE NONCLUSTERED INDEX [offlinx_visit_browser_ts]
    ON [dbo].[offlinx_visit]([browser_id] ASC, [visit_timestamp] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_visit_site_ts]
    ON [dbo].[offlinx_visit]([offlinx_site_id] ASC, [visit_timestamp] ASC);


GO
CREATE NONCLUSTERED INDEX [ov_ix2]
    ON [dbo].[offlinx_visit]([visit_timestamp] ASC, [offlinx_site_id] ASC, [browser_id] ASC, [offlinx_device_type_code] ASC, [offlinx_channel_id] ASC);

