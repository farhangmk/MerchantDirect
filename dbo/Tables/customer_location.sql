CREATE TABLE [dbo].[customer_location] (
    [moneris_customer_number] CHAR (13)    NOT NULL,
    [cust_nm]                 VARCHAR (30) NOT NULL,
    [store_no]                CHAR (8)     NULL,
    [mcc_code]                CHAR (4)     NOT NULL,
    [city]                    VARCHAR (30) NOT NULL,
    [province_code]           CHAR (2)     NOT NULL,
    [postal_code]             CHAR (6)     NOT NULL,
    [latitude]                CHAR (10)    NULL,
    [longitude]               CHAR (10)    NULL,
    [rbc_account_ind]         BIT          NULL,
    [bmo_account_ind]         BIT          NULL,
    [ofi_account_ind]         BIT          NULL,
    PRIMARY KEY CLUSTERED ([moneris_customer_number] ASC)
);

