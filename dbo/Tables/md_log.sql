CREATE TABLE [dbo].[md_log] (
    [md_log_id]        BIGINT         IDENTITY (1, 1) NOT NULL,
    [generic_user_id]  BIGINT         NULL,
    [api_reference_id] VARCHAR (200)  NULL,
    [request_method]   VARCHAR (500)  NULL,
    [http_status]      SMALLINT       NULL,
    [request_url]      VARCHAR (500)  NULL,
    [request_ip]       VARCHAR (50)   NULL,
    [request_body]     VARCHAR (MAX)  NULL,
    [response_body]    VARCHAR (MAX)  NULL,
    [uri_parameter]    VARCHAR (500)  NULL,
    [log_timestamp]    DATETIME2 (7)  NOT NULL,
    [server_name]      VARCHAR (50)   NULL,
    [user_agent]       VARCHAR (1000) NULL,
    PRIMARY KEY CLUSTERED ([md_log_id] ASC)
);

