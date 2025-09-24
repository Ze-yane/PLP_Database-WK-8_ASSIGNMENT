# PLP_Database-WK-8_ASSIGNMENT
An E-commerce database
This is a sample MySQL database for an e-commerce store. It manages customers, products, categories, suppliers, orders, payments, shipments, inventory, and reviews.

Tables

customers – customer details

categories – product categories (Skincare, Haircare, etc.)

suppliers – supplier details

products – product info (linked to categories & suppliers)

inventory – stock tracking

orders – customer orders

order_items – products inside each order

payments – payments for orders

shipments – order delivery details

reviews – customer feedback

Relationships

One customer → many orders

One category → many products

One supplier → many products

Orders ↔ Products → many-to-many (via order_items)

One order → one payment & one shipment

