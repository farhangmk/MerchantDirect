CREATE TABLE [dbo].[endpoint] (
    [endpoint_id]               BIGINT         IDENTITY (1, 1) NOT NULL,
    [enabled]                   BIT            DEFAULT ((0)) NULL,
    [api_url]                   VARCHAR (1000) NOT NULL,
    [request_method]            VARCHAR (10)   NOT NULL,
    [created_by_portal_user_id] BIGINT         NOT NULL,
    [created]                   DATETIME2 (7)  NULL,
    [auth_type]                 CHAR (4)       NOT NULL,
    [destination_uri]           VARCHAR (1000) NOT NULL,
    PRIMARY KEY CLUSTERED ([endpoint_id] ASC)
);

