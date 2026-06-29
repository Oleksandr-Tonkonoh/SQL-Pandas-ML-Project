-- ============================================================================
-- TASK 1: Consecutive Days Detection (Islands Problem)
-- Objective: Group contiguous order dates into continuous streaks.
-- Algorithm: Combines ROW_NUMBER() and DATE_SUB() to generate a consistent 
-- 'group_marker' for consecutive days, then ranks them using DENSE_RANK().
-- ============================================================================
with cte as (select order_date,
date_sub(order_date, interval row_number() over(order by order_date) day) as group_marker
from orders)

select order_date, dense_rank() over(order by group_marker) as group_id
from cte group by group_marker, order_date;


-- ============================================================================
-- TASK 2: 30-Day User Retention Rate
-- Objective: Calculate the percentage of users registered in a specific month 
-- who logged back into the system exactly 30 days later.
-- Technique: LEFT JOIN connects the registration cohort with subsequent logins.
-- ============================================================================
with user_registration as (select user_id, min(login_date) as reg_date, date_format(min(login_date), '%Y-%m') as reg_month 
from logins group by user_id), 

returned_user as (select distinct r.user_id from user_registration r inner join logins l on r.user_id = l.user_id 
where l.login_date = date_add(r.reg_date, interval 30 day)) 

select r.reg_month as month, round(count(distinct ret.user_id) * 100 / count(distinct r.user_id), 2) as percent 
from user_registration r left join returned_user ret on r.user_id = ret.user_id group by r.reg_month;


-- ============================================================================
-- TASK 3: Top Earners Extraction (Percentiles)
-- Objective: Identify the highest-paid employees (top 10%) within each 
-- individual department.
-- Technique: PERCENT_RANK() computes the relative rank of salaries from 0 to 1.
-- ============================================================================
with cte as (select employee_id, salary, department, 
percent_rank() over(partition by department order by salary) as p_rank from employees)

select employee_id, department, salary from cte where p_rank between 0.9 and 1;


-- ============================================================================
-- TASK 4: Moving Median Revenue
-- Objective: Calculate the cumulative moving median of daily revenue from the 
-- beginning of time up to the current day to smooth out fluctuations.
-- Technique: Self-join captures historical records, while FLOOR/CEIL logic 
-- handles median calculations for both even and odd row counts.
-- ============================================================================
with daily_revenue as (select order_date, sum(revenue) as revenue from orders group by order_date),

cte as (select d1.order_date as c_day, d2.revenue as h_revenue, 
row_number() over(partition by d1.order_date order by d2.revenue) as row_num, count(*) over(partition by d1.order_date) as t_count
from daily_revenue d1 inner join daily_revenue d2 on d2.order_date <= d1.order_date),

cte2 as (select c_day as current_day, round(avg(h_revenue), 2) as r_m_r from cte 
where row_num in (floor((t_count + 1) / 2), ceil((t_count + 1) / 2)) group by c_day)

select current_day, r_m_r from cte2 order by current_day;


-- ============================================================================
-- TASK 5: Customer ABC Analysis (Pareto 80/20 Rule)
-- Objective: Isolate high-value clients (Category A) who cumulatively 
-- generate the top 80% of total company revenue.
-- Technique: Running total window function computes the running percentage. 
-- The WHERE clause includes the marginal customer who crosses the 80% threshold.
-- ============================================================================
with customer_revenue as (select customer_id, sum(revenue) as total_customer_revenue from orders group by customer_id),

running_percentages as (select customer_id, total_customer_revenue, 
sum(total_customer_revenue) over(order by total_customer_revenue desc) as r_revenue,
sum(total_customer_revenue) over() as total_company_revenue,
(sum(total_customer_revenue) over(order by total_customer_revenue desc) *100) / sum(total_customer_revenue) over() as r_percentage
from customer_revenue)


select customer_id, total_customer_revenue, round(r_percentage, 2) as revenue_share_pct
from running_percentages where r_percentage <= 80 or (r_percentage - (total_customer_revenue * 100 / total_company_revenue)) < 80;



