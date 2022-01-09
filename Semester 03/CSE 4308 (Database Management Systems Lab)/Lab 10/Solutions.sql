--Task 1
/*
Write a function that takes a year as input and returns the total number of items shipped in that year.
*/

CREATE OR REPLACE FUNCTION total_items_shipped(in_year INT)
RETURN NUMBER
IS

item_count NUMBER := 0;

BEGIN

SELECT COUNT(*) INTO item_count
FROM ORDERS, ORDER_ITEMS
WHERE ORDERS.ORDER_ID = ORDER_ITEMS.ORDER_ID AND STATUS = 1; 

-- return the required count
RETURN item_count;

END;
/


--Task 2
/*
Write a function that takes a year as input and returns the item that has been shipped most that year.
*/

CREATE OR REPLACE FUNCTION most_sold_item(in_year INT)
RETURN NUMBER
IS

required_item NUMBER := 0;

BEGIN

SELECT Item_ID INTO required_item
FROM 
(SELECT Item_ID, SUM(Quantity) as Total FROM ORDERS, ORDER_ITEMS WHERE ORDERS.Order_ID = ORDER_ITEMS.Order_ID AND Status = 1 AND Order_Year = in_year GROUP BY Item_ID ORDER BY Total DESC)
WHERE rownum = 1;

-- return the required item
RETURN required_item;

END;
/

--Task 3
/*
Write a function called profit_estimation. This function will take a year as input. It will calculate the total revenue generated by the sale of shipped items that year. It will also calculate the total revenue lost due to unshipped items.
1. If the revenue generated is between 50% and 65% of the summation of revenue generated and revenue lost, then the function should print
"Average Year"
2. If the revenue generated is between 66% and 79% of the summation of revenue generated and revenue lost, then the function should print
"Good Year"
3. If the revenue generated is greater than 79% of the summation of revenue generated and revenue lost, then the function should print
"Excellent Year"
4. If the revenue generated is less than 50% of the summation of revenue generated and revenue lost, then the function should print
"A year of losses"
5. Finally, as the return value, your function should return the total revenue generated by the sale of shipped items.
*/

CREATE OR REPLACE FUNCTION profit_estimation(in_year INT)
RETURN NUMBER
IS

revenue_generated NUMBER := 0;
revenue_lost NUMBER := 0;
total NUMBER := 0;
percentage NUMBER := 0;

BEGIN

SELECT SUM(Quantity * PPU)
INTO revenue_generated 
FROM Orders, Order_Items
WHERE Orders.Order_ID = Order_Items.Order_ID AND Order_Year = in_year AND status = 1;

SELECT SUM(Quantity * PPU)
INTO revenue_lost 
FROM Orders, Order_Items
WHERE Orders.Order_ID = Order_Items.Order_ID AND Order_Year = in_year AND status = 0;

total := revenue_generated + revenue_lost;
percentage := revenue_generated*100/total;

IF percentage > 50 AND percentage < 66 THEN
 DBMS_OUTPUT.PUT_LINE('Average year'); 
ELSIF percentage > 65 AND percentage < 80 THEN
 DBMS_OUTPUT.PUT_LINE('Good year'); 
ELSIF percentage > 79 THEN
 DBMS_OUTPUT.PUT_LINE('Excellent year'); 
ELSE
 DBMS_OUTPUT.PUT_LINE('A year of losses'); 
END IF;


-- return the total sales
RETURN revenue_generated;

END;
/


