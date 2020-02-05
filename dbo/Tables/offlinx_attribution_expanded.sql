CREATE TABLE [dbo].[offlinx_attribution_expanded] (
    [offlinx_attribution_id]      BIGINT       NOT NULL,
    [offlinx_site_id]             BIGINT       NOT NULL,
    [site_transaction_date]       DATE         NOT NULL,
    [offlinx_channel_id]          BIGINT       NOT NULL,
    [offlinx_channel_type_code]   CHAR (4)     NOT NULL,
    [offlinx_channel_source_code] CHAR (4)     NOT NULL,
    [offlinx_channel_network_id]  BIGINT       NULL,
    [offlinx_device_type_code]    CHAR (4)     NOT NULL,
    [desktop]                     BIT          NOT NULL,
    [mobile]                      BIT          NOT NULL,
    [tablet]                      BIT          NOT NULL,
    [purchase_method]             CHAR (1)     NOT NULL,
    [visitor_id]                  BIGINT       NOT NULL,
    [moneris_customer_number]     CHAR (13)    NOT NULL,
    [province_code]               CHAR (2)     NOT NULL,
    [city]                        VARCHAR (30) NOT NULL,
    [attribution_amount]          BIGINT       NOT NULL,
    [total_attributions]          INT          NOT NULL,
    [offlinx_transaction_id]      BIGINT       NOT NULL
);


GO
CREATE CLUSTERED INDEX [offlinx_attribution_expanded_1]
    ON [dbo].[offlinx_attribution_expanded]([site_transaction_date] ASC, [offlinx_site_id] ASC, [desktop] ASC, [mobile] ASC, [tablet] ASC, [purchase_method] ASC, [offlinx_channel_source_code] ASC, [offlinx_channel_type_code] ASC, [offlinx_channel_network_id] ASC);

