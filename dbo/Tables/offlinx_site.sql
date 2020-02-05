CREATE TABLE [dbo].[offlinx_site] (
    [offlinx_site_id]                       BIGINT         IDENTITY (1, 1) NOT NULL,
    [offlinx_service_id]                    BIGINT         NOT NULL,
    [active]                                BIT            NOT NULL,
    [deleted]                               BIT            DEFAULT ((0)) NOT NULL,
    [offlinx_api_merchant_id]               VARCHAR (50)   NOT NULL,
    [segment_id]                            BIGINT         NOT NULL,
    [offlinx_attribution_model]             CHAR (4)       NOT NULL,
    [attribution_window_days]               SMALLINT       NOT NULL,
    [timezone]                              NVARCHAR (128) NOT NULL,
    [force_ecommerce_attribution_to_actual] BIT            DEFAULT ((0)) NOT NULL,
    [minimum_interval_days]                 SMALLINT       DEFAULT ((1)) NOT NULL,
    [default_interval_days]                 SMALLINT       DEFAULT ((1)) NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_site_id] ASC),
    FOREIGN KEY ([offlinx_attribution_model]) REFERENCES [dbo].[offlinx_attribution_model] ([offlinx_attribution_model_code]),
    FOREIGN KEY ([offlinx_service_id]) REFERENCES [dbo].[offlinx_service] ([offlinx_service_id]),
    FOREIGN KEY ([segment_id]) REFERENCES [dbo].[segment] ([segment_id])
);


GO
CREATE NONCLUSTERED INDEX [offlinx_site_segment]
    ON [dbo].[offlinx_site]([segment_id] ASC)
    INCLUDE([offlinx_site_id]);

