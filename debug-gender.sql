-- Kiểm tra giá trị gender hiện tại trong bảng customers
SELECT customer_id, full_name, gender, LENGTH(gender) as gender_length 
FROM customers 
WHERE customer_id = 1; -- Thay bằng ID khách hàng bạn đang test

-- Kiểm tra tất cả giá trị gender unique trong bảng
SELECT DISTINCT gender, COUNT(*) as count
FROM customers 
GROUP BY gender
ORDER BY count DESC;

-- Kiểm tra có ký tự đặc biệt không
SELECT customer_id, full_name, gender, 
       HEX(gender) as gender_hex,
       CHAR_LENGTH(gender) as char_length,
       LENGTH(gender) as byte_length
FROM customers 
WHERE gender IS NOT NULL AND gender != ''
LIMIT 10; 