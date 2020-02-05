CREATE TABLE [dbo].[feature_flags] (
    [feature_flag_id]    BIGINT        IDENTITY (1, 1) NOT NULL,
    [application_name]   VARCHAR (100) NOT NULL,
    [environment]        VARCHAR (100) NOT NULL,
    [published]          BIT           DEFAULT ((1)) NOT NULL,
    [modified_timestamp] DATETIME2 (7) CONSTRAINT [DF_feature_flags_timestamp] DEFAULT (getdate()) NOT NULL,
    [config]             VARCHAR (MAX) NULL,
    PRIMARY KEY CLUSTERED ([feature_flag_id] DESC),
    CONSTRAINT [App_Env_Pub_Date] UNIQUE NONCLUSTERED ([application_name] ASC, [environment] ASC, [published] ASC, [modified_timestamp] ASC)
);

