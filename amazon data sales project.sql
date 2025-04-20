# Capstone Project Amazon Data Sales.
-- # The AIM of the project - The major aim of this project is to gain insight into the sales data of Amazon to understand the different factors that affect sales of the different branches.
-- Analysis List:-
-- Product Analysis: Conduct analysis on the data to understand the different product lines, the products lines performing best and the product lines that need to be improved.
-- Sales Analysis: This analysis aims to answer the question of the sales trends of product. The result of this can help us measure the effectiveness of each sales strategy the business applies and what modifications are needed to gain more sales.
-- Customer Analysis: This analysis aims to uncover the different customer segments, purchase trends and the profitability of each customer segment.

-- Step 1: Create Database
CREATE DATABASE AmazonSales;
USE AmazonSales;

-- step 2: created a table name amazon

-- Step 3: Feature Engineering
ALTER TABLE Amazon 
ADD COLUMN time_of_day VARCHAR(10);

UPDATE amazon 
SET time_of_day = CASE 
        WHEN HOUR(amazon.time) >= 0 AND HOUR (amazon.Time) < 12 THEN 'Morning'
		WHEN HOUR(amazon.time) >= 12 AND HOUR (amazon.Time) < 18 THEN 'Afternoon'
        ELSE 'Evening'
    END;


ALTER TABLE Amazon
ADD COLUMN day_name VARCHAR(10);

UPDATE Amazon 
SET day_name = date_format(amazon.date,'%a');


ALTER TABLE Amazon
ADD COLUMN month_name VARCHAR(10); 

UPDATE Amazon 
SET monthname = date_format(amazon.date, '%b');

-- Business Questions --

-- 1Q. What is the count of distinct cities in the dataset?
SELECT COUNT(DISTINCT city) AS distinct_cities FROM Amazon;
-- output: The Distinct number of cites from database is 3

-- 2Q.For each branch, what is the corresponding city?
SELECT DISTINCT branch, city FROM Amazon;
/*output: for branch A, The City is Yangon, for branch B, The City is Naypytaw,
for branch , The City is Mandalay, */

-- 3Q. What is the count of distinct product lines in the dataset?
SELECT COUNT(DISTINCT 'product_line') AS distinct_product_lines FROM Amazon;
-- Output: The Number of distinct product lines is 1 --

-- 4Q. Which payment method occurs most frequently?
SELECT payment, count(Payment) from amazon group by payment;
-- Output: Ewallet payment method tend to occur most frequently as it is highest in count that is 345

-- 5Q. Which product line has the highest sales?
SELECT 'product line', count('Invoice ID') AS sales_count
FROM Amazon GROUP BY 'product line' ORDER BY sales_count DESC;
/* Output: The Highest sales in product line in sales count is 1000*/

-- 6Q. How much revenue is generated each month?
SELECT month_name, SUM(total) AS revenue FROM amazon
GROUP BY month_name ORDER BY revenue DESC;
-- Output: highest revenu generated as '322966.74900000007'.

-- 7Q. In which month did the cost of goods sold reach its peak?
SELECT month_name, SUM(cogs) AS total_cogs FROM Amazon GROUP BY month_name
ORDER BY total_cogs DESC;
-- Output: the total cogs are sold 307587.38000000035.

-- 8Q. Which product line generated the highest revenue?
SELECT 'product line', SUM(total) AS revenue
FROM Amazon
GROUP BY 'product_line'
ORDER BY revenue DESC;
-- Output: Total Revenue is 322966.74900000007.

-- 9Q. In which city was the highest revenue recorded?
SELECT city, SUM(total) AS revenue FROM Amazon
GROUP BY city ORDER BY revenue DESC;
-- output: the highest revenue recorded in city 'Naypyitaw'= 110568.70649999994.

-- 10. Which product line incurred the highest Value Added Tax?
SELECT 'product line', SUM('Tax 5%') AS Total_Vat FROM Amazon
GROUP BY 'product line' ORDER BY Total_Vat DESC;
-- output: the  highest Value Added Tax is '0'.

