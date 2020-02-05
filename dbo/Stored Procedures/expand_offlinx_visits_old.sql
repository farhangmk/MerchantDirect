CREATE PROCEDURE "dbo"."expand_offlinx_visits_old" @SiteVisitDate DATE
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

INSERT INTO offlinx_visit_expanded WITH (TABLOCK) (site_visit_date, offlinx_visit_id, offlinx_site_id,  offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id, offlinx_device_type_code, desktop, mobile, tablet, visitor_id)
SELECT
@SiteVisitDate AS site_visit_date,
ov.offlinx_visit_id,
ov.offlinx_site_id,
ocst.offlinx_channel_type_code,
ocst.offlinx_channel_source_code,
COALESCE(oc.offlinx_channel_network_id,0) AS offlinx_channel_network_id,
ov.offlinx_device_type_code,
dtc.desktop,
dtc.mobile,
dtc.tablet,
visitor_id
FROM 
offlinx_visit ov INNER JOIN offlinx_site os  ON os.offlinx_site_id = ov.offlinx_site_id
LEFT JOIN offlinx_card_match ocm ON ov.browser_id = ocm.browser_id AND ocm.icf = (SELECT TOP 1 icf FROM offlinx_card_match ocm2 WHERE ov.browser_id = ocm2.browser_id)
INNER JOIN @DeviceTypeCombos dtc ON ov.offlinx_device_type_code = dtc.offlinx_device_type_code
INNER JOIN offlinx_channel oc ON ov.offlinx_channel_id=oc.offlinx_channel_id
INNER JOIN offlinx_channel_source_type ocst ON oc.offlinx_channel_source_type_code = ocst.offlinx_channel_source_type_code
WHERE os.active = 1 and os.deleted = 0 AND ov.visit_timestamp >= CAST( @SiteVisitDate AS DATETIME2) AND ov.visit_timestamp < CAST(DATEADD(dd,1,@SiteVisitDate) AS DATETIME2);  --timezone needs to be factored in her