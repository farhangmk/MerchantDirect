CREATE TABLE [dbo].[acquirer_customer] (
    [inst_id]                 CHAR (4)     NOT NULL,
    [essentis_cust_no]        INT          NOT NULL,
    [moneris_customer_number] CHAR (13)    NOT NULL,
    [cust_nm]                 VARCHAR (30) NULL,
    [store_no]                CHAR (8)     NULL,
    [location_contact_id]     INT          NOT NULL,
    [essentis_parnt_1]        INT          DEFAULT ((0)) NOT NULL,
    [essentis_parnt_2]        INT          DEFAULT ((0)) NOT NULL,
    [essentis_parnt_3]        INT          DEFAULT ((0)) NOT NULL,
    [hier_lvl]                INT          NOT NULL,
    CONSTRAINT [acquirer_customer_pk] PRIMARY KEY CLUSTERED ([inst_id] ASC, [essentis_cust_no] ASC)
);


GO
CREATE NONCLUSTERED INDEX [acquirer_cust_lvl_1]
    ON [dbo].[acquirer_customer]([inst_id] ASC, [essentis_parnt_1] ASC) WHERE ([hier_lvl]=(2));


GO
CREATE NONCLUSTERED INDEX [acquirer_cust_lvl_2]
    ON [dbo].[acquirer_customer]([inst_id] ASC, [essentis_parnt_2] ASC) WHERE ([hier_lvl]=(3));


GO
CREATE UNIQUE NONCLUSTERED INDEX [acquirer_cust_mon_cust]
    ON [dbo].[acquirer_customer]([moneris_customer_number] ASC);

