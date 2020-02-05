CREATE TABLE [dbo].[authorization_transaction] (
    [part_no]                                     AS            ([dbo].[part_no_731]([terminal_date])) PERSISTED NOT NULL,
    [authorization_transaction_source_code]       CHAR (4)      NOT NULL,
    [authorization_transaction_source_id]         VARCHAR (32)  NOT NULL,
    [moneris_customer_number]                     CHAR (13)     NOT NULL,
    [device_number]                               CHAR (8)      NULL,
    [transaction_timestamp]                       DATETIME2 (7) NOT NULL,
    [terminal_date]                               DATE          NOT NULL,
    [terminal_time]                               TIME (7)      NULL,
    [transaction_type_code]                       CHAR (4)      NOT NULL,
    [transaction_approved_flag]                   BIT           NOT NULL,
    [transaction_currency]                        CHAR (3)      NOT NULL,
    [transaction_amount]                          BIGINT        NOT NULL,
    [primary_account_number_prefix]               CHAR (6)      NOT NULL,
    [primary_account_number_suffix]               CHAR (4)      NOT NULL,
    [icf]                                         CHAR (24)     NOT NULL,
    [electronic_commerce_indicator]               CHAR (1)      NULL,
    [point_of_sale_entry_mode]                    CHAR (3)      NULL,
    [merchant_settlement_currency]                CHAR (3)      NULL,
    [merchant_settlement_amount]                  BIGINT        NULL,
    [card_type_code]                              CHAR (4)      DEFAULT ('    ') NOT NULL,
    [draft_capture_flag]                          BIT           DEFAULT ((1)) NOT NULL,
    [batch_number]                                CHAR (3)      NULL,
    [point_of_sale_condition_code]                CHAR (2)      NULL,
    [point_of_sale_terminal_capability_indicator] CHAR (1)      NULL,
    [moneris_response_code]                       CHAR (3)      NULL,
    [iso_response_code]                           CHAR (2)      NULL,
    [emv_response_code]                           CHAR (2)      NULL,
    [amex_action_code]                            CHAR (3)      NULL,
    [partial_authorization_indicator]             CHAR (1)      NULL,
    [cvm_results]                                 CHAR (8)      NULL,
    [cvv2_result]                                 CHAR (1)      NULL,
    [chip_condition_code]                         CHAR (1)      NULL,
    [card_verification_results]                   CHAR (8)      NULL,
    [form_factor_indicator]                       CHAR (8)      NULL,
    PRIMARY KEY NONCLUSTERED ([authorization_transaction_source_code] ASC, [authorization_transaction_source_id] ASC) ON [PRIMARY],
    CHECK ([part_no]>=(1) AND [part_no]<=(731)),
    FOREIGN KEY ([authorization_transaction_source_code]) REFERENCES [dbo].[authorization_transaction_source] ([authorization_transaction_source_code]),
    FOREIGN KEY ([transaction_type_code]) REFERENCES [dbo].[transaction_type] ([transaction_type_code])
) ON [part_no_731] ([part_no]);


GO
CREATE CLUSTERED INDEX [authorization_transaction_ix1]
    ON [dbo].[authorization_transaction]([transaction_timestamp] ASC, [moneris_customer_number] ASC, [transaction_approved_flag] ASC, [transaction_type_code] ASC, [part_no] ASC)
    ON [part_no_731] ([part_no]);


GO
CREATE NONCLUSTERED INDEX [authorization_transaction_icf]
    ON [dbo].[authorization_transaction]([icf] ASC, [transaction_timestamp] ASC, [moneris_customer_number] ASC)
    ON [part_no_731] ([part_no]);