-- 11Q. For each product line, add a column indicating "Good" if its sales are above average, otherwise "Bad."
SELECT 'product line', 
sum(Quantity*'Unit price') as Total_Revenue,
CASE 
    when sum(Quantity*'Unit price') < (SELECT AVG(Quantity*'Unit price') FROM Amazon) THEN 'Bad'
    ELSE 'Good'
END AS Kind_Of_Sales
from amazon group by 'Product line' order by Total_revenue DESC;
-- output: The product line is total revenue nos showing 0 and kind of sales is showing good. 

-- 12Q. Identify the branch that exceeded the average number of products sold.
SELECT branch, SUM(quantity) AS total_quantity
FROM Amazon
GROUP BY branch
HAVING SUM(quantity) > (SELECT AVG(quantity) FROM Amazon);
-- output: The branch of the A,B,C are shown  the avg quantity is 1859.

-- 13. Which product line is most frequently associated with each gender?
SELECT gender, product_line, COUNT(*) AS count
FROM Amazon
GROUP BY gender, product_line
ORDER BY gender, count DESC;

-- 14Q. Calculate the average rating for each product line.
SELECT 'product line', AVG(rating) AS avg_rating
FROM Amazon
GROUP BY 'product line';
-- output: the avg rating is 6.972700000000003. 

-- 15Q. Count the sales occurrences for each time of day on every weekday.
SELECT dayname, timeofday, COUNT('Invoice ID') AS sales_Occurance
FROM amazon
GROUP BY dayname, timeofday;

-- 16. Identify the customer type contributing the highest revenue.
SELECT 'customer type', SUM(total) AS total_revenue
FROM amazon
GROUP BY 'customer type';
-- Output:  the customer type contributing the highest revenue is 322966.74900000007. 

-- 17. Determine the city with the highest VAT percentage.
SELECT city, (SUM(VAT) / SUM(total)) * 100 AS vat_percentage
FROM Amazon
GROUP BY city
ORDER BY vat_percentage DESC
LIMIT 1;

-- 18.Identify the customer type with the highest VAT payments
SELECT customer_type, SUM(VAT) AS total_VAT
FROM Amazon
GROUP BY customer_type
ORDER BY total_VAT DESC
LIMIT 1;

-- 19. What is the count of distinct customer types in the dataset?
SELECT COUNT(DISTINCT customer_type) FROM Amazon;

-- 20.What is the count of distinct payment methods in the dataset?
SELECT COUNT(DISTINCT payment) as Distinct_payment_method FROM amazon;
-- Output: the distinct payment method is 3

-- 21.Which customer type occurs most frequently?
SELECT 'customer type', COUNT(*) AS count
FROM Amazon GROUP BY 'customer type';
-- Output: the coustomer is highest frequency has 1ooo. 

-- 22.Identify the customer type with the highest purchase frequency.
SELECT 'customer type', COUNT(Quantity) AS purchase_frequency
FROM amazon GROUP BY 'customer type';
-- Output: the coustomer is highest purchase frequency has 1ooo. 

-- 23. Determine the predominant gender among customers.
SELECT gender, COUNT('invoice id') AS count FROM Amazon
GROUP BY gender ORDER BY count DESC; 
-- Output: the genger male ,female is the highest cont is female = 501.

-- 24Q.Examine the distribution of genders within each branch.
SELECT branch, gender, COUNT(*) AS count
FROM Amazon
GROUP BY branch, gender
ORDER BY branch, count DESC;
-- output: the branch A,B,C are showing with genders are highest count is 179. 

-- 25.Identify the time of day when customers provide the most ratings.
SELECT timeofday, COUNT(rating) AS rating_count
FROM amazon GROUP BY timeofday;

-- 26. Determine the time of day with the highest customer ratings for each branch.
SELECT branch, timeofday, AVG(rating) AS avg_rating
FROM Amazon
GROUP BY branch, timeofday
ORDER BY branch, avg_rating DESC;

-- 27. Identify the day of the week with the highest average ratings.
SELECT dayname, AVG(rating) AS avg_rating
FROM Amazon
GROUP BY dayname
ORDER BY avg_rating DESC;

-- 28. Determine the day of the week with the highest average ratings for each branch.
SELECT branch, dayname, AVG(rating) AS avg_rating
FROM Amazon GROUP BY branch, dayname;












