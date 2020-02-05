CREATE TABLE [dbo].[offlinx_topic_partition_offset] (
    [offlinx_topic_partition_offset_id] INT          IDENTITY (1, 1) NOT NULL,
    [offlinx_topic]                     VARCHAR (50) NOT NULL,
    [offlinx_partion]                   INT          NOT NULL,
    [offlinx_offset]                    BIGINT       NOT NULL,
    PRIMARY KEY CLUSTERED ([offlinx_topic_partition_offset_id] ASC)
);

