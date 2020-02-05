CREATE PROCEDURE offlinx_transaction_card_match_ignored_insert @BrowserID CHAR(50), @icf CHAR(24), @CardMatchTimestamp DATETIME2, @UserAgent VARCHAR(1000)
AS
        BEGIN TRY
                INSERT INTO offlinx_transaction_card_match_ignored (browser_id, icf, timestamp, user_agent) 
                        VALUES (@BrowserID, @icf, @CardMatchTimestamp, @UserAgent);
        END TRY
        BEGIN CATCH
--
        END CATCH
        SELECT TOP 0 NULL;