
CREATE PROCEDURE offlinx_transaction_card_match_tag_hit @VisitAccessID CHAR(50), @BrowserID CHAR(50), @CardMatchTimestamp DATETIME2, @UserAgent VARCHAR(1000), @NewBrowserID bit
AS
DECLARE @results TABLE (icf CHAR(24), card_match_timestamp DATETIME2, trasnaction_decline_indicator bit, new_browser_id bit);
DELETE FROM offlinx_transaction_card_match_pool OUTPUT DELETED.icf, DELETED.card_match_timestamp, DELETED.transaction_decline_indicator, @NewBrowserID INTO @results WHERE visit_access_id = @VisitAccessID AND icf IS NOT NULL;
IF @@ROWCOUNT = 0
        BEGIN
                BEGIN TRY
                        MERGE offlinx_transaction_card_match_pool P 
                        USING(SELECT @VisitAccessID as visit_access_id, @BrowserID as browser_id, @CardMatchTimestamp as card_match_timestamp, @UserAgent as user_agent, @NewBrowserID as new_browser_id) AS T 
                        ON T.visit_access_id = P.visit_access_id AND P.icf is null
                        WHEN NOT MATCHED THEN INSERT (visit_access_id,browser_id,card_match_timestamp,user_agent,new_browser_id) VALUES (T.visit_access_id,T.browser_id,T.card_match_timestamp,T.user_agent,T.new_browser_id) 
                        WHEN MATCHED THEN UPDATE SET P.browser_id = T.browser_id, P.user_agent = T.user_agent, P.new_browser_id = T.new_browser_id;
                END TRY
                BEGIN CATCH
                        --
                END CATCH
                SELECT TOP 0 NULL
        END
ELSE
        DECLARE @icf CHAR(24);
        DECLARE @TransactionDeclineIndicator bit;
        SELECT @icf = icf, @TransactionDeclineIndicator = trasnaction_decline_indicator FROM @results;

        IF @NewBrowserID = 0 and @TransactionDeclineIndicator = 0
                BEGIN
                        EXECUTE offlinx_transaction_card_match_insert @BrowserID, @icf, @CardMatchTimestamp, @UserAgent;
                END        
        ELSE
                BEGIN
                        EXECUTE offlinx_transaction_card_match_ignored_insert @BrowserID, @icf, @CardMatchTimestamp, @UserAgent;
                END        
;
