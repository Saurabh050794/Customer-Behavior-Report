SELECT * FROM costomer_behavior.costomer;
# total revenue gender wise
select gender,sum(purchase_amount) as revenue
from costomer
group by  gender;

# which costomer used a discount but still spent more then the purchase_amount.
SELECT customer_id, purchase_amount
FROM costomer
WHERE discount_applied = 'Yes'
AND purchase_amount >= (
    SELECT AVG(purchase_amount)
    FROM costomer
);

# top 5 products   with highest avg rating  
SELECT item_purchased,
       ROUND(AVG(review_rating), 2) AS "Average product rating"
FROM costomer
GROUP BY item_purchased
ORDER BY AVG(review_rating) DESC
LIMIT 5;



select shipping_type,
		ROUND(AVG(purchase_amount),2)
from costomer
where shipping_type in ('standard','express')
group by shipping_type;

# do subscribed customers spend more? campare average spend and total revenue betwwen subscribers and non subscribers.
SELECT subscription_status,
       COUNT(customer_id) AS total_customer,
       ROUND(AVG(purchase_amount), 2) AS avg_spend,
       ROUND(SUM(purchase_amount), 2) AS total_revenue
FROM customer
GROUP BY subscription_status
ORDER BY total_revenue DESC, avg_spend DESC;

# which 5 products have the highest precentage of purchases with discount applied?
SELECT item_purchased,
       ROUND(
           SUM(CASE WHEN discount_applied = 'Yes' THEN 1 ELSE 0 END) * 100.0 
           / COUNT(*), 
       2) AS discount_percentage
FROM customer
GROUP BY item_purchased
ORDER BY discount_percentage DESC
LIMIT 5;

# segment customers into new, returning and loyal based on their total number of purchases, and show the count of each segment . 

with customer_type as(
select customer_id, previous_purchases,
CASE 
	WHEN  previous_purchases= 1 THEN 'New'
	WHEN previous_purchases BETWEEN 2 AND 4 THEN 'Returning'
	ELSE 'Loyal'
	END AS customer_segment
from customer
)
select customer_segment, count(*) as "Number of customers"
from customer_type
group by customer_segment;


# what is the top 3 most purchased prducts wihtin each category?\
WITH item_counts AS (
    SELECT 
        category,
        item_purchased,
        COUNT(customer_id) AS total_orders,
        ROW_NUMBER() OVER (
            PARTITION BY category 
            ORDER BY COUNT(customer_id) DESC
        ) AS item_rank
    FROM customer
    GROUP BY category, item_purchased
)
SELECT 
    item_rank, 
    category, 
    item_purchased, 
    total_orders
FROM item_counts
WHERE item_rank <= 3;

# are customers who are repeat buyers( more then 5 previous purchase) also likely to subscribe?
select subscription_status,
count(customer_id)as repeat_buyers
from customer
where previous_purchases>5
group by subscription_status;
# what is the  revenue contribution of each age group?
select age_group,
sum(purchase_amount) as total_revenue
from customer
group by age_group
order by total_revenue desc;