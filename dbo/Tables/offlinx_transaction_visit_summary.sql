CREATE TABLE [dbo].[offlinx_transaction_visit_summary] (
    [offlinx_site_id]         BIGINT NOT NULL,
    [site_transaction_date]   DATE   NOT NULL,
    [offlinx_channel_id]      BIGINT NOT NULL,
    [total_visits]            INT    NOT NULL,
    [total_traced_visits]     INT    NOT NULL,
    [factor]                  AS     (case when [total_traced_visits]=(0) then (0) else CONVERT([decimal](19,4),CONVERT([decimal](10,0),[total_visits])/CONVERT([decimal](10,0),[total_traced_visits])) end) PERSISTED,
    [total_attributed_visits] INT    DEFAULT ((-1)) NOT NULL,
    [attribution_factor]      AS     (case when [total_traced_visits]=(0) then (0) else CONVERT([decimal](19,4),CONVERT([decimal](10,0),[total_attributed_visits])/CONVERT([decimal](10,0),[total_traced_visits])) end) PERSISTED,
    FOREIGN KEY ([offlinx_channel_id]) REFERENCES [dbo].[offlinx_channel] ([offlinx_channel_id]),
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_transaction_visit_summary_1]
    ON [dbo].[offlinx_transaction_visit_summary]([offlinx_site_id] ASC, [site_transaction_date] ASC, [offlinx_channel_id] ASC);

