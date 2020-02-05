CREATE TABLE [dbo].[offlinx_ovrs_visit_staging] (
    [offlinx_site_id]             BIGINT        NOT NULL,
    [from_date]                   DATE          NOT NULL,
    [to_date]                     DATE          NOT NULL,
    [offlinx_channel_type_code]   CHAR (4)      NOT NULL,
    [offlinx_channel_source_code] CHAR (4)      NOT NULL,
    [offlinx_channel_network_id]  BIGINT        NOT NULL,
    [desktop]                     BIT           NOT NULL,
    [mobile]                      BIT           NOT NULL,
    [tablet]                      BIT           NOT NULL,
    [visits]                      VARCHAR (MAX) NOT NULL,
    INDEX [ovrs_visit_staging1] NONCLUSTERED ([offlinx_site_id], [from_date], [to_date], [offlinx_channel_type_code], [offlinx_channel_source_code], [offlinx_channel_network_id], [desktop], [mobile], [tablet])
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

