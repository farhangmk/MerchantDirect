CREATE FUNCTION dbo.part_no_731 (@in_date DATE)
RETURNS INT
WITH SCHEMABINDING
AS 
BEGIN
        DECLARE @part_no INT;
	SET @part_no = DATEPART(dayofyear, @in_date);
	IF (DATEPART(year,@in_date) % 2 = 0)
		SET @part_no += 365;
	RETURN(@part_no);
END;