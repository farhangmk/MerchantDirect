CREATE PROCEDURE summarize_offlinx_visit_revenue_5_temp @FromDate DATE, @ToDate DATE
AS

DROP TABLE IF EXISTS #revenue;
CREATE TABLE #revenue (
offlinx_site_id BIGINT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
offlinx_channel_type_code CHAR(4) NOT NULL,
offlinx_channel_source_code CHAR(4) NOT NULL,
offlinx_channel_network_id BIGINT NOT NULL,
desktop BIT NOT NULL,
mobile BIT NOT NULL,
tablet BIT NOT NULL,
revenue VARCHAR(MAX) NOT NULL,
INDEX revtmp1 CLUSTERED (offlinx_site_id, from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet)
);

INSERT INTO #revenue WITH (TABLOCK) (offlinx_site_id, from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet, revenue)
SELECT
oae.offlinx_site_id,
@FromDate as from_date,
@ToDate as to_date,
COALESCE(offlinx_channel_type_code,'    ') AS offlinx_channel_type_code,
COALESCE(offlinx_channel_source_code,'    ') AS offlinx_channel_source_code,
COALESCE(offlinx_channel_network_id,0) AS offlinx_channel_network_id,
desktop,
mobile,
tablet,
'"' + COALESCE(purchase_method,'') + '#' + COALESCE(city,'') + '#' + COALESCE(province_code,'') + '#' + coalesce(moneris_customer_number,'') + '": ["' 
+ CONVERT(VARCHAR, SUM( CAST((attribution_amount * IIF(purchase_method = 'E', IIF(os.force_ecommerce_attribution_to_actual = 1, oerf.revenue_factor, 1.0) , otvc.factor)) AS BIGINT ) )) + '","'
+ CONVERT(VARCHAR, CAST( ROUND( SUM( IIF(purchase_method = 'E', IIF(os.force_ecommerce_attribution_to_actual = 1, oerf.revenue_factor, 1.0) , otvc.factor) / total_attributions ) , 0) AS BIGINT) ) + '","'
+ CONVERT(VARCHAR, CAST( CAST(COUNT(DISTINCT visitor_id) AS DECIMAL) / CAST(COUNT(DISTINCT oae.offlinx_transaction_id) AS DECIMAL) * ROUND( SUM( IIF(purchase_method = 'E', IIF(os.force_ecommerce_attribution_to_actual = 1, oerf.revenue_factor, 1.0) , otvc.factor) / total_attributions ),0) AS BIGINT)) + '"]'
AS revenue

FROM 
offlinx_site os
INNER JOIN offlinx_attribution_expanded oae ON os.offlinx_site_id = oae.offlinx_site_id
INNER JOIN offlinx_transaction_visit_summary otvc ON  oae.offlinx_site_id = otvc.offlinx_site_id AND oae.site_transaction_date = otvc.site_transaction_date AND oae.offlinx_channel_id = otvc.offlinx_channel_id
LEFT JOIN offlinx_ecommerce_revenue_factor oerf ON oae.offlinx_site_id = oerf.offlinx_site_id and oae.site_transaction_date = oerf.site_transaction_date
WHERE os.active = 1 AND os.deleted = 0 
AND oae.site_transaction_date BETWEEN @FromDate AND @ToDate
GROUP BY
oae.offlinx_site_id,
desktop,
mobile,
tablet,
CUBE(   purchase_method,
        offlinx_channel_source_code,
        offlinx_channel_type_code,
        offlinx_channel_network_id),
GROUPING SETS (
        (moneris_customer_number),
        
        (city,province_code),(province_code),())
    
HAVING offlinx_channel_network_id <> 0 OR GROUPING(offlinx_channel_network_id) = 1;


-- VISITS
DROP TABLE IF EXISTS #visits;
CREATE TABLE #visits (
offlinx_site_id BIGINT NOT NULL,
from_date DATE NOT NULL,
to_date DATE NOT NULL,
offlinx_channel_type_code CHAR(4) NOT NULL,
offlinx_channel_source_code CHAR(4) NOT NULL,
offlinx_channel_network_id BIGINT NOT NULL,
desktop BIT NOT NULL,
mobile BIT NOT NULL,
tablet BIT NOT NULL,
visits VARCHAR(MAX) NOT NULL,
INDEX vistemp CLUSTERED (offlinx_site_id, from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet)
);
INSERT INTO #visits WITH (TABLOCK) (offlinx_site_id, from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet, visits)
SELECT
ove.offlinx_site_id,
@FromDate as from_date,
@ToDate  as to_date,
COALESCE(ove.offlinx_channel_type_code,'    ') AS offlinx_channel_type_code,
COALESCE(ove.offlinx_channel_source_code,'    ') AS offlinx_channel_source_code,
COALESCE(ove.offlinx_channel_network_id,0) AS offlinx_channel_network_id,
ove.desktop,
ove.mobile,
ove.tablet,
'"v": ["' + CONVERT(VARCHAR, COUNT(offlinx_visit_id)) + '","' + CONVERT(VARCHAR, COUNT(distinct visitor_id) + SUM(iif(visitor_id is null, 1, 0))) + '"]' AS visits    -- count nulls

FROM 
offlinx_visit_expanded ove
INNER JOIN offlinx_site os ON ove.offlinx_site_id = os.offlinx_site_id
WHERE os.active = 1 and os.deleted = 0 AND 
ove.site_visit_date  >= CAST( @FromDate AS DATE) AND ove.site_visit_date < CAST(DATEADD(dd,1,@ToDate) AS DATE) 
GROUP BY
ove.offlinx_site_id,
ove.desktop,
ove.mobile,
ove.tablet,
  CUBE(
        ove.offlinx_channel_source_code,
        ove.offlinx_channel_type_code,
        ove.offlinx_channel_network_id)
HAVING ove.offlinx_channel_network_id <> 0 OR GROUPING(ove.offlinx_channel_network_id) = 1 
;


INSERT INTO #ovrs_temp (offlinx_site_id, from_date, to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, offlinx_device_type_desktop, offlinx_device_type_mobile, offlinx_device_type_tablet, summary_data)
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
                        ORDER BY r2.revenue
                        FOR XML PATH(''), TYPE
                   ).value('.','varchar(max)'),1,1, '') + '}' AS rev from #revenue r1 
  GROUP BY offlinx_site_id,from_date,to_date,offlinx_channel_type_code,offlinx_channel_source_code,offlinx_channel_network_id,desktop,mobile,tablet)
  r
  ON keys.offlinx_site_id = r.offlinx_site_id AND keys.from_date = r.from_date AND keys.to_date = r.to_date AND keys.offlinx_channel_type_code=r.offlinx_channel_type_code 
  AND keys.offlinx_channel_source_code=r.offlinx_channel_source_code AND keys.offlinx_channel_network_id=r.offlinx_channel_network_id AND keys.desktop=r.desktop 
    AND keys.mobile=r.mobile AND keys.tablet=r.tablet;

DROP TABLE #revenue;
DROP TABLE #visits;

