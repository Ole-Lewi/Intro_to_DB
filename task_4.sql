SELECT COLUMN NAME, COLUMN_TYPE, IS_NULLABLE, COLUMN_KEY, COLUMN_DEFAULT,EXTRA
FROM INFORMATIOM.SCHEMA.COLUMNS
WHERE TABLE_SCHEMA = DATABASE()
AND TABLE NAME = 'books';