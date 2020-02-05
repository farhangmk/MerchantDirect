CREATE TYPE [dbo].[offlinx_tracking_impression_search] AS TABLE (
    [offlinx_site_id] BIGINT       NOT NULL,
    [browser_id]      VARCHAR (50) NOT NULL,
    [href_hash]       CHAR (32)    NOT NULL,
    INDEX [otis_2] ([offlinx_site_id], [href_hash]),
    INDEX [otis_1] ([offlinx_site_id], [browser_id]))
    WITH (MEMORY_OPTIMIZED = ON);

