SELECT 
    COLUMN_NAME AS column_name,
    DATA_TYPE AS data_type,
    CHARACTER_MAXIMUM_LENGTH AS max_length,
    IS_NULLABLE AS is_nullable
FROM 
    INFORMATION_SCHEMA.COLUMNS
WHERE 
    TABLE_SCHEMA = 'dbo'
    AND TABLE_NAME = 'sales'
ORDER BY 
    ORDINAL_POSITION;
