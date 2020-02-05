CREATE TABLE [dbo].[message] (
    [message_code]   INT             NOT NULL,
    [static_message] CHAR (1)        NOT NULL,
    [english]        NVARCHAR (4000) NULL,
    [french]         NVARCHAR (4000) NULL,
    PRIMARY KEY CLUSTERED ([message_code] ASC)
);

