CREATE TABLE [dbo].[esp_transaction_addendum] (
    [esp_transaction_addendum_id]           BIGINT        NOT NULL,
    [authorization_transaction_source_code] CHAR (4)      NOT NULL,
    [authorization_transaction_source_id]   VARCHAR (32)  NOT NULL,
    [esp_order_id]                          VARCHAR (100) NOT NULL,
    [esp_customer_id]                       VARCHAR (100) NULL,
    [esp_username]                          VARCHAR (50)  NULL,
    [esp_integration_type]                  CHAR (3)      NULL,
    [token_data_group]                      INT           NULL,
    [token_data_key]                        VARCHAR (50)  NULL,
    PRIMARY KEY NONCLUSTERED ([esp_transaction_addendum_id] ASC),
    FOREIGN KEY ([authorization_transaction_source_code]) REFERENCES [dbo].[authorization_transaction_source] ([authorization_transaction_source_code])
);


GO
CREATE UNIQUE CLUSTERED INDEX [esp_transaction_addendum_source_id]
    ON [dbo].[esp_transaction_addendum]([authorization_transaction_source_code] ASC, [authorization_transaction_source_id] ASC);

