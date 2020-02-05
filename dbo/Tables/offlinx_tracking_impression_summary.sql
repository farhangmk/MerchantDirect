CREATE TABLE [dbo].[offlinx_tracking_impression_summary] (
    [offlinx_site_id]  BIGINT NOT NULL,
    [impression_date]  DATE   NOT NULL,
    [impression_count] BIGINT NOT NULL,
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_tracking_impression_summmary_1]
    ON [dbo].[offlinx_tracking_impression_summary]([offlinx_site_id] ASC, [impression_date] ASC);

