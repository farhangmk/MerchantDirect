CREATE TABLE [dbo].[postal_code_location] (
    [postal_code]                  CHAR (6)     NOT NULL,
    [city]                         VARCHAR (30) NOT NULL,
    [street_name]                  VARCHAR (60) NOT NULL,
    [province_code]                CHAR (2)     NOT NULL,
    [street_direction_abbreviated] CHAR (2)     NULL,
    [street_direction_full]        CHAR (10)    NULL,
    [latitude]                     CHAR (10)    NOT NULL,
    [longitude]                    CHAR (10)    NOT NULL
);

