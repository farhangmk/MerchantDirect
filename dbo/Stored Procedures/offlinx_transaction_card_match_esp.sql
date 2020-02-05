
CREATE PROCEDURE offlinx_transaction_card_match_esp @VisitAccessID CHAR(50), @icf CHAR(24), @TransactionDeclineIndicator bit
AS
DECLARE @results TABLE (browser_id CHAR(50), card_match_timestamp DATETIME2, user_agent VARCHAR(1000), new_browser_id bit);
DELETE FROM offlinx_transaction_card_match_pool OUTPUT DELETED.browser_id, DELETED.card_match_timestamp, DELETED.user_agent, DELETED.new_browser_id INTO @results WHERE visit_access_id = @VisitAccessID AND browser_id IS NOT NULL;
IF @@ROWCOUNT = 0
BEGIN
        BEGIN TRY
                        MERGE offlinx_transaction_card_match_pool P 
                        USING(SELECT @VisitAccessID as visit_access_id, @icf as icf, @TransactionDeclineIndicator as transaction_decline_indicator) AS T 
                        ON T.visit_access_id = P.visit_access_id  AND P.browser_id IS NULL
                        WHEN NOT MATCHED THEN INSERT (visit_access_id,icf,transaction_decline_indicator) VALUES (T.visit_access_id,T.icf,T.transaction_decline_indicator) 
                        WHEN MATCHED THEN UPDATE SET P.transaction_decline_indicator = T.transaction_decline_indicator;
        END TRY
        BEGIN CATCH
                -- Duplicate, do nothing.
        END CATCH
        SELECT TOP 0 NULL
END
ELSE
        DECLARE @BrowserID CHAR(50);
        DECLARE @CardMatchTimestamp DATETIME2;
        DECLARE @UserAgent VARCHAR(1000);
        DECLARE @NewBrowserID bit;
        SELECT @BrowserID = browser_id, @CardMatchTimestamp = card_match_timestamp, @UserAgent = user_agent, @NewBrowserID = new_browser_id FROM @results;
        IF @NewBrowserID = 0 and @TransactionDeclineIndicator = 0
                BEGIN
                        EXECUTE offlinx_transaction_card_match_insert @BrowserID, @icf, @CardMatchTimestamp, @UserAgent;
                END        
        ELSE
                BEGIN
                        EXECUTE offlinx_transaction_card_match_ignored_insert @BrowserID, @icf, @CardMatchTimestamp, @UserAgent;
                END
;