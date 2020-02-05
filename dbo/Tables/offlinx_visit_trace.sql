CREATE TABLE [dbo].[offlinx_visit_trace] (
    [offlinx_visit_trace_id] BIGINT    IDENTITY (1, 1) NOT NULL,
    [offlinx_visit_id]       BIGINT    NOT NULL,
    [icf]                    CHAR (24) NOT NULL,
    PRIMARY KEY NONCLUSTERED ([offlinx_visit_trace_id] ASC)
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_visit_trace_visit_icf]
    ON [dbo].[offlinx_visit_trace]([offlinx_visit_id] ASC, [icf] ASC);


GO
CREATE NONCLUSTERED INDEX [offlinx_visit_trace_icf]
    ON [dbo].[offlinx_visit_trace]([icf] ASC);

