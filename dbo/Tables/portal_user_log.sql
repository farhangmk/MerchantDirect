CREATE TABLE [dbo].[portal_user_log] (
    [portal_user_log_id]           BIGINT         IDENTITY (1, 1) NOT NULL,
    [portal_user_id]               BIGINT         NULL,
    [user_name]                    VARCHAR (50)   NULL,
    [user_authority]               VARCHAR (500)  NULL,
    [request_method]               VARCHAR (500)  NULL,
    [request_url]                  VARCHAR (500)  NULL,
    [http_status]                  VARCHAR (20)   NULL,
    [body_parameter]               VARCHAR (4000) NULL,
    [query_parameter]              VARCHAR (1000) NULL,
    [created]                      DATETIME2 (7)  NOT NULL,
    [server_name]                  VARCHAR (50)   NULL,
    [client_ip]                    VARCHAR (50)   NULL,
    [user_agent]                   TEXT           NULL,
    [origem]                       VARCHAR (100)  NULL,
    [frontend_activity]            VARCHAR (100)  NULL,
    [frontend_request_description] VARCHAR (200)  NULL,
    [frontend_request_url]         VARCHAR (500)  NULL,
    PRIMARY KEY CLUSTERED ([portal_user_log_id] ASC)
);

