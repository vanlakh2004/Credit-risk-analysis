create database credit_risk_project;
use credit_risk_project;

SELECT COUNT(*) AS total_records
FROM credit_card_clients_raw;
DESCRIBE credit_card_clients_raw;
SELECT * FROM credit_card_clients_raw LIMIT 10;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_customers
FROM credit_card_clients_raw;

USE credit_risk_project;

DESCRIBE credit_card_clients_raw;
SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_customers,
    COUNT(*) - COUNT(DISTINCT ID) AS duplicate_id_rows
FROM credit_card_clients_raw;
SELECT
    ID,
    COUNT(*) AS occurrences
FROM credit_card_clients_raw
GROUP BY ID
HAVING COUNT(*) > 1
ORDER BY occurrences DESC;
SELECT
    SUM(ID IS NULL) AS missing_id,
    SUM(credit_limit IS NULL) AS missing_credit_limit,
    SUM(PAY_0 IS NULL) AS missing_recent_status,
    SUM(BILL_AMT1 IS NULL) AS missing_recent_bill,
    SUM(PAY_AMT1 IS NULL) AS missing_recent_payment,
    SUM(`default_payment_next_month` IS NULL)
        AS missing_default_target
FROM credit_card_clients_raw;
SELECT
    `default_payment_next_month` AS default_flag,
    COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY `default_payment_next_month`
ORDER BY default_flag;
SELECT
    COUNT(*) AS total_customers,
    SUM(`default_payment_next_month`) AS defaulted_customers,
    ROUND(
        100.0 * AVG(`default_payment_next_month`),
        2
    ) AS observed_default_rate_pct
FROM credit_card_clients_raw;

SELECT PAY_0, COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_0
ORDER BY PAY_0;
SELECT PAY_2, COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_2
ORDER BY PAY_2;
SELECT PAY_3, COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_3
ORDER BY PAY_3;
SELECT PAY_4, COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_4
ORDER BY PAY_4;
SELECT PAY_5, COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_5
ORDER BY PAY_5;
SELECT PAY_6, COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_6
ORDER BY PAY_6;

SELECT
    MIN(credit_limit) AS min_credit_limit,
    MAX(credit_limit) AS max_credit_limit,
    MIN(AGE) AS min_age,
    MAX(AGE) AS max_age,
    MIN(BILL_AMT1) AS min_bill,
    MAX(BILL_AMT1) AS max_bill,
    MIN(PAY_AMT1) AS min_payment,
    MAX(PAY_AMT1) AS max_payment
FROM credit_card_clients_raw;

####investigating negative bill amts
SELECT
    COUNT(*) AS total_customers,
    SUM(BILL_AMT1 < 0) AS negative_bill_count,
    ROUND(
        100.0 * SUM(BILL_AMT1 < 0) / COUNT(*),
        2
    ) AS negative_bill_pct,
    MIN(BILL_AMT1) AS minimum_bill
FROM credit_card_clients_raw;

###example checking data qlty
SELECT
    ID,
    CREDIT_LIMIT,
    BILL_AMT1,
    PAY_AMT1,
    `default_payment_next_month`
FROM credit_card_clients_raw
WHERE BILL_AMT1 < 0
ORDER BY BILL_AMT1
LIMIT 10;

###CHECKING IF CREDIT LIMIT IS POSITIVE
SELECT
    COUNT(*) AS invalid_credit_limits
FROM credit_card_clients_raw
WHERE CREDIT_LIMIT IS NULL
   OR CREDIT_LIMIT <= 0;
   
###VALIDATING THE REPAYMENT STATUS
SELECT
    PAY_0 AS repayment_status,
    COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_0
ORDER BY PAY_0; ###REPEAT THIS FOR ALL PAY6 OR ELSE FOLLOW THE NEXT FOR ONE GO 

SELECT 'PAY_0' AS repayment_column,
       PAY_0 AS repayment_status,
       COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY PAY_0

UNION ALL

SELECT 'PAY_2', PAY_2, COUNT(*)
FROM credit_card_clients_raw
GROUP BY PAY_2

UNION ALL

SELECT 'PAY_3', PAY_3, COUNT(*)
FROM credit_card_clients_raw
GROUP BY PAY_3

UNION ALL

