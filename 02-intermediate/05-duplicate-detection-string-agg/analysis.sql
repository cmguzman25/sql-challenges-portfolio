/*
    Project: Duplicate Detection & String Aggregation
    Description: Identifies duplicate emails and lists their associated IDs
                 using STRING_AGG to facilitate data cleaning.
*/



SELECT 
    email,
    COUNT(*) AS total_duplicates,
    -- STRING_AGG requires the input to be text.
    -- We cast user_id (int) to text and order them for readability.
    STRING_AGG(user_id::TEXT, ', ' ORDER BY user_id ASC) AS id_list
FROM beta_users
GROUP BY email
-- HAVING is used to filter AFTER aggregation.
-- We only want emails that appear more than once.
HAVING COUNT(*) > 1;