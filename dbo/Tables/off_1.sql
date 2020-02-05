CREATE TABLE [dbo].[off_1] (
    [part_no]                            INT            NOT NULL,
    [offlinx_tracking_impression_id]     BIGINT         IDENTITY (171000000, 1) NOT NULL,
    [offlinx_site_id]                    BIGINT         NOT NULL,
    [offlinx_visit_id]                   BIGINT         NULL,
    [visit_sequence_number]              SMALLINT       NULL,
    [offlinx_api_tracking_impression_id] BIGINT         NOT NULL,
    [browser_id]                         VARCHAR (50)   NOT NULL,
    [ip4_address]                        VARCHAR (15)   NOT NULL,
    [impression_timestamp]               DATETIME2 (7)  NOT NULL,
    [referrer]                           VARCHAR (3000) NULL,
    [offlinx_referrer_source_code]       CHAR (4)       NOT NULL,
    [referrer_hash]                      CHAR (32)      NOT NULL,
    [href]                               VARCHAR (3000) NOT NULL,
    [href_hash]                          CHAR (32)      NOT NULL,
    [href_root_domain]                   VARCHAR (50)   NOT NULL,
    [referrer_root_domain]               VARCHAR (50)   NULL,
    [user_agent]                         VARCHAR (1000) NULL
);

