CREATE PROCEDURE new_offlinx_card_match @BrowserID CHAR(50), @icf CHAR(24), @CardMatchTimestamp DATETIME2
AS
        BEGIN TRY
                INSERT INTO offlinx_card_match (browser_id, icf, last_match_timestamp,num_matches) 
                        OUTPUT INSERTED.browser_id, INSERTED.icf, INSERTED.last_match_timestamp
                        VALUES (@BrowserID, @icf, @CardMatchTimestamp, 1);
        
                -- Determine visitor linkage  
                DECLARE @visitorID BIGINT;                                
                SELECT TOP 1 @visitorID = visitor_id FROM offlinx_card_match WHERE icf = @icf AND visitor_id IS NOT NULL;
                IF @@ROWCOUNT = 0
                BEGIN
                        SELECT TOP 1 @visitorID = visitor_id FROM offlinx_card_match WHERE browser_id = @BrowserID AND visitor_id IS NOT NULL;        
                        IF @@ROWCOUNT = 0
                        BEGIN
                                SELECT @visitorID = NEXT VALUE FOR offlinx_visitor_id;  
                        END
                END        
                UPDATE offlinx_card_match SET visitor_id = @visitorID where browser_id = @BrowserID and icf = @icf;                       
        
                        
        END TRY
        BEGIN CATCH
                UPDATE offlinx_card_match SET last_match_timestamp = @CardMatchTimestamp, num_matches = num_matches + 1 WHERE browser_id = @BrowserID and icf = @icf;
                SELECT TOP 0 NULL
        END CATCH;