SELECT 'PAY_4', PAY_4, COUNT(*)
FROM credit_card_clients_raw
GROUP BY PAY_4

UNION ALL

SELECT 'PAY_5', PAY_5, COUNT(*)
FROM credit_card_clients_raw
GROUP BY PAY_5

UNION ALL

SELECT 'PAY_6', PAY_6, COUNT(*)
FROM credit_card_clients_raw
GROUP BY PAY_6

ORDER BY repayment_column, repayment_status;

###VALIDATING DEFAULT RATES
SELECT
    default_payment_next_month AS default_flag,
    COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY default_payment_next_month
ORDER BY default_flag;

###DEFAULT RATE
SELECT
    COUNT(*) AS total_customers,
    SUM(default_payment_next_month) AS defaulted_customers,
    COUNT(*) - SUM(default_payment_next_month)
        AS non_defaulted_customers,
    ROUND(
        100.0 * AVG(default_payment_next_month),
        2
    ) AS observed_default_rate_pct
FROM credit_card_clients_raw;

#INVALID VALUES
SELECT
    SUM(default_payment_next_month IS NULL)
        AS missing_target,
    SUM(
        default_payment_next_month IS NOT NULL
        AND default_payment_next_month NOT IN (0, 1)
    ) AS invalid_target
FROM credit_card_clients_raw;

###MISSIN G VALUE ACROSS THE DATASET

SELECT
    SUM(ID IS NULL) AS missing_id,
    SUM(CREDIT_LIMIT IS NULL) AS missing_limit,
    SUM(SEX IS NULL) AS missing_sex,
    SUM(EDUCATION IS NULL) AS missing_education,
    SUM(MARRIAGE IS NULL) AS missing_marriage,
    SUM(AGE IS NULL) AS missing_age,

    SUM(PAY_0 IS NULL) AS missing_pay_0,
    SUM(PAY_2 IS NULL) AS missing_pay_2,
    SUM(PAY_3 IS NULL) AS missing_pay_3,
    SUM(PAY_4 IS NULL) AS missing_pay_4,
    SUM(PAY_5 IS NULL) AS missing_pay_5,
    SUM(PAY_6 IS NULL) AS missing_pay_6,

    SUM(BILL_AMT1 IS NULL) AS missing_bill_1,
    SUM(BILL_AMT2 IS NULL) AS missing_bill_2,
    SUM(BILL_AMT3 IS NULL) AS missing_bill_3,
    SUM(BILL_AMT4 IS NULL) AS missing_bill_4,
    SUM(BILL_AMT5 IS NULL) AS missing_bill_5,
    SUM(BILL_AMT6 IS NULL) AS missing_bill_6,

    SUM(PAY_AMT1 IS NULL) AS missing_payment_1,
    SUM(PAY_AMT2 IS NULL) AS missing_payment_2,
    SUM(PAY_AMT3 IS NULL) AS missing_payment_3,
    SUM(PAY_AMT4 IS NULL) AS missing_payment_4,
    SUM(PAY_AMT5 IS NULL) AS missing_payment_5,
    SUM(PAY_AMT6 IS NULL) AS missing_payment_6,

    SUM(default_payment_next_month IS NULL) AS missing_target
FROM credit_card_clients_raw;

SELECT
    EDUCATION,
    COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY EDUCATION
ORDER BY EDUCATION;
SELECT
    MARRIAGE,
    COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY MARRIAGE
ORDER BY MARRIAGE;
SELECT
    SEX,
    COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY SEX
ORDER BY SEX;

SELECT
    MIN(AGE) AS minimum_age,
    MAX(AGE) AS maximum_age,
    COUNT(*) AS total_customers,
    SUM(AGE < 18) AS under_18,
    SUM(AGE > 100) AS over_100
FROM credit_card_clients_raw;
SELECT
    AGE,
    COUNT(*) AS customer_count
FROM credit_card_clients_raw
GROUP BY AGE
ORDER BY AGE;


SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_customer_ids,
    COUNT(*) - COUNT(DISTINCT ID) AS duplicate_id_rows,
    SUM(ID IS NULL) AS missing_ids
FROM credit_card_clients_raw;


