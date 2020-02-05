CREATE TABLE [dbo].[authorization_transaction_source] (
    [authorization_transaction_source_code] CHAR (4)     NOT NULL,
    [name]                                  VARCHAR (50) NOT NULL,
    PRIMARY KEY CLUSTERED ([authorization_transaction_source_code] ASC)
);

