
CREATE PROCEDURE new_offlinx_card_match_tag_hit @VisitAccessID CHAR(50), @BrowserID CHAR(50), @CardMatchTimestamp DATETIME2
AS
DECLARE @results TABLE (icf CHAR(24), card_match_timestamp DATETIME2);
DELETE FROM offlinx_card_match_pool OUTPUT DELETED.icf, DELETED.card_match_timestamp INTO @results WHERE visit_access_id = @VisitAccessID AND icf IS NOT NULL;
IF @@ROWCOUNT = 0
        BEGIN
                BEGIN TRY
                INSERT INTO offlinx_card_match_pool (visit_access_id,browser_id,card_match_timestamp) VALUES (@VisitAccessID, @BrowserID, @CardMatchTimestamp);
                END TRY
                BEGIN CATCH
                        -- Duplicate, do nothing.
                END CATCH
                SELECT TOP 0 NULL
        END
ELSE
        BEGIN
                DECLARE @icf CHAR(24);
                SELECT @icf = icf FROM @results;
                EXECUTE new_offlinx_card_match @BrowserID, @icf, @CardMatchTimestamp;
        END;
