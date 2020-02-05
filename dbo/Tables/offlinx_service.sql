CREATE TABLE [dbo].[offlinx_service] (
    [offlinx_service_id]       BIGINT IDENTITY (1, 1) NOT NULL,
    [org_id]                   BIGINT NOT NULL,
    [billing_customer_number]  INT    NULL,
    [estimated_monthly_visits] INT    NOT NULL,
    [maximum_monthly_visits]   INT    NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_service_id] ASC),
    FOREIGN KEY ([org_id]) REFERENCES [dbo].[org] ([org_id])
);

