-- 設問1
-- すべてのユーザー情報を取得

SELECT *
FROM users;


-- 設問2
-- 2024年に作成されたユーザーを取得

SELECT *
FROM users
WHERE created_at BETWEEN '2024-01-01' AND '2024-12-31';


-- 設問3
-- 30歳未満かつ女性のユーザーを取得

SELECT *
FROM users
WHERE age < 30
AND gender = 'female';


-- 設問4
-- 全商品の一覧（商品名と価格）を取得

SELECT product_name, price
FROM products;


-- 設問5
-- ordersとusersを結合し、ユーザー名と注文日を取得

SELECT users.name, orders.order_date
FROM orders
JOIN users
ON orders.user_id = users.id;


-- 設問6
-- 商品名・数量・単価・金額を取得

SELECT
    products.product_name,
    order_items.quantity,
    products.price,
    products.price * order_items.quantity AS total_price
FROM order_items
JOIN products
ON order_items.product_id = products.id;


-- 設問7
-- ユーザーごとの注文件数を取得

SELECT
    users.name,
    COUNT(orders.id) AS order_count
FROM users
LEFT JOIN orders
ON users.id = orders.user_id
GROUP BY users.name;


-- 設問8
-- 各ユーザーの総購入金額を取得

SELECT
    users.name,
    SUM(products.price * order_items.quantity) AS total_amount
FROM users
JOIN orders
ON users.id = orders.user_id
JOIN order_items
ON orders.id = order_items.order_id
JOIN products
ON order_items.product_id = products.id
GROUP BY users.name;


-- 設問9
-- 最も注文金額が高かったユーザーを取得

SELECT
    users.name,
    SUM(products.price * order_items.quantity) AS total_amount
FROM users
JOIN orders
ON users.id = orders.user_id
JOIN order_items
ON orders.id = order_items.order_id
JOIN products
ON order_items.product_id = products.id
GROUP BY users.name
ORDER BY total_amount DESC
LIMIT 1;


-- 設問10
-- 各商品の注文回数（合計数量）を取得

SELECT
    products.product_name,
    SUM(order_items.quantity) AS total_quantity
FROM products
JOIN order_items
ON products.id = order_items.product_id
GROUP BY products.product_name;


-- 設問11
-- 注文が1回もないユーザーを取得

SELECT users.name
FROM users
LEFT JOIN orders
ON users.id = orders.user_id
WHERE orders.id IS NULL;


-- 設問12
-- 1回の注文で2種類以上の商品を購入した注文IDを取得

SELECT order_id
FROM order_items
GROUP BY order_id
HAVING COUNT(DISTINCT product_id) >= 2;


-- 設問13
-- 「テレビ」を注文したユーザー名を取得

SELECT DISTINCT users.name
FROM users
JOIN orders
ON users.id = orders.user_id
JOIN order_items
ON orders.id = order_items.order_id
JOIN products
ON order_items.product_id = products.id
WHERE products.product_name = 'テレビ';


-- 設問14
-- 注文日・ユーザー名・商品名・数量・合計金額を一覧表示

SELECT
    orders.order_date,
    users.name,
    products.product_name,
    order_items.quantity,
    products.price * order_items.quantity AS total_price
FROM orders
JOIN users
ON orders.user_id = users.id
JOIN order_items
ON orders.id = order_items.order_id
JOIN products
ON order_items.product_id = products.id;


-- 設問15
-- 最も多く購入された商品（数量ベース）を取得

SELECT
    products.product_name,
    SUM(order_items.quantity) AS total_quantity
FROM products
JOIN order_items
ON products.id = order_items.product_id
GROUP BY products.product_name
ORDER BY total_quantity DESC
LIMIT 1;


-- 設問16
-- 各月の注文件数を取得

SELECT
    YEAR(order_date) AS year,
    MONTH(order_date) AS month,
    COUNT(id) AS order_count
FROM orders
GROUP BY YEAR(order_date), MONTH(order_date);


-- 設問17
-- 注文のない商品を取得

SELECT products.product_name
FROM products
LEFT JOIN order_items
ON products.id = order_items.product_id
WHERE order_items.id IS NULL;


-- 設問18
-- order_items.product_id にインデックス追加

CREATE INDEX idx_product_id
ON order_items(product_id);


-- 設問19
-- ユーザーごとの平均注文金額を取得

SELECT
    users.name,
    AVG(order_totals.total_amount) AS average_amount
FROM users
JOIN (
    SELECT
        orders.id,
        orders.user_id,
        SUM(products.price * order_items.quantity) AS total_amount
    FROM orders
    JOIN order_items
    ON orders.id = order_items.order_id
    JOIN products
    ON order_items.product_id = products.id
    GROUP BY orders.id, orders.user_id
) AS order_totals
ON users.id = order_totals.user_id
GROUP BY users.name;


-- 設問20
-- 各ユーザーの最新注文日を取得

SELECT
    users.name,
    MAX(orders.order_date) AS latest_order_date
FROM users
JOIN orders
ON users.id = orders.user_id
GROUP BY users.name;


-- 設問21
-- 新規ユーザー「中村愛（25歳・女性・2025-06-01作成）」を追加

INSERT INTO users (id, name, age, gender, created_at)
VALUES (6, '中村愛', 25, '女性', '2025-06-01');


-- 設問22
-- 商品「エアコン（60000円）」を追加

INSERT INTO products (id, product_name, price)
VALUES (6, 'エアコン', 60000);


-- 設問23
-- ユーザーID1の新しい注文を追加（注文IDは10）

INSERT INTO orders (id, user_id, order_date)
VALUES (10, 1, '2025-06-10');


-- 設問24
-- 注文ID10に「エアコン（商品ID6）」を1つ追加

INSERT INTO order_items (order_id, product_id, quantity)
VALUES (10, 6, 1);


-- 設問25
-- 「田中美咲」の年齢を23→24に更新

UPDATE users
SET age = 24
WHERE name = '田中美咲';


-- 設問26
-- 全商品の価格を10%値上げ

UPDATE products
SET price = price * 1.1;


-- 設問27
-- 2024年5月以前の注文日を「2024-05-01」に統一

UPDATE orders
SET order_date = '2024-05-01'
WHERE order_date <= '2024-05-31';


-- 設問28
-- 「高橋健一」をusersテーブルから削除

DELETE FROM users
WHERE name = '高橋健一';


-- 設問29
-- 注文ID5の明細をすべて削除

DELETE FROM order_items
WHERE order_id = 5;


-- 設問30
-- 一度も注文されていない商品を削除

DELETE FROM products
WHERE id NOT IN (
    SELECT product_id
    FROM order_items
);