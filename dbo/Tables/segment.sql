CREATE TABLE [dbo].[segment] (
    [segment_id]        BIGINT   IDENTITY (1, 1) NOT NULL,
    [segment_type_code] CHAR (4) NOT NULL,
    [org_id]            BIGINT   NOT NULL,
    PRIMARY KEY CLUSTERED ([segment_id] ASC),
    FOREIGN KEY ([org_id]) REFERENCES [dbo].[org] ([org_id]),
    FOREIGN KEY ([segment_type_code]) REFERENCES [dbo].[segment_type] ([segment_type_code])
);

