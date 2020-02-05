CREATE TABLE [dbo].[offlinx_attribution] (
    [offlinx_attribution_id] BIGINT IDENTITY (1, 1) NOT NULL,
    [offlinx_transaction_id] BIGINT NOT NULL,
    [offlinx_visit_trace_id] BIGINT NOT NULL,
    PRIMARY KEY NONCLUSTERED ([offlinx_attribution_id] ASC),
    FOREIGN KEY ([offlinx_transaction_id]) REFERENCES [dbo].[offlinx_transaction] ([offlinx_transaction_id]),
    FOREIGN KEY ([offlinx_visit_trace_id]) REFERENCES [dbo].[offlinx_visit_trace] ([offlinx_visit_trace_id])
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_attribution_tx]
    ON [dbo].[offlinx_attribution]([offlinx_transaction_id] ASC, [offlinx_visit_trace_id] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_attribution_visit_trace]
    ON [dbo].[offlinx_attribution]([offlinx_visit_trace_id] ASC);

