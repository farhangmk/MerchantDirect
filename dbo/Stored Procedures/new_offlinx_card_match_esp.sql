CREATE PROCEDURE new_offlinx_card_match_esp @VisitAccessID CHAR(50), @icf CHAR(24)
AS
DECLARE @results TABLE (browser_id CHAR(50), card_match_timestamp DATETIME2);
DELETE FROM offlinx_card_match_pool OUTPUT DELETED.browser_id, DELETED.card_match_timestamp INTO @results WHERE visit_access_id = @VisitAccessID AND browser_id IS NOT NULL;
IF @@ROWCOUNT = 0
BEGIN
        BEGIN TRY
        INSERT INTO offlinx_card_match_pool (visit_access_id,icf) VALUES (@VisitAccessID, @icf);
        END TRY
        BEGIN CATCH
                -- Duplicate, do nothing.
        END CATCH
        SELECT TOP 0 NULL
END
ELSE
BEGIN
        DECLARE @BrowserID CHAR(50);
        DECLARE @CardMatchTimestamp DATETIME2;
        SELECT @BrowserID = browser_id, @CardMatchTimestamp = card_match_timestamp FROM @results;
        EXECUTE new_offlinx_card_match @BrowserID, @icf, @CardMatchTimestamp;

END;
