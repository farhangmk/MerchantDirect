CREATE TABLE [dbo].[offlinx_site_rejected_domain] (
    [offlinx_site_id] BIGINT        NOT NULL,
    [domain_suffix]   VARCHAR (100) NOT NULL,
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);

