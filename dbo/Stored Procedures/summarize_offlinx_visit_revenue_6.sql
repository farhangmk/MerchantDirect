CREATE PROCEDURE summarize_offlinx_visit_revenue_6 @FromDate DATE, @ToDate DATE
AS


-- This temp table expands out attributions completely so the cube generation statement requires no filters
DROP TABLE IF EXISTS #att_expansion;
CREATE TABLE #att_expansion (

        offlinx_site_id BIGINT NOT NULL,
        desktop BIT NOT NULL,
        mobile BIT NOT NULL,
        tablet BIT NOT NULL,
        purchase_method CHAR(1) NOT NULL,
        offlinx_channel_source_code CHAR(4) NOT NULL,
        offlinx_channel_type_code CHAR(4) NOT NULL,
        offlinx_channel_network_id BIGINT,
        moneris_customer_number CHAR(13) NOT NULL,
        province_code CHAR(2) NOT NULL,
        city VARCHAR(30) NOT NULL,
        visitor_id BIGINT NOT NULL,
        offlinx_transaction_id BIGINT NOT NULL,
        attribution_amount BIGINT NOT NULL,
        total_attributions INTEGER NOT NULL,
        force_ecommerce_attribution_to_actual BIT NOT NULL,
        ecommerce_revenue_factor DECIMAL(19,4),
        factor DECIMAL(19,4),
        INDEX offlinx_ovrs_attribution_expanded_1 CLUSTERED (offlinx_site_id, desktop, mobile, tablet, purchase_method, offlinx_channel_source_code, offlinx_channel_type_code, offlinx_channel_network_id, moneris_customer_number, province_code, city)
);

INSERT INTO #att_expansion WITH (TABLOCK) (offlinx_transaction_id, offlinx_site_id, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet, purchase_method, visitor_id, moneris_customer_number, province_code, city, attribution_amount, total_attributions,force_ecommerce_attribution_to_actual,ecommerce_revenue_factor,factor) 
SELECT oae.offlinx_transaction_id, oae.offlinx_site_id, oae.offlinx_channel_type_code, oae.offlinx_channel_source_code, oae.offlinx_channel_network_id, oae.desktop, oae.mobile, oae.tablet, oae.purchase_method, oae.visitor_id, oae.moneris_customer_number, oae.province_code, oae.city, oae.attribution_amount, oae.total_attributions, os.force_ecommerce_attribution_to_actual, oerf.revenue_factor, otvc.factor
FROM offlinx_attribution_expanded oae 
INNER JOIN offlinx_site os ON os.offlinx_site_id = oae.offlinx_site_id
INNER JOIN offlinx_transaction_visit_summary otvc ON oae.offlinx_site_id = otvc.offlinx_site_id AND oae.site_transaction_date = otvc.site_transaction_date AND oae.offlinx_channel_id = otvc.offlinx_channel_id
LEFT JOIN offlinx_ecommerce_revenue_factor oerf ON oae.offlinx_site_id = oerf.offlinx_site_id and oae.site_transaction_date = oerf.site_transaction_date
WHERE oae.site_transaction_date BETWEEN @FromDate and @ToDate AND os.active = 1 AND os.deleted = 0 ;

-- clear inmem staging table and calculate revenue data
DELETE FROM offlinx_ovrs_revenue_staging; 
INSERT INTO offlinx_ovrs_revenue_staging (offlinx_site_id, from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet, revenue)
SELECT
offlinx_site_id,
@FromDate as from_date,
@ToDate as to_date,
COALESCE(offlinx_channel_type_code,'    ') AS offlinx_channel_type_code,
COALESCE(offlinx_channel_source_code,'    ') AS offlinx_channel_source_code,
COALESCE(offlinx_channel_network_id,0) AS offlinx_channel_network_id,
desktop,
mobile,
tablet,
'"' + COALESCE(purchase_method,'') + '#' + COALESCE(city,'') + '#' + COALESCE(province_code,'') + '#' + coalesce(moneris_customer_number,'') + '": ["' 
+ CONVERT(VARCHAR, SUM( CAST((attribution_amount * IIF(purchase_method = 'E', IIF(force_ecommerce_attribution_to_actual = 1,ecommerce_revenue_factor, 1.0) , factor)) AS BIGINT ) )) + '","'
+ CONVERT(VARCHAR, CAST( ROUND( SUM( IIF(purchase_method = 'E', IIF(force_ecommerce_attribution_to_actual = 1, ecommerce_revenue_factor, 1.0) , factor) / total_attributions ) , 0) AS BIGINT) ) + '","'
+ CONVERT(VARCHAR, CAST( CAST(COUNT(DISTINCT visitor_id) AS DECIMAL)  / CAST(COUNT(DISTINCT offlinx_transaction_id) AS DECIMAL)  * ROUND( SUM( IIF(purchase_method = 'E', IIF(force_ecommerce_attribution_to_actual = 1, ecommerce_revenue_factor, 1.0) ,factor) / total_attributions ),0) AS BIGINT)) + '"]'
AS revenue

FROM 
#att_expansion
GROUP BY
offlinx_site_id,
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

DROP TABLE IF EXISTS #att_expansion;

