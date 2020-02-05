CREATE PROCEDURE summarize_offlinx_visit_revenue @FromDate DATE, @ToDate DATE
AS
DECLARE @DeviceTypeCombos TABLE (
offlinx_device_type_code CHAR(4) NOT NULL,
desktop BIT NOT NULL,
mobile BIT NOT NULL,
tablet BIT NOT NULL);
INSERT INTO @DeviceTypeCombos VALUES
('DSTP',1,0,0),
('DSTP',1,1,0),
('DSTP',1,0,1),
('DSTP',1,1,1),
('MOBL',0,1,0),
('MOBL',0,1,1),
('MOBL',1,1,0),
('MOBL',1,1,1),
('TBLT',1,0,1),
('TBLT',1,1,1),
('TBLT',0,0,1),
('TBLT',0,1,1);
SELECT
ot.offlinx_site_id,
@FromDate as from_date,
@ToDate as to_date,
COALESCE(ocst.offlinx_channel_type_code,'    ') AS offlinx_channel_type_code,
COALESCE(ocst.offlinx_channel_source_code,'    ') AS offlinx_channel_source_code,
COALESCE(oc.offlinx_channel_network_id,0) AS offlinx_channel_network_id,
dtc.desktop,
dtc.mobile,
dtc.tablet,
'"' + COALESCE(IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 'E', 'S'),'') + '#' + COALESCE(act.city,'') + '#' + COALESCE(act.province_code,'') + '#' + coalesce(at.moneris_customer_number,'') + '": ["' 
+ CONVERT(VARCHAR, SUM( CAST((at.transaction_amount / total_attributions * IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 1, otvc.factor)) AS INTEGER ) )) + '","'
+ CONVERT(VARCHAR, CAST( ROUND(COUNT(1) * AVG( IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 1, otvc.factor) ), 0) AS INTEGER) ) + '","'
+ CONVERT(VARCHAR, CAST( ROUND((COUNT(DISTINCT ocm.visitor_id) + SUM(iif(visitor_id is null, 1, 0))) * AVG( IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 1, otvc.factor) ),0) AS INTEGER)) + '"]'
AS revenue

INTO #revenue
FROM 
offlinx_attribution oa 
INNER JOIN offlinx_transaction ot ON oa.offlinx_transaction_id = ot.offlinx_transaction_id    
INNER JOIN offlinx_transaction_attribution_summary otas ON ot.offlinx_transaction_id = otas.offlinx_transaction_id
INNER JOIN authorization_transaction at ON ot.authorization_transaction_source_code = at.authorization_transaction_source_code AND ot.authorization_transaction_source_id = at.authorization_transaction_source_id
INNER JOIN offlinx_visit_trace ovt ON oa.offlinx_visit_trace_id = ovt.offlinx_visit_trace_id
INNER JOIN offlinx_visit ov ON ovt.offlinx_visit_id = ov.offlinx_visit_id
INNER JOIN offlinx_site os ON ov.offlinx_site_id = os.offlinx_site_id
INNER JOIN @DeviceTypeCombos dtc ON ov.offlinx_device_type_code = dtc.offlinx_device_type_code
INNER JOIN offlinx_transaction_visit_summary otvc ON  ot.offlinx_site_id = otvc.offlinx_site_id AND ot.site_transaction_date = otvc.site_transaction_date AND ov.offlinx_channel_id = otvc.offlinx_channel_id
INNER JOIN offlinx_card_match ocm ON ov.browser_id = ocm.browser_id AND ovt.icf = ocm.icf
INNER JOIN offlinx_channel oc ON ov.offlinx_channel_id=oc.offlinx_channel_id

INNER JOIN offlinx_channel_source_type ocst ON oc.offlinx_channel_source_type_code = ocst.offlinx_channel_source_type_code
INNER JOIN acquirer_customer acu ON at.moneris_customer_number = acu.moneris_customer_number
INNER JOIN acquirer_contact act ON acu.location_contact_id = act.contact_id AND acu.inst_id = act.inst_id
WHERE os.active = 1 and os.deleted = 0 AND ot.site_transaction_date BETWEEN @FromDate AND @ToDate
GROUP BY
ot.offlinx_site_id,
dtc.desktop,
dtc.mobile,
dtc.tablet,
GROUPING SETS (
        (at.moneris_customer_number,
       CUBE(
        IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 'E', 'S'),
        ocst.offlinx_channel_source_code,
        ocst.offlinx_channel_type_code,
        oc.offlinx_channel_network_id)),
        
        (act.city,act.province_code,
       CUBE(

        IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 'E', 'S'),
        ocst.offlinx_channel_source_code,
        ocst.offlinx_channel_type_code,
        oc.offlinx_channel_network_id)) ,
        (act.province_code,
       CUBE(
       IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 'E', 'S'),
        ocst.offlinx_channel_source_code,
        ocst.offlinx_channel_type_code,
        oc.offlinx_channel_network_id)),
       (
        CUBE(
        IIF(at.electronic_commerce_indicator IN('5','6','7','8','9'), 'E', 'S'),
        ocst.offlinx_channel_source_code,
        ocst.offlinx_channel_type_code,
        oc.offlinx_channel_network_id))
        )    
HAVING oc.offlinx_channel_network_id <> 0 OR GROUPING(oc.offlinx_channel_network_id) = 1   
;