SELECT
    MIN(BILL_AMT1) AS min_bill_1,
    MAX(BILL_AMT1) AS max_bill_1,
    MIN(BILL_AMT2) AS min_bill_2,
    MAX(BILL_AMT2) AS max_bill_2,
    MIN(BILL_AMT3) AS min_bill_3,
    MAX(BILL_AMT3) AS max_bill_3,
    MIN(BILL_AMT4) AS min_bill_4,
    MAX(BILL_AMT4) AS max_bill_4,
    MIN(BILL_AMT5) AS min_bill_5,
    MAX(BILL_AMT5) AS max_bill_5,
    MIN(BILL_AMT6) AS min_bill_6,
    MAX(BILL_AMT6) AS max_bill_6,

    MIN(PAY_AMT1) AS min_payment_1,
    MAX(PAY_AMT1) AS max_payment_1,
    MIN(PAY_AMT2) AS min_payment_2,
    MAX(PAY_AMT2) AS max_payment_2,
    MIN(PAY_AMT3) AS min_payment_3,
    MAX(PAY_AMT3) AS max_payment_3,
    MIN(PAY_AMT4) AS min_payment_4,
    MAX(PAY_AMT4) AS max_payment_4,
    MIN(PAY_AMT5) AS min_payment_5,
    MAX(PAY_AMT5) AS max_payment_5,
    MIN(PAY_AMT6) AS min_payment_6,
    MAX(PAY_AMT6) AS max_payment_6
FROM credit_card_clients_raw;


SELECT
    COUNT(*) AS total_rows,

    SUM(
        BILL_AMT1 IS NULL OR BILL_AMT2 IS NULL OR
        BILL_AMT3 IS NULL OR BILL_AMT4 IS NULL OR
        BILL_AMT5 IS NULL OR BILL_AMT6 IS NULL
    ) AS rows_with_missing_bills,

    SUM(
        PAY_AMT1 IS NULL OR PAY_AMT2 IS NULL OR
        PAY_AMT3 IS NULL OR PAY_AMT4 IS NULL OR
        PAY_AMT5 IS NULL OR PAY_AMT6 IS NULL
    ) AS rows_with_missing_payments,

    SUM(default_payment_next_month IS NULL)
        AS missing_target,

    SUM(default_payment_next_month NOT IN (0, 1))
        AS invalid_target
FROM credit_card_clients_raw;

####CREATE TABLE

CREATE TABLE credit_card_clients_analysis AS
SELECT *
FROM credit_card_clients_raw;

SELECT
    COUNT(*) AS total_rows,
    COUNT(DISTINCT ID) AS unique_customers,
    SUM(default_payment_next_month = 1) AS observed_defaults,
    SUM(default_payment_next_month = 0) AS non_defaults
FROM credit_card_clients_analysis;


SELECT
    COUNT(*) AS total_customers,

    SUM(default_payment_next_month = 1)
        AS observed_defaults,

    SUM(default_payment_next_month = 0)
        AS non_defaults,

    ROUND(
        100.0 * SUM(default_payment_next_month = 1) / COUNT(*),
        2
    ) AS observed_default_rate_pct,

    SUM(CREDIT_LIMIT) AS total_credit_limit_ntd,

    ROUND(AVG(CREDIT_LIMIT), 2) AS average_credit_limit_ntd,

    ROUND(MIN(CREDIT_LIMIT), 2) AS minimum_credit_limit_ntd,

    ROUND(MAX(CREDIT_LIMIT), 2) AS maximum_credit_limit_ntd

FROM credit_card_clients_analysis;

####HOW MUCH CUSTOMERS ACTUALLY OWE


SELECT
    COUNT(*) AS total_customers,

    ROUND(SUM(BILL_AMT1), 2)
        AS total_bill_amount_ntd,

    ROUND(AVG(BILL_AMT1), 2)
        AS average_bill_amount_ntd,

    MIN(BILL_AMT1) AS minimum_bill_amount_ntd,

    MAX(BILL_AMT1) AS maximum_bill_amount_ntd,

    SUM(BILL_AMT1 < 0)
        AS customers_with_negative_bills,

    SUM(BILL_AMT1 = 0)
        AS customers_with_zero_bills,

    SUM(BILL_AMT1 > CREDIT_LIMIT)
        AS customers_bill_above_credit_limit

FROM credit_card_clients_analysis;

####BILL AMT ANALYSIS





