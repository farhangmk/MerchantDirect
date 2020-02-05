CREATE TABLE [dbo].[offlinx_channel_rule] (
    [offlinx_channel_rule_id] BIGINT         IDENTITY (1, 1) NOT NULL,
    [active]                  BIT            DEFAULT ((1)) NOT NULL,
    [offlinx_site_id]         BIGINT         NOT NULL,
    [rank]                    SMALLINT       NOT NULL,
    [href_paramater_regex]    VARCHAR (1000) NULL,
    [referrer_sld_regex]      VARCHAR (1000) NULL,
    [referrer_domain_regex]   VARCHAR (1000) NULL,
    [offlinx_channel_id]      BIGINT         NULL,
    PRIMARY KEY NONCLUSTERED ([offlinx_channel_rule_id] ASC),
    FOREIGN KEY ([offlinx_channel_id]) REFERENCES [dbo].[offlinx_channel] ([offlinx_channel_id]),
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);


GO
CREATE UNIQUE CLUSTERED INDEX [offlinx_channel_rule]
    ON [dbo].[offlinx_channel_rule]([offlinx_site_id] ASC, [rank] ASC);

