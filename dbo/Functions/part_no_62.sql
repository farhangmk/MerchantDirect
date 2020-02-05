CREATE FUNCTION dbo.part_no_62 (@in_date DATE)
RETURNS INT
WITH SCHEMABINDING
AS 
BEGIN
        DECLARE @part_no INT;
	SET @part_no = DATEPART(day, @in_date);
	IF (DATEPART(month,@in_date) % 2 = 0)
		SET @part_no += 31;
	RETURN(@part_no);
END;