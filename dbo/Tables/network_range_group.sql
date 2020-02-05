CREATE TABLE [dbo].[network_range_group] (
    [network_range_group_id] BIGINT IDENTITY (1, 1) NOT NULL,
    [org_id]                 BIGINT NOT NULL,
    PRIMARY KEY CLUSTERED ([network_range_group_id] ASC),
    FOREIGN KEY ([org_id]) REFERENCES [dbo].[org] ([org_id])
);

