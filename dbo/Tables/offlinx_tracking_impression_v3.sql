CREATE TABLE [dbo].[offlinx_tracking_impression_v3] (
    [part_no]                            AS             ([dbo].[part_no_731]([impression_timestamp])) PERSISTED NOT NULL,
    [offlinx_tracking_impression_id]     BIGINT         IDENTITY (171000000, 1) NOT NULL,
    [offlinx_site_id]                    BIGINT         NOT NULL,
    [offlinx_visit_id]                   BIGINT         NULL,
    [visit_sequence_number]              SMALLINT       NULL,
    [offlinx_api_tracking_impression_id] BIGINT         NOT NULL,
    [browser_id]                         VARCHAR (50)   NOT NULL,
    [ip4_address]                        VARCHAR (15)   NOT NULL,
    [impression_timestamp]               DATETIME2 (7)  NOT NULL,
    [referrer]                           VARCHAR (3000) NULL,
    [offlinx_referrer_source_code]       CHAR (4)       NOT NULL,
    [referrer_hash]                      CHAR (32)      NOT NULL,
    [href]                               VARCHAR (3000) NOT NULL,
    [href_hash]                          CHAR (32)      NOT NULL,
    [href_root_domain]                   VARCHAR (50)   NOT NULL,
    [referrer_root_domain]               VARCHAR (50)   NULL,
    [user_agent]                         VARCHAR (1000) NULL,
    PRIMARY KEY NONCLUSTERED ([offlinx_tracking_impression_id] ASC) ON [PRIMARY],
    CHECK ([part_no]>=(1) AND [part_no]<=(731)),
    FOREIGN KEY ([offlinx_referrer_source_code]) REFERENCES [dbo].[offlinx_referrer_source] ([offlinx_referrer_source_code]),
    CONSTRAINT [offlinx_tracking_impression_browser3] UNIQUE CLUSTERED ([offlinx_site_id] ASC, [browser_id] ASC, [offlinx_api_tracking_impression_id] DESC, [part_no] ASC) ON [part_no_731] ([part_no]),
    CONSTRAINT [offlinx_tracking_impression_href3] UNIQUE NONCLUSTERED ([offlinx_site_id] ASC, [href_hash] ASC, [offlinx_api_tracking_impression_id] DESC, [part_no] ASC) ON [part_no_731] ([part_no])
) ON [part_no_731] ([part_no]);


GO
CREATE NONCLUSTERED INDEX [oti3_timestamp]
    ON [dbo].[offlinx_tracking_impression_v3]([offlinx_site_id] ASC, [impression_timestamp] ASC, [part_no] ASC)
    ON [part_no_731] ([part_no]);