-- same as above, but for visits
DROP TABLE IF EXISTS #visit_expansion;
CREATE TABLE #visit_expansion (

        offlinx_site_id BIGINT NOT NULL,
        desktop BIT NOT NULL,
        mobile BIT NOT NULL,
        tablet BIT NOT NULL,
        offlinx_channel_source_code CHAR(4) NOT NULL,
        offlinx_channel_type_code CHAR(4) NOT NULL,
        offlinx_channel_network_id BIGINT,
        visitor_id BIGINT,
        offlinx_visit_id BIGINT NOT NULL,
        INDEX visit_expansion_1 CLUSTERED (offlinx_site_id, desktop, mobile, tablet, offlinx_channel_source_code, offlinx_channel_type_code, offlinx_channel_network_id)
);

INSERT INTO #visit_expansion WITH (TABLOCK) (offlinx_site_id, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet, visitor_id, offlinx_visit_id)
SELECT ove.offlinx_site_id, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet, visitor_id, offlinx_visit_id
FROM offlinx_visit_expanded ove
INNER JOIN offlinx_site os ON ove.offlinx_site_id = os.offlinx_site_id
WHERE os.active = 1 and os.deleted = 0 AND 
ove.site_visit_date  >= CAST( @FromDate AS DATE) AND ove.site_visit_date < CAST(DATEADD(dd,1,@ToDate) AS DATE) 

-- clear inmem staging table and calculate visit data
DELETE FROM offlinx_ovrs_visit_staging;
INSERT INTO offlinx_ovrs_visit_staging (offlinx_site_id, from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop, mobile, tablet, visits)
SELECT
offlinx_site_id,
@FromDate as from_date,
@ToDate  as to_date,
COALESCE(offlinx_channel_type_code,'    ') AS offlinx_channel_type_code,
COALESCE(offlinx_channel_source_code,'    ') AS offlinx_channel_source_code,
COALESCE(offlinx_channel_network_id,0) AS offlinx_channel_network_id,
desktop,
mobile,
tablet,
'"v": ["' + CONVERT(VARCHAR, COUNT(offlinx_visit_id)) + '","' + CONVERT(VARCHAR, COUNT(distinct visitor_id) + SUM(iif(visitor_id is null, 1, 0))) + '"]' AS visits    -- count nulls

FROM 
#visit_expansion
GROUP BY
offlinx_site_id,
desktop,
mobile,
tablet,
  CUBE(
        offlinx_channel_source_code,
        offlinx_channel_type_code,
        offlinx_channel_network_id)
HAVING offlinx_channel_network_id <> 0 OR GROUPING(offlinx_channel_network_id) = 1 
;

DROP TABLE IF EXISTS #visit_expansion;

INSERT INTO offlinx_visit_revenue_summary (offlinx_site_id, from_date, to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, offlinx_device_type_desktop, offlinx_device_type_mobile, offlinx_device_type_tablet, summary_data)
SELECT keys.offlinx_site_id, keys.from_date, keys.to_date, IIF(keys.offlinx_channel_type_code = '   ', null ,keys.offlinx_channel_type_code) AS offlinx_channel_type_code, 
IIF(keys.offlinx_channel_source_code = '    ', null, keys.offlinx_channel_source_code) AS offlinx_channel_source_code , 
IIF(keys.offlinx_channel_network_id = 0, null, keys.offlinx_channel_network_id) AS offlinx_channel_network_id, keys.desktop,keys.mobile,keys.tablet, 
'{' + COALESCE(v.visits, '"v": ["0","0"]') + IIF(r.rev IS NULL, '}', ', ' + r.rev + '}')  as summary_data
FROM 
(SELECT offlinx_site_id,from_date,to_date, offlinx_channel_type_code,  offlinx_channel_source_code, offlinx_channel_network_id, desktop,mobile,tablet FROM offlinx_ovrs_visit_staging 
 UNION SELECT offlinx_site_id,from_date,to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, desktop,mobile,tablet FROM offlinx_ovrs_revenue_staging ) keys
LEFT JOIN offlinx_ovrs_visit_staging v
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
                        FROM offlinx_ovrs_revenue_staging r2
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
                        ORDER BY offlinx_site_id,from_date,to_date,offlinx_channel_type_code,offlinx_channel_source_code,offlinx_channel_network_id,desktop,mobile,tablet,revenue
                        FOR XML PATH(''), TYPE
                   ).value('.','varchar(max)'),1,1, '') + '}' AS rev from offlinx_ovrs_revenue_staging r1 
  GROUP BY offlinx_site_id,from_date,to_date,offlinx_channel_type_code,offlinx_channel_source_code,offlinx_channel_network_id,desktop,mobile,tablet)
  r
  ON keys.offlinx_site_id = r.offlinx_site_id AND keys.from_date = r.from_date AND keys.to_date = r.to_date AND keys.offlinx_channel_type_code=r.offlinx_channel_type_code 
  AND keys.offlinx_channel_source_code=r.offlinx_channel_source_code AND keys.offlinx_channel_network_id=r.offlinx_channel_network_id AND keys.desktop=r.desktop 
    AND keys.mobile=r.mobile AND keys.tablet=r.tablet;

