CREATE TABLE [dbo].[org] (
    [org_id]                   BIGINT       IDENTITY (1, 1) NOT NULL,
    [org_type_code]            CHAR (4)     NOT NULL,
    [name]                     VARCHAR (50) NOT NULL,
    [trusted_network_range_id] BIGINT       NULL,
    [master_segment_id]        BIGINT       NULL,
    PRIMARY KEY CLUSTERED ([org_id] ASC),
    FOREIGN KEY ([org_type_code]) REFERENCES [dbo].[org_type] ([org_type_code]),
    CONSTRAINT [fk_org1] FOREIGN KEY ([trusted_network_range_id]) REFERENCES [dbo].[network_range_group] ([network_range_group_id]),
    CONSTRAINT [fk_org2] FOREIGN KEY ([master_segment_id]) REFERENCES [dbo].[segment] ([segment_id])
);