-- VISITS
SELECT
os.offlinx_site_id,
@FromDate as from_date,
@ToDate as to_date,
COALESCE(ocst.offlinx_channel_type_code,'    ') AS offlinx_channel_type_code,
COALESCE(ocst.offlinx_channel_source_code,'    ') AS offlinx_channel_source_code,
COALESCE(oc.offlinx_channel_network_id,0) AS offlinx_channel_network_id,
dtc.desktop,
dtc.mobile,
dtc.tablet,
'"v": ["' + CONVERT(VARCHAR, COUNT(distinct offlinx_visit_id)) + '","' + CONVERT(VARCHAR, COUNT(distinct visitor_id) + SUM(iif(visitor_id is null, 1, 0))) + '"]' AS visits    -- count nulls
INTO #visits
FROM 
offlinx_site os
INNER JOIN offlinx_visit ov ON os.offlinx_site_id = ov.offlinx_site_id
LEFT JOIN offlinx_card_match ocm ON ov.browser_id = ocm.browser_id AND ocm.icf = (SELECT TOP 1 icf FROM offlinx_card_match ocm2 WHERE ov.browser_id = ocm2.browser_id)
INNER JOIN @DeviceTypeCombos dtc ON ov.offlinx_device_type_code = dtc.offlinx_device_type_code
INNER JOIN offlinx_channel oc ON ov.offlinx_channel_id=oc.offlinx_channel_id
INNER JOIN offlinx_channel_source_type ocst ON oc.offlinx_channel_source_type_code = ocst.offlinx_channel_source_type_code
WHERE os.active = 1 and os.deleted = 0 AND ov.visit_timestamp >= CAST( @FromDate AS DATETIME2) AND ov.visit_timestamp < CAST(DATEADD(dd,1,@ToDate) AS DATETIME2)
GROUP BY
os.offlinx_site_id,
dtc.desktop,
dtc.mobile,
dtc.tablet,
  CUBE(
        ocst.offlinx_channel_source_code,
        ocst.offlinx_channel_type_code,
        oc.offlinx_channel_network_id)
HAVING oc.offlinx_channel_network_id <> 0 OR GROUPING(oc.offlinx_channel_network_id) = 1 
;

INSERT INTO offlinx_visit_revenue_summary (offlinx_site_id, from_date, to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, offlinx_device_type_desktop, offlinx_device_type_mobile, offlinx_device_type_tablet, summary_data)
SELECT keys.offlinx_site_id, keys.from_date, keys.to_date, IIF(keys.offlinx_channel_type_code = '   ', null ,keys.offlinx_channel_type_code) AS offlinx_channel_type_code, 
IIF(keys.offlinx_channel_source_code = '    ', null, keys.offlinx_channel_source_code) AS offlinx_channel_source_code , 
IIF(keys.offlinx_channel_network_id = 0, null, keys.offlinx_channel_network_id) AS offlinx_channel_network_id, keys.desktop,keys.mobile,keys.tablet, 
'{' + COALESCE(v.visits, '"v": ["0","0"]') + IIF(r.rev IS NULL, '}', ', ' + r.rev + '}')  as summary_data
FROM 
(SELECT offlinx_site_id,from_date,to_date, offlinx_channel_type_code,  offlinx_channel_source_code, offlinx_channel_network_id, desktop,mobile,tablet FROM #visits
 UNION SELECT offlinx_site_id,from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop,mobile,tablet FROM #revenue) keys
LEFT JOIN #visits v
  ON keys.offlinx_site_id = v.offlinx_site_id AND keys.from_date = v.from_date AND keys.to_date = v.to_date AND keys.offlinx_channel_type_code = v.offlinx_channel_type_code
  AND keys.offlinx_channel_source_code = v.offlinx_channel_source_code AND keys.offlinx_channel_network_id = v.offlinx_channel_network_id AND keys.desktop = v.desktop
  AND keys.mobile = v.mobile AND keys.tablet = v.tablet
LEFT JOIN (
 SELECT offlinx_site_id,from_date,to_date,
        offlinx_channel_type_code,    
        offlinx_channel_source_code,
        offlinx_channel_network_id,
        desktop,mobile,tablet, '"r": {' + 
        STUFF((SELECT ',' + r2.revenue
                        FROM #revenue r2
                        WHERE 
                        r1.offlinx_site_id=r2.offlinx_site_id AND 
                        r1.from_date=r2.from_date AND 
                        r1.to_date=r2.to_date AND 
                        r1.offlinx_channel_type_code=r2.offlinx_channel_type_code AND 
                        r1.offlinx_channel_source_code=r2.offlinx_channel_source_code AND 
                        r1.offlinx_channel_network_id=r2.offlinx_channel_network_id AND 
                        r1.desktop=r2.desktop AND 
                        r1.mobile=r2.mobile AND 
                        r1.tablet=r2.tablet
                        --ORDER BY offlinx_site_id,from_date,to_date,offlinx_channel_type_code,offlinx_channel_source_code,offlinx_channel_network_id,desktop,mobile,tablet
                        FOR XML PATH(''), TYPE
                   ).value('.','varchar(max)'),1,1, '') + '}' AS rev from #revenue r1 
  GROUP BY offlinx_site_id,from_date,to_date,offlinx_channel_type_code,offlinx_channel_source_code,offlinx_channel_network_id,desktop,mobile,tablet)
  r
  ON keys.offlinx_site_id = r.offlinx_site_id AND keys.from_date = r.from_date AND keys.to_date = r.to_date AND keys.offlinx_channel_type_code=r.offlinx_channel_type_code 
  AND keys.offlinx_channel_source_code=r.offlinx_channel_source_code AND keys.offlinx_channel_network_id=r.offlinx_channel_network_id AND keys.desktop=r.desktop 
    AND keys.mobile=r.mobile AND keys.tablet=r.tablet;

DROP TABLE #revenue;
DROP TABLE #visits;
