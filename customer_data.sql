-- gender wise total revenue
SELECT
    "Gender",
    SUM("Purchase Amount (USD)") AS total_revenue
FROM customer
GROUP BY "Gender";

--discount but stuill more than average bill
SELECT
    "Customer ID",
    "Purchase Amount (USD)"
FROM customer
WHERE "Purchase Amount (USD)" >= (
    SELECT AVG("Purchase Amount (USD)")
    FROM customer
)
AND "Discount Applied" = 'Yes';



--top 5 product with highest average review rating
SELECT
    "Item Purchased",
    AVG("Review Rating") AS avg_rating
FROM customer
GROUP BY "Item Purchased"
ORDER BY avg_rating DESC
LIMIT 5;

-- averag epurchase amount between standard and shipping
SELECT * FROM customer LIMIT 5
SELECT
    "Shipping Type",
    AVG("Purchase Amount (USD)") AS "avg_purchase_amount"
FROM customer
GROUP BY "Shipping Type"
ORDER BY "avg_purchase_amount"  DESC

--avg spend and total rev between subsrbibed and non subscribed
SELECT * FROM customer LIMIT 5
SELECT
    "Subscription Status",
    SUM("Purchase Amount (USD)") AS "Total Purchase"  ,
    AVG("Purchase Amount (USD)") AS "avg spend"
FROM customer
GROUP BY "Subscription Status"

--product with highest percent of purchase with discount
SELECT * FROM customer LIMIT 5
SELECT
    "Item Purchased",
    ROUND(
        SUM(CASE WHEN "Discount Applied" = 'Yes' THEN 1 ELSE 0 END) * 100.0
        / COUNT(*),
        2
    ) AS "Discount Percentage"
FROM customer
GROUP BY "Item Purchased"
LIMIT 5;

--segment customers into new returning and loyal based on their total
--number of previous purchases and show count of each segemnetn
SELECT
    CASE
        WHEN "Previous Purchases" < 10 THEN 'New'
        WHEN "Previous Purchases" BETWEEN 10 AND 20 THEN 'Returning'
        ELSE 'Loyal'
    END AS "Customer Type",
    COUNT(*) AS "Number of Customers"
FROM customer
GROUP BY "Customer Type";

--top 3 purchased within each category
SELECT * FROM customer LIMIT 5
WITH item_count AS ( --A CTE creates a temporary result set 
--that you can reference later.Think of it as creating a 
--temporary table called item_count.
    SELECT
        "Category",
        "Item Purchased",
        COUNT("Customer ID") AS "Total Orders", 
        --Counts how many customers purchased each item
        ROW_NUMBER() OVER (
            PARTITION BY "Category"
            --Start ranking separately for each category."
--          Without it, all items from every category would be ranked
            -- together.
            ORDER BY COUNT("Customer ID") DESC
        ) AS Item_rank
    FROM customer
    GROUP BY --This groups all rows having the same category and 
    --item together.
        "Category",
        "Item Purchased"
)

SELECT
    Item_rank,
    "Category",
    "Item Purchased",
    "Total Orders"
FROM item_count
WHERE Item_rank <= 3
ORDER BY
    "Category",
    Item_rank;
    
--are customers who are repeat buyers also likely to subscribe?
SELECT
    "Subscription Status",
    COUNT("Customer ID") AS "Repeat Buyers"
FROM customer
WHERE "Previous Purchases" > 5
GROUP BY "Subscription Status";

--revenue contribution of each age group
SELECT
    "Age Group",
    SUM("Purchase Amount (USD)") AS "Total Revenue" 
FROM customer
GROUP BY "Age Group"