CREATE VIEW segment_membership WITH SCHEMABINDING AS (
SELECT a.moneris_customer_number, b.segment_id, b.segment_customer_hierarchy_id
FROM dbo.acquirer_customer a
INNER JOIN dbo.segment_customer_hierarchy b
ON (a.inst_id = b.inst_id AND a.essentis_cust_no = b.essentis_cust_no)
OR (a.inst_id = b.inst_id AND a.essentis_parnt_1 = b.essentis_cust_no AND a.hier_lvl = 2)
OR (a.inst_id = b.inst_id AND a.essentis_parnt_2 = b.essentis_cust_no AND a.hier_lvl = 3)
);
GO
CREATE UNIQUE CLUSTERED INDEX [segment_membership_mon_cust]
    ON [dbo].[segment_membership]([moneris_customer_number] ASC, [segment_id] ASC, [segment_customer_hierarchy_id] ASC);


GO
CREATE NONCLUSTERED INDEX [segment_membership_segment]
    ON [dbo].[segment_membership]([segment_id] ASC, [moneris_customer_number] ASC);

