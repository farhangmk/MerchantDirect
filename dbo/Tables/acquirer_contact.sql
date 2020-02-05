CREATE TABLE [dbo].[acquirer_contact] (
    [inst_id]        CHAR (4)     NOT NULL,
    [contact_id]     INT          NOT NULL,
    [language]       CHAR (4)     NOT NULL,
    [address_line_1] VARCHAR (60) NULL,
    [address_line_2] VARCHAR (60) NULL,
    [address_line_3] VARCHAR (60) NULL,
    [city]           VARCHAR (30) NULL,
    [province_code]  CHAR (2)     NULL,
    [postal_code]    CHAR (6)     NULL,
    [country_code]   CHAR (4)     NULL,
    [email]          VARCHAR (60) NULL,
    CONSTRAINT [acquirer_contact_pk] PRIMARY KEY CLUSTERED ([inst_id] ASC, [contact_id] ASC)
);

