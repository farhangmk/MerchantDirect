CREATE PROCEDURE expand_offlinx_attribution @SiteTransactionDate DATE
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
INSERT INTO offlinx_attribution_expanded (
        offlinx_attribution_id, offlinx_transaction_id, offlinx_site_id,
        site_transaction_date ,
        offlinx_channel_id,
        offlinx_channel_type_code,
        offlinx_channel_source_code,
        offlinx_channel_network_id,
        offlinx_device_type_code,
        desktop,
        mobile,
        tablet,
        purchase_method ,
        visitor_id,
        moneris_customer_number ,
        province_code ,
        city ,
        attribution_amount,
        total_attributions )
SELECT
oa.offlinx_attribution_id,
oa.offlinx_transaction_id,
ot.offlinx_site_id,
ot.site_transaction_date,
ov. offlinx_channel_id,
ocst.offlinx_channel_type_code,
ocst.offlinx_channel_source_code,
oc.offlinx_channel_network_id,
ov.offlinx_device_type_code,
dtc.desktop,
dtc.mobile,
dtc.tablet,
IIF(COALESCE(at.electronic_commerce_indicator,'') IN('5','6','7','8','9'), 'E', 'S'),
ocm.visitor_id,
at.moneris_customer_number,
act.province_code,
act.city,
at.transaction_amount / total_attributions AS attribution_amount,
total_attributions
FROM 
offlinx_site os
INNER JOIN offlinx_transaction ot on os.offlinx_site_id = ot.offlinx_site_id
INNER JOIN offlinx_transaction_attribution_summary otas ON ot.offlinx_transaction_id = otas.offlinx_transaction_id
INNER JOIN authorization_transaction at ON ot.authorization_transaction_source_code = at.authorization_transaction_source_code AND ot.authorization_transaction_source_id = at.authorization_transaction_source_id
INNER JOIN offlinx_attribution oa ON ot.offlinx_transaction_id = oa.offlinx_transaction_id  
INNER JOIN offlinx_visit_trace ovt ON oa.offlinx_visit_trace_id = ovt.offlinx_visit_trace_id
INNER JOIN offlinx_visit_v2 ov ON ovt.offlinx_visit_id = ov.offlinx_visit_id
INNER JOIN @DeviceTypeCombos dtc ON ov.offlinx_device_type_code = dtc.offlinx_device_type_code
INNER JOIN offlinx_card_match ocm ON ov.browser_id = ocm.browser_id AND ovt.icf = ocm.icf
INNER JOIN offlinx_channel oc ON ov.offlinx_channel_id=oc.offlinx_channel_id
INNER JOIN offlinx_channel_source_type ocst ON oc.offlinx_channel_source_type_code = ocst.offlinx_channel_source_type_code
INNER JOIN acquirer_customer acu ON at.moneris_customer_number = acu.moneris_customer_number
INNER JOIN acquirer_contact act ON acu.location_contact_id = act.contact_id AND acu.inst_id = act.inst_id
WHERE os.active = 1 and os.deleted = 0 AND ot.site_transaction_date = @SiteTransactionDate;

