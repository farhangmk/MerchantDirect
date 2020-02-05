CREATE TABLE [dbo].[offlinx_ovrs_visit_expanded] (
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
    INDEX [offlinx_ovrs_visit_expanded_1] NONCLUSTERED ([site_visit_date], [offlinx_site_id], [desktop], [mobile], [tablet], [offlinx_channel_type_code], [offlinx_channel_source_code], [offlinx_channel_network_id])
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

