CREATE TABLE [dbo].[network_range_entry_ip4] (
    [network_range_entry_id] BIGINT    IDENTITY (1, 1) NOT NULL,
    [network_range_group_id] BIGINT    NOT NULL,
    [begin_ip]               CHAR (15) NOT NULL,
    [cidr_prefix]            SMALLINT  DEFAULT ((32)) NOT NULL,
    [end_ip]                 CHAR (15) NULL,
    PRIMARY KEY CLUSTERED ([network_range_entry_id] ASC),
    FOREIGN KEY ([network_range_group_id]) REFERENCES [dbo].[network_range_group] ([network_range_group_id])
);

