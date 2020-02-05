CREATE VIEW offlinx_visit_revenue_summary_no_json AS
        SELECT offlinx_site_id, from_date, to_date, offlinx_channel_type_code, offlinx_channel_source_code, offlinx_channel_network_id,offlinx_device_type_desktop, offlinx_device_type_mobile,offlinx_device_type_tablet
                FROM offlinx_visit_revenue_summary;
