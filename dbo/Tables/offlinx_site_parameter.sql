CREATE TABLE [dbo].[offlinx_site_parameter] (
    [offlinx_site_parameter_id] BIGINT       IDENTITY (1, 1) NOT NULL,
    [offlinx_site_id]           BIGINT       NOT NULL,
    [parameter]                 VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_site_parameter_id] ASC),
    FOREIGN KEY ([offlinx_site_id]) REFERENCES [dbo].[offlinx_site] ([offlinx_site_id])
);

