CREATE TABLE [dbo].[segment_customer_hierarchy] (
    [segment_customer_hierarchy_id] BIGINT   IDENTITY (1, 1) NOT NULL,
    [segment_id]                    BIGINT   NOT NULL,
    [inst_id]                       CHAR (4) NULL,
    [essentis_cust_no]              INT      NOT NULL,
    PRIMARY KEY NONCLUSTERED ([segment_customer_hierarchy_id] ASC),
    FOREIGN KEY ([segment_id]) REFERENCES [dbo].[segment] ([segment_id])
);


GO
CREATE CLUSTERED INDEX [segment_customer_hierarchy_segment]
    ON [dbo].[segment_customer_hierarchy]([segment_id] ASC);

