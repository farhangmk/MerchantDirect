create   procedure offlinx_summarization_check 
@action varchar(10) = null, -- default it will generate the report. if we pass run it will trigger the execution.
@ExecRestartPoint int = null, -- incase we need to restart from a execution point - Needed if in case execution fails partially
@RestartSubPoint int = null, -- incase it fails on lookback date. Mention the lookback day in number. - Needed if in case execution fails partially
@RecCutoffTime date = null --- incase cutoff time need to be changed.
AS
DECLARE @PendingRecordCount int
DECLARE @ThisSql nvarchar(1000)
BEGIN 
        DECLARE @CutoffTime date = isnull(@RecCutoffTime,dateadd(minute,-DATEPART(TZOFFSET, getdate() AT TIME ZONE 'Eastern Standard Time'),convert(varchar(10),getdate(),120)+' 00:00:00'))
BEGIN TRY
        --------------------------------------------------------------  Pre Check SQL : START  ----------------------------------------------------------
        With 
	reftable as
	(select md2.dbo.part_no_731(@CutoffTime) Partition_ID, @CutoffTime Cutoff_Time)     
	, detailedreport as
        (select *
        from (
                --------------------------------------------------------------------------- check 1: offlinx_attribution_transaction_check : START --------------------------------------------------------------------------- 
                select  1 check_group, 1 check_sub_group, 'Offlinx_attribution_transaction_check' check_type
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),max(transaction_timestamp)) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , max(transaction_timestamp) latest_timestamp
                        ,datediff(minute,(select Cutoff_Time from reftable),max(transaction_timestamp)) time_gap
                        , null SiteDetails
                from    MD2.dbo.offlinx_attribution oa
                        , MD2.dbo.offlinx_transaction ot 
                where 1=1
                and oa.offlinx_transaction_id=ot.offlinx_transaction_id
                --order by oa.offlinx_attribution_id desc
                -------------------------------------------------------------------------------  check1 : END ----------------------------------------------------------------------------------------------------------------
                union
                ---------------------------------------------------------------------------------  check 2: offlinx_transaction_check : START ---------------------------------------------------------------------------------- 
                select  2 check_group, 1 check_sub_group, 'Offlinx_transaction_check' check_type
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),max(transaction_timestamp)) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , max(transaction_timestamp) latest_timestamp
                        , datediff(minute,(select Cutoff_Time from reftable),max(transaction_timestamp)) time_gap
                        , null SiteDetails
                from MD2.dbo.offlinx_transaction ot
                --order by ot.transaction_timestamp desc
                -------------------------------------------------------------------------------  check2 : END -------------------------------------------------------------------------------------------------------------
                union
                ---------------------------------------------------------------------------   check 3: check offlinx_attribution_visit_check --------------------------------------------------------------------------- 
                select  3 check_group, t1.offlinx_site_id check_sub_group, 'Check offlinx_attribution_visit_check' check_name
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),latest_timestamp) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , latest_timestamp, time_gap        
                        , SiteDetails      
                from    (select os.offlinx_site_id, max(visit_timestamp) latest_timestamp, datediff(minute,(select Cutoff_Time from reftable),max(visit_timestamp)) time_gap
                        from    MD2.dbo.offlinx_attribution oa
                                , MD2.dbo.offlinx_visit_trace ovt 
                                , MD2.dbo.offlinx_visit_v2 ov 
                                , (select offlinx_site_id from MD2.dbo.offlinx_site where active='true') os
                        where 1=1 
                        and oa.offlinx_visit_trace_id=ovt.offlinx_visit_trace_id
                        and ovt.offlinx_visit_id=ov.offlinx_visit_id
                        and ov.part_no=(select Partition_ID from reftable)
                        and ov.offlinx_site_id=os.offlinx_site_id 
                        group by os.offlinx_site_id
                        --order by oa.offlinx_attribution_id desc
                        ) t2
                        right outer join (
                        select ta.offlinx_site_id offlinx_site_id
                                , convert(varchar,tc.name)+' (OrgID: '+convert(varchar,tc.org_id)+'; ServiceID: '+convert(varchar,tb.offlinx_service_id)+'; SiteID: '+convert(varchar,ta.offlinx_site_id)+')' SiteDetails
                        from MD2.dbo.offlinx_site ta
                        left outer join MD2.dbo.offlinx_service tb
                        on ta.offlinx_service_id=tb.offlinx_service_id  
                        left outer join MD2.dbo.org tc
                        on tb.org_id=tc.org_id ) t1
                on t1.offlinx_site_id=t2.offlinx_site_id
                -------------------------------------------------------------------------------  check3 : END -------------------------------------------------------------------------------------------------------------
                union        
                ---------------------------------------------------------------------------  check 4: offlinx_tracking_impression_v2_check --------------------------------------------------------------------------- 
                select  4 check_group, t1.offlinx_site_id check_sub_group, 'Offlinx_tracking_impression_v2_check' check_name
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),latest_timestamp) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , latest_timestamp, time_gap        
                        , t1.SiteDetails SiteDetails
                from    (select os.offlinx_site_id , max(oti.impression_timestamp) latest_timestamp, datediff(minute,(select Cutoff_Time from reftable),max(oti.impression_timestamp)) time_gap
                        from    MD2.dbo.offlinx_tracking_impression_v3 oti
                                , (select offlinx_site_id from MD2.dbo.offlinx_site where active='true') os
                        where 1=1
                        and oti.part_no=(select Partition_ID from reftable)
                        and oti.offlinx_site_id=os.offlinx_site_id 
                        group by os.offlinx_site_id 
                        --order by oti.impression_timestamp desc
                        ) t2
                        right outer join 
                        (select ta.offlinx_site_id offlinx_site_id
                                , convert(varchar,tc.name)+' (OrgID: '+convert(varchar,tc.org_id)+'; ServiceID: '+convert(varchar,tb.offlinx_service_id)+'; SiteID: '+convert(varchar,ta.offlinx_site_id)+')' SiteDetails
                        from MD2.dbo.offlinx_site ta
                        left outer join MD2.dbo.offlinx_service tb
                        on ta.offlinx_service_id=tb.offlinx_service_id  
                        left outer join MD2.dbo.org tc
                        on tb.org_id=tc.org_id ) t1
                on t1.offlinx_site_id=t2.offlinx_site_id
                -------------------------------------------------------------------------------  check4 : END -------------------------------------------------------------------------------------------------------------
                union        
                ---------------------------------------------------------------------------  check 5: offlinx_visit_check --------------------------------------------------------------------------- 
                select  5 check_group, t1.offlinx_site_id check_sub_group, 'Offlinx_visit_check' check_no
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),latest_timestamp) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , latest_timestamp, time_gap        
                        ,t1.SiteDetails SiteDetails
                from    (select os.offlinx_site_id, max(visit_timestamp) latest_timestamp, datediff(minute,(select Cutoff_Time from reftable),max(ov.visit_timestamp)) time_gap
                        from    MD2.dbo.offlinx_visit_v2 ov
                                , (select offlinx_site_id from MD2.dbo.offlinx_site where active='true') os
                        where 1=1
                        and ov.part_no=(select Partition_ID from reftable)
                        and ov.offlinx_site_id=os.offlinx_site_id
                        group by os.offlinx_site_id 
                        --order by ov.visit_timestamp desc
                        ) t2
                        right outer join (
                        select ta.offlinx_site_id offlinx_site_id
                                , convert(varchar,tc.name)+' (OrgID: '+convert(varchar,tc.org_id)+'; ServiceID: '+convert(varchar,tb.offlinx_service_id)+'; SiteID: '+convert(varchar,ta.offlinx_site_id)+')' SiteDetails
                        from MD2.dbo.offlinx_site ta
                        left outer join MD2.dbo.offlinx_service tb
                        on ta.offlinx_service_id=tb.offlinx_service_id  
                        left outer join MD2.dbo.org tc
                        on tb.org_id=tc.org_id ) t1
                on t1.offlinx_site_id=t2.offlinx_site_id        
                -------------------------------------------------------------------------------  check5 : END -------------------------------------------------------------------------------------------------------------
                union
                ---------------------------------------------------------------------------  check 6: offlinx_visit_trace_check --------------------------------------------------------------------------- 
                select  6 check_group, t1.offlinx_site_id check_sub_group, 'Offlinx_visit_trace_check' check_no
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),latest_timestamp) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , latest_timestamp, time_gap        
                        , t1.SiteDetails SiteDetails
                from    (select os.offlinx_site_id, max(ov.visit_timestamp) latest_timestamp, datediff(minute,(select Cutoff_Time from reftable),max(ov.visit_timestamp)) time_gap
                        from    MD2.dbo.offlinx_visit_trace ovt
                                , MD2.dbo.offlinx_visit_v2 ov 
                                , (select offlinx_site_id from MD2.dbo.offlinx_site where active='true') os
                        where 1=1
                        and ov.part_no=(select Partition_ID from reftable)        
                        and ovt.offlinx_visit_id=ov.offlinx_visit_id
                        and ov.offlinx_site_id=os.offlinx_site_id 
                        group by os.offlinx_site_id 
                        --order by ov.visit_timestamp desc
                        ) t2
                        right outer join 
                        (select ta.offlinx_site_id offlinx_site_id
                                , convert(varchar,tc.name)+' (OrgID: '+convert(varchar,tc.org_id)+'; ServiceID: '+convert(varchar,tb.offlinx_service_id)+'; SiteID: '+convert(varchar,ta.offlinx_site_id)+')' SiteDetails
                        from MD2.dbo.offlinx_site ta
                        left outer join MD2.dbo.offlinx_service tb
                        on ta.offlinx_service_id=tb.offlinx_service_id  
                        left outer join MD2.dbo.org tc
                        on tb.org_id=tc.org_id ) t1
                on t1.offlinx_site_id=t2.offlinx_site_id     
                -------------------------------------------------------------------------------  check6 : END -------------------------------------------------------------------------------------------------------------
                union
                ---------------------------------------------------------------------------  check 7: transaction_region_1_check --------------------------------------------------------------------------- 
                select  7 check_group, 1 check_sub_group, 'Transaction_region_1_check' check_no
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),max(transaction_timestamp)) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , max(auth.transaction_timestamp) latest_timestamp
                        , datediff(minute,(select Cutoff_Time from reftable),max(auth.transaction_timestamp)) time_gap
                        , null SiteDetails
                from MD2.dbo.authorization_transaction auth
                where auth.authorization_transaction_source_code = 'RB24'
                AND auth.authorization_transaction_source_id LIKE '1%'
                AND auth.part_no = (select Partition_ID from reftable)
                --ORDER BY auth.transaction_timestamp DESC;
                -------------------------------------------------------------------------------  check7 : END -------------------------------------------------------------------------------------------------------------
                union
                ---------------------------------------------------------------------------  check 8: transaction_region_2_check --------------------------------------------------------------------------- 
                select  8 check_group, 1 check_sub_group, 'Transaction_region_2_check' check_no
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),max(transaction_timestamp)) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , max(auth.transaction_timestamp) latest_timestamp
                        , datediff(minute,(select Cutoff_Time from reftable),max(auth.transaction_timestamp)) time_gap
                        , null SiteDetails
                from MD2.dbo.authorization_transaction auth
                where auth.authorization_transaction_source_code = 'RB24'
                AND auth.authorization_transaction_source_id LIKE '2%'
                AND auth.part_no = (select Partition_ID from reftable)
                --ORDER BY auth.transaction_timestamp DESC;
                -------------------------------------------------------------------------------  check8 : END -------------------------------------------------------------------------------------------------------------
                union
                --------------------------------------------------------------------------- check 9: transaction_region_3_check --------------------------------------------------------------------------- 
                select  9 check_group, 1 check_sub_group, 'Transaction_region_3_check' check_no
                        ,(case
                                when datediff(minute,(select Cutoff_Time from reftable),max(transaction_timestamp)) > 0 then 'OK'
                                else 'NOK'
                        end) check_status
                        , max(auth.transaction_timestamp) latest_timestamp
                        , datediff(minute,(select Cutoff_Time from reftable),max(auth.transaction_timestamp)) time_gap
                        , null SiteDetails
                from MD2.dbo.authorization_transaction auth
                where auth.authorization_transaction_source_code = 'RB24'
                AND auth.authorization_transaction_source_id LIKE '3%'
                AND auth.part_no = (select Partition_ID from reftable)
                --ORDER BY auth.transaction_timestamp DESC;
                -------------------------------------------------------------------------------  check9 : END -------------------------------------------------------------------------------------------------------------
        ) tab
        )
        select rt.Partition_ID, dateadd(day,-1,rt.Cutoff_Time) OperationDate, dr.* 
        from detailedreport dr, reftable rt 
        where 'FAILURE'=
                (case 
                        when 
                        (select count(1) from 
                                (select check_group GroupID
                                        , (case 
                                                when sum(case when check_status='OK' then 1 else 0 end)>0 then 'OK'
                                                else 'NOK' 
                                           end) GroupSuccess
                                from detailedreport
                                group by check_group
                                ) tab1
                        where tab1.GroupSuccess='NOK') > 0 then 'FAILURE'
                        else 'SUCCESS'
                 end)
        -------------------------------------------------------  PRE Check SQL : END -------------------------------------------------------
        SET @PendingRecordCount = @@ROWCOUNT
	IF @action = 'forcerun'
	BEGIN
                SET @PendingRecordCount = 0 
        END          
        IF @PendingRecordCount != 0   
        BEGIN         
                PRINT 'OfflinxSummarization.Precheck.NOK. Please try again later.'
        END
        ELSE ---------------- MAIN ELSE START -------------------------------------
        BEGIN
                PRINT 'OfflinxSummarization.Precheck.OK. Proceed for execution step.'                   
                DECLARE @procsequence varchar(2), @procname varchar(100), @procfrequency varchar(10), @OperationDate varchar(10)   
                SET @OperationDate = convert(varchar(10),dateadd(day,-1,@CutoffTime),120)         
                PRINT 'OperationDate: '+@OperationDate    
                DECLARE proccursor CURSOR FOR 
                select * from 
                        (SELECT '1' ChkPoint,'summarize_offlinx_tracking_impression' ChkName,'daily' ChkFreq union 
                        SELECT '2' ChkPoint,'summarize_offlinx_visits' ChkName,'daily' ChkFreq union
                        SELECT '3' ChkPoint,'expand_offlinx_visits' ChkName,'daily' ChkFreq union
                        SELECT '4' ChkPoint,'dbo.summarize_offlinx_revenue' ChkName,'daily' ChkFreq union
                        SELECT '5' ChkPoint,'summarize_offlinx_attributions' ChkName,'daily' ChkFreq union
                        SELECT '6' ChkPoint,'expand_offlinx_attribution' ChkName,'daily' ChkFreq union 
                        SELECT '7' ChkPoint,'calculate_offlinx_ecommerce_revenue_factor' ChkName,'daily' ChkFreq union
                        SELECT '8' ChkPoint,'summarize_offlinx_visit_revenue_6' ChkName,'monthly' ChkFreq) tab
                where tab.ChkPoint >= isnull(convert(varchar,@ExecRestartPoint),'1') 
                OPEN proccursor
                FETCH NEXT FROM proccursor INTO @procsequence, @procname, @procfrequency
                WHILE @@FETCH_STATUS = 0  
                BEGIN  -------- For each checkpoint -- START -----------------
                   BEGIN TRY
                           PRINT 'Start.'+@procsequence+'-'+@procname+'-'+@procfrequency                       
                           IF @procfrequency = 'daily' -------- If checkpoint is daily -- START ----------------
                                   BEGIN
                                        IF @action = 'run' or @action = 'forcerun'
                                        BEGIN 
                                                SET @ThisSql = 'EXEC '+@procname+' '''+@OperationDate+''''
                                                PRINT 'Command to be executed: '+@ThisSql
                                                EXEC (@ThisSql)
                                        END -------- If checkpoint is daily -- END ----------------
                                   END
                           IF @procfrequency = 'monthly'  
                                   BEGIN  -------- If checkpoint is monthly -- START ----------------
                                        -- execute the longest range date first
                                        BEGIN
                                        DECLARE @DayRange int = 30
                                        DECLARE @iteration int = isnull(@RestartSubPoint,0)
                                        DECLARE @FirstStartDate varchar(10) = convert(varchar(10),dateadd(day,-@DayRange,@OperationDate),120) 
                                                PRINT 'Start.DateLookBack='+convert(varchar,@DayRange)                                
                                                PRINT 'DateLookBack:'+convert(varchar,@DayRange)+'== Date:'+@FirstStartDate                                
                                                IF @action = 'run' or @action = 'forcerun'
                                                BEGIN 
                                                        SET @ThisSql = 'EXEC '+@procname+' '''+@FirstStartDate+''','''+@OperationDate+''''  
                                                        PRINT 'Command to be executed: '+@ThisSql
                                                        EXEC (@ThisSql)  
                                                END 
                                                PRINT 'End.DateLookBack='+convert(varchar,@DayRange)
                                        END    
                                        -- execute the rest of the range from least to most                                  
                                        BEGIN
                                        WHILE @iteration <= @DayRange-1  
                                                BEGIN 
                                                DECLARE @StartDate varchar(10) = convert(varchar(10),dateadd(day,-@iteration,@OperationDate),120)    
                                                PRINT 'Start.DateLookBack='+convert(varchar,@iteration)                                        
                                                PRINT 'DateLookBack:'+convert(varchar,@iteration)+'== Date:'+@StartDate                                 
                                                IF @action = 'run' or @action = 'forcerun'
                                                BEGIN
                                                        SET @ThisSql = 'EXEC '+@procname+' '''+@StartDate+''','''+@OperationDate+''''  
                                                        PRINT 'Command to be executed: '+@ThisSql
                                                        EXEC (@ThisSql)   
                                                END                                           
                                                PRINT 'End.DateLookBack='+convert(varchar,@iteration)
                                                SET @iteration += 1
                                                END
                                        END        
                                   END  -------- If checkpoint is monthly -- END ----------------
                           PRINT 'End.'+@procsequence+'-'+@procname+'-'+@procfrequency                           
                           FETCH NEXT FROM proccursor INTO @procsequence, @procname, @procfrequency 
                           DECLARE @localchk int
                           PRINT 'Continue.Next'
                   END TRY
                   BEGIN CATCH
                        PRINT 'Exception.'+@procsequence+'-'+@procname+'-'+@procfrequency+'. Error: '+convert(varchar,@@ERROR)
                        GOTO FailedOutOfExecBlock
                   END CATCH
                END -------- For each checkpoint -- END -----------------   
                GOTO SuccessOutOfExecBlock
                FailedOutOfExecBlock:
                        PRINT 'Exception.OfflinxSummarization.Execution. Error: '+convert(varchar,@@ERROR)
                SuccessOutOfExecBlock: 
                        PRINT 'OfflinxSummarization.Execution.OK. All steps completed successfully.'
                CLOSE proccursor
                DEALLOCATE proccursor
        END ---------------- MAIN ELSE END -------------------------------------     
END TRY
BEGIN CATCH
        PRINT 'Exception.OfflinxSummarization.PreCheck. Error: '+convert(varchar,@@ERROR)
END CATCH
END
