CREATE TABLE [dbo].[offlinx_ovrs_attribution_expanded] (
    [offlinx_attribution_id]                BIGINT          NOT NULL,
    [offlinx_transaction_id]                BIGINT          NOT NULL,
    [offlinx_site_id]                       BIGINT          NOT NULL,
    [site_transaction_date]                 DATE            NOT NULL,
    [offlinx_channel_id]                    BIGINT          NOT NULL,
    [offlinx_channel_type_code]             CHAR (4)        NOT NULL,
    [offlinx_channel_source_code]           CHAR (4)        NOT NULL,
    [offlinx_channel_network_id]            BIGINT          NULL,
    [offlinx_device_type_code]              CHAR (4)        NOT NULL,
    [desktop]                               BIT             NOT NULL,
    [mobile]                                BIT             NOT NULL,
    [tablet]                                BIT             NOT NULL,
    [purchase_method]                       CHAR (1)        NOT NULL,
    [visitor_id]                            BIGINT          NOT NULL,
    [moneris_customer_number]               CHAR (13)       NOT NULL,
    [province_code]                         CHAR (2)        NOT NULL,
    [city]                                  VARCHAR (30)    NOT NULL,
    [attribution_amount]                    BIGINT          NOT NULL,
    [total_attributions]                    INT             NOT NULL,
    [force_ecommerce_attribution_to_actual] BIT             NOT NULL,
    [ecommerce_revenue_factor]              DECIMAL (19, 4) NULL,
    [factor]                                DECIMAL (19, 4) NULL,
    INDEX [offlinx_ovrs_attribution_expanded_1] NONCLUSTERED ([site_transaction_date], [offlinx_site_id], [desktop], [mobile], [tablet], [purchase_method], [offlinx_channel_source_code], [offlinx_channel_type_code], [offlinx_channel_network_id]),
    INDEX [offlinx_ovrs_attribution_expanded_2] NONCLUSTERED ([offlinx_site_id], [desktop], [mobile], [tablet], [purchase_method], [offlinx_channel_source_code], [offlinx_channel_type_code], [offlinx_channel_network_id])
)
WITH (DURABILITY = SCHEMA_ONLY, MEMORY_OPTIMIZED = ON);

