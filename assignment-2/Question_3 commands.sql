--Question 3

-- Create Tables with Constraints
CREATE TABLE CUSTOMER (
    CustomerID NUMBER(10) PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    PhoneNumber VARCHAR2(15) NOT NULL,
    Email VARCHAR2(100) NOT NULL UNIQUE,
    Address VARCHAR2(200) NOT NULL,
    DeliveryAddress VARCHAR2(200) NOT NULL,
    Suburb VARCHAR2(50) NOT NULL,
    CONSTRAINT chk_customer_phone CHECK (REGEXP_LIKE(PhoneNumber, '^[0-9]{10}$')),
    CONSTRAINT chk_customer_email CHECK (REGEXP_LIKE(Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);


CREATE TABLE DRIVER (
    DriverID NUMBER(10) PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    PhoneNumber VARCHAR2(15) NOT NULL,
    LicenseNumber VARCHAR2(20) NOT NULL UNIQUE,
    Suburb VARCHAR2(50) NOT NULL,
    CONSTRAINT chk_driver_phone CHECK (REGEXP_LIKE(PhoneNumber, '^[0-9]{10}$'))
);

CREATE TABLE RESTAURANT (
    RestaurantID NUMBER(10) PRIMARY KEY,
    Name VARCHAR2(100) NOT NULL,
    Suburb VARCHAR2(50) NOT NULL,
    Location VARCHAR2(200) NOT NULL,
    PhoneNumber VARCHAR2(15) NOT NULL,
    Email VARCHAR2(100) NOT NULL,
    CONSTRAINT chk_restaurant_phone CHECK (REGEXP_LIKE(PhoneNumber, '^[0-9]{10}$')),
    CONSTRAINT chk_restaurant_email CHECK (REGEXP_LIKE(Email, '^[A-Za-z0-9._%+-]+@[A-Za-z0-9.-]+\.[A-Za-z]{2,}$'))
);


CREATE TABLE CERTIFICATION (
    CertificationID NUMBER(10) PRIMARY KEY,
    CertificationName VARCHAR2(50) NOT NULL UNIQUE,
    IssuingOrganization VARCHAR2(100) NOT NULL,
    IssueDate DATE NOT NULL
);


CREATE TABLE NUTRITION (
    NutritionID NUMBER(10) PRIMARY KEY,
    NutrientName VARCHAR2(50) NOT NULL,
    Unit VARCHAR2(20) NOT NULL,
    DailyValuePercentage NUMBER(5,2) DEFAULT 0 NOT NULL,
    Amount NUMBER(10,2) DEFAULT 0 NOT NULL,
    CONSTRAINT chk_nutrition_daily CHECK (DailyValuePercentage >= 0 AND DailyValuePercentage <= 100),
    CONSTRAINT chk_nutrition_amount CHECK (Amount >= 0)
);


CREATE TABLE DISH (
    DishID NUMBER(10) PRIMARY KEY,
    RestaurantID NUMBER(10) NOT NULL,
    Name VARCHAR2(100) NOT NULL,
    Description VARCHAR2(500) NOT NULL,
    Price NUMBER(8,2) NOT NULL,
    PreparationMethod VARCHAR2(50) NOT NULL,
    MainIngredient VARCHAR2(50) NOT NULL,
    CourseType VARCHAR2(20) NOT NULL,
    Kilojoules NUMBER(6) NOT NULL,
    GlutenFree CHAR(1) DEFAULT 'N' NOT NULL,
    DairyFree CHAR(1) DEFAULT 'N' NOT NULL,
    DeliveryTimeCategory VARCHAR2(20) NOT NULL,
    Is_vegan CHAR(1) DEFAULT 'N' NOT NULL,
    Is_halal CHAR(1) DEFAULT 'N' NOT NULL,
    PreparationTime NUMBER(4) NOT NULL,
    CONSTRAINT fk_dish_restaurant FOREIGN KEY (RestaurantID) REFERENCES RESTAURANT(RestaurantID),
    CONSTRAINT chk_dish_price CHECK (Price >= 0),
    CONSTRAINT chk_dish_kilojoules CHECK (Kilojoules >= 0),
    CONSTRAINT chk_dish_gluten CHECK (GlutenFree IN ('Y','N')),
    CONSTRAINT chk_dish_dairy CHECK (DairyFree IN ('Y','N')),
    CONSTRAINT chk_dish_vegan CHECK (Is_vegan IN ('Y','N')),
    CONSTRAINT chk_dish_halal CHECK (Is_halal IN ('Y','N')),
    CONSTRAINT chk_dish_preptime CHECK (PreparationTime > 0),
    CONSTRAINT chk_dish_delivery_category CHECK (DeliveryTimeCategory IN ('Fast', 'Regular', 'Worth the wait')),
    CONSTRAINT chk_dish_course CHECK (CourseType IN ('Starter', 'Main', 'Dessert', 'Side'))
);


CREATE TABLE "ORDER" (
    OrderID NUMBER(10) PRIMARY KEY,
    CustomerID NUMBER(10) NOT NULL,
    RestaurantID NUMBER(10) NOT NULL,
    DriverID NUMBER(10) NOT NULL,
    OrderDate TIMESTAMP DEFAULT SYSTIMESTAMP NOT NULL,
    RequestedDeliveryTime TIMESTAMP NOT NULL,
    ActualDeliveryTime TIMESTAMP,
    DeliveryAddress VARCHAR2(200) NOT NULL,
    DeliveryStatus VARCHAR2(20) DEFAULT 'Pending' NOT NULL,
    Quantity NUMBER(5) DEFAULT 1 NOT NULL,
    TotalPrice NUMBER(10,2) DEFAULT 0 NOT NULL,
    CONSTRAINT fk_order_customer FOREIGN KEY (CustomerID) REFERENCES CUSTOMER(CustomerID),
    CONSTRAINT fk_order_restaurant FOREIGN KEY (RestaurantID) REFERENCES RESTAURANT(RestaurantID),
    CONSTRAINT fk_order_driver FOREIGN KEY (DriverID) REFERENCES DRIVER(DriverID),
    CONSTRAINT chk_order_quantity CHECK (Quantity > 0),
    CONSTRAINT chk_order_price CHECK (TotalPrice >= 0),
    CONSTRAINT chk_delivery_status CHECK (DeliveryStatus IN ('Pending', 'In Progress', 'Delivered', 'Cancelled')),
    CONSTRAINT chk_delivery_time CHECK (RequestedDeliveryTime > OrderDate)
);

CREATE TABLE ORDERITEM (
    OrderID NUMBER(10),
    DishID NUMBER(10),
    CONSTRAINT pk_orderitem PRIMARY KEY (OrderID, DishID),
    CONSTRAINT fk_orderitem_order FOREIGN KEY (OrderID) REFERENCES "ORDER"(OrderID),
    CONSTRAINT fk_orderitem_dish FOREIGN KEY (DishID) REFERENCES DISH(DishID)
);


CREATE TABLE RESTAURANTCERTIFICATION (
    RestaurantID NUMBER(10),
    CertificationID NUMBER(10),
    CONSTRAINT pk_restcert PRIMARY KEY (RestaurantID, CertificationID),
    CONSTRAINT fk_restcert_restaurant FOREIGN KEY (RestaurantID) REFERENCES RESTAURANT(RestaurantID),
    CONSTRAINT fk_restcert_certification FOREIGN KEY (CertificationID) REFERENCES CERTIFICATION(CertificationID)
);

CREATE TABLE DISHNUTRITION (
    DishID NUMBER(10),
    NutritionID NUMBER(10),
    CONSTRAINT pk_dishnutrition PRIMARY KEY (DishID, NutritionID),
    CONSTRAINT fk_dishnutr_dish FOREIGN KEY (DishID) REFERENCES DISH(DishID),
    CONSTRAINT fk_dishnutr_nutrition FOREIGN KEY (NutritionID) REFERENCES NUTRITION(NutritionID)
);


-- Part 2: Sample Data Population
-- Insert Customers
INSERT INTO CUSTOMER VALUES (1, 'Rajesh Kumar', '0412345678', 'rajesh.kumar@email.com', '42 Singh Street', '42 Singh Street', 'Mumbai Heights');
INSERT INTO CUSTOMER VALUES (2, 'Priya Patel', '0423456789', 'priya.patel@email.com', '15 Gandhi Road', '15 Gandhi Road', 'Delhi District');
INSERT INTO CUSTOMER VALUES (3, 'Arun Sharma', '0434567890', 'arun.sharma@email.com', '8 Nehru Avenue', '8 Nehru Avenue', 'Mumbai Heights');

-- Insert Drivers
INSERT INTO DRIVER VALUES (1, 'Suresh Verma', '0445678901', 'DL123456', 'Mumbai Heights');
INSERT INTO DRIVER VALUES (2, 'Amit Singh', '0456789012', 'DL234567', 'Delhi District');
INSERT INTO DRIVER VALUES (3, 'Deepak Gupta', '0467890123', 'DL345678', 'Mumbai Heights');

-- Insert Restaurants
INSERT INTO RESTAURANT VALUES (1, 'Taj Flavors', 'Mumbai Heights', '23 Spice Lane', '0478901234', 'taj.flavors@email.com');
INSERT INTO RESTAURANT VALUES (2, 'Delhi Darbar', 'Delhi District', '45 Curry Road', '0489012345', 'delhi.darbar@email.com');
INSERT INTO RESTAURANT VALUES (3, 'Bombay Bites', 'Mumbai Heights', '67 Masala Street', '0490123456', 'bombay.bites@email.com');

-- Insert Certifications
INSERT INTO CERTIFICATION VALUES (1, 'Halal Certified', 'Halal Authority India', TO_DATE('2024-01-01', 'YYYY-MM-DD'));
INSERT INTO CERTIFICATION VALUES (2, 'Vegan Friendly', 'Vegan Society', TO_DATE('2024-02-01', 'YYYY-MM-DD'));
INSERT INTO CERTIFICATION VALUES (3, 'Food Safety', 'FSSAI', TO_DATE('2024-03-01', 'YYYY-MM-DD'));

-- Insert Nutrition Information
INSERT INTO NUTRITION VALUES (1, 'Protein', 'g', 25.5, 12.75);
INSERT INTO NUTRITION VALUES (2, 'Carbohydrates', 'g', 15.3, 45.9);
INSERT INTO NUTRITION VALUES (3, 'Fat', 'g', 32.1, 16.05);

-- Insert Dishes
INSERT INTO DISH VALUES (1, 1, 'Butter Chicken', 'Creamy tomato-based curry with tender chicken', 18.99, 'Simmered', 'Chicken', 'Main', 2500, 'Y', 'N', 'Regular', 'N', 'Y', 25);
INSERT INTO DISH VALUES (2, 1, 'Palak Paneer', 'Spinach curry with cottage cheese', 16.99, 'Cooked', 'Spinach', 'Main', 1800, 'Y', 'N', 'Fast', 'N', 'Y', 15);
INSERT INTO DISH VALUES (3, 2, 'Vegan Biryani', 'Aromatic rice with vegetables', 19.99, 'Steamed', 'Rice', 'Main', 2000, 'Y', 'Y', 'Worth the wait', 'Y', 'Y', 35);

-- Insert Orders
INSERT INTO "ORDER" VALUES (1, 1, 1, 1, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '1' HOUR, NULL, '42 Singh Street', 'Pending', 2, 35.98);
INSERT INTO "ORDER" VALUES (2, 2, 2, 2, SYSTIMESTAMP, SYSTIMESTAMP + INTERVAL '2' HOUR, NULL, '15 Gandhi Road', 'In Progress', 1, 19.99);
INSERT INTO "ORDER" VALUES (3, 3, 1, 3, SYSTIMESTAMP - INTERVAL '1' DAY, SYSTIMESTAMP - INTERVAL '23' HOUR, SYSTIMESTAMP - INTERVAL '23' HOUR, '8 Nehru Avenue', 'Delivered', 2, 33.98);

-- Insert OrderItems
INSERT INTO ORDERITEM VALUES (1, 1);
INSERT INTO ORDERITEM VALUES (1, 2);
INSERT INTO ORDERITEM VALUES (2, 3);
INSERT INTO ORDERITEM VALUES (3, 1);
INSERT INTO ORDERITEM VALUES (3, 2);

-- Insert RestaurantCertifications
INSERT INTO RESTAURANTCERTIFICATION VALUES (1, 1);
INSERT INTO RESTAURANTCERTIFICATION VALUES (1, 3);
INSERT INTO RESTAURANTCERTIFICATION VALUES (2, 2);

-- Insert DishNutrition
INSERT INTO DISHNUTRITION VALUES (1, 1);
INSERT INTO DISHNUTRITION VALUES (1, 3);
INSERT INTO DISHNUTRITION VALUES (2, 2);

COMMIT;



-- Part 3: Grant Permissions to Marker
GRANT SELECT, UPDATE, DELETE ON CUSTOMER TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON DRIVER TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON RESTAURANT TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON "ORDER" TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON ORDERITEM TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON DISH TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON RESTAURANTCERTIFICATION TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON CERTIFICATION TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON DISHNUTRITION TO MARKERTL;
GRANT SELECT, UPDATE, DELETE ON NUTRITION TO MARKERTL;
COMMIT;



--QUESTION 4

-- ViewA: Order details for a particular customer
CREATE VIEW ViewA AS
SELECT 
    o.OrderID,
    o.OrderDate,
    o.RequestedDeliveryTime,
    o.ActualDeliveryTime,
    o.DeliveryAddress,
    o.DeliveryStatus,
    o.Quantity,
    o.TotalPrice,
    r.Name AS RestaurantName,
    d.Name AS DishName,
    d.Description AS DishDescription,
    d.Price AS DishPrice,
    d.PreparationMethod,
    d.MainIngredient,
    d.CourseType,
    d.DeliveryTimeCategory
FROM "ORDER" o
JOIN ORDERITEM oi ON o.OrderID = oi.OrderID
JOIN DISH d ON oi.DishID = d.DishID
JOIN RESTAURANT r ON d.RestaurantID = r.RestaurantID
WHERE o.CustomerID = 1; -- Assuming customer ID 1

-- ViewB: Vegetarian dishes delivered under 30 minutes in a particular suburb
CREATE VIEW ViewB AS
SELECT 
    d.DishID,
    d.Name AS DishName,
    d.Description AS DishDescription,
    d.Price AS DishPrice,
    d.PreparationMethod,
    d.MainIngredient,
    d.CourseType,
    d.DeliveryTimeCategory,
    r.Suburb
FROM DISH d
JOIN RESTAURANT r ON d.RestaurantID = r.RestaurantID
WHERE d.Is_vegan = 'Y'
  AND r.Suburb = 'Mumbai Heights'
  AND d.DeliveryTimeCategory = 'Fast';

-- ViewC: Order details for a particular restaurant on a particular date
CREATE VIEW ViewC AS
SELECT
    o.OrderID,
    o.OrderDate,
    o.RequestedDeliveryTime,
    o.ActualDeliveryTime,
    o.DeliveryAddress,
    o.DeliveryStatus,
    o.Quantity,
    o.TotalPrice,
    c.Name AS CustomerName,
    d.Name AS DishName,
    d.Description AS DishDescription,
    d.Price AS DishPrice
FROM "ORDER" o
JOIN ORDERITEM oi ON o.OrderID = oi.OrderID
JOIN DISH d ON oi.DishID = d.DishID
JOIN CUSTOMER c ON o.CustomerID = c.CustomerID
WHERE o.RestaurantID = 1
  AND o.OrderDate = TO_DATE('2024-01-01', 'YYYY-MM-DD');

-- ViewD: Vegan restaurants and their dish details
CREATE VIEW ViewD AS
SELECT
    r.Name AS RestaurantName,
    r.Suburb,
    r.Location,
    r.PhoneNumber,
    r.Email,
    d.Name AS DishName,
    d.Description AS DishDescription,
    d.Price AS DishPrice
FROM RESTAURANT r
JOIN DISH d ON r.RestaurantID = d.RestaurantID
JOIN RESTAURANTCERTIFICATION rc ON r.RestaurantID = rc.RestaurantID
JOIN CERTIFICATION c ON rc.CertificationID = c.CertificationID
WHERE c.CertificationName = 'Vegan Friendly'
  AND d.Is_vegan = 'Y';

-- ViewE: Drivers and their deliveries on a particular date
CREATE VIEW ViewE AS
SELECT
    d.Name AS DriverName,
    d.PhoneNumber AS DriverPhone,
    o.OrderID,
    o.OrderDate,
    c.Name AS CustomerName,
    c.PhoneNumber AS CustomerPhone
FROM DRIVER d
LEFT JOIN "ORDER" o ON d.DriverID = o.DriverID
LEFT JOIN CUSTOMER c ON o.CustomerID = c.CustomerID
WHERE o.OrderDate = TO_DATE('2024-01-01', 'YYYY-MM-DD');

-- ViewF: Available drivers in a particular suburb
CREATE VIEW ViewF AS
SELECT
    d.DriverID,
    d.Name AS DriverName,
    d.PhoneNumber AS DriverPhone,
    d.Suburb
FROM DRIVER d
WHERE d.DriverID NOT IN (
    SELECT DriverID
    FROM "ORDER"
    WHERE DeliveryStatus IN ('Pending', 'In Progress')
)
  AND d.Suburb = 'Mumbai Heights';

-- ViewG: Total orders per restaurant
CREATE VIEW ViewG AS
SELECT
    r.Name AS RestaurantName,
    COUNT(o.OrderID) AS TotalOrders
FROM RESTAURANT r
LEFT JOIN "ORDER" o ON r.RestaurantID = o.RestaurantID
GROUP BY r.Name;

-- ViewH: Restaurant dish 'booklet'
CREATE VIEW ViewH AS
SELECT
    r.Name AS RestaurantName,
    d.Name AS DishName,
    d.Description AS DishDescription,
    d.Price AS DishPrice,
    d.CourseType,
    d.DeliveryTimeCategory
FROM RESTAURANT r
JOIN DISH d ON r.RestaurantID = d.RestaurantID
WHERE r.RestaurantID = 1; -- Assuming restaurant ID 1

-- ViewI: Orders per suburb in previous month
CREATE VIEW ViewI AS
SELECT
    c.Suburb,
    COUNT(o.OrderID) AS OrderCount
FROM CUSTOMER c
JOIN "ORDER" o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN ADD_MONTHS(TRUNC(SYSDATE, 'MM'), -1) AND LAST_DAY(ADD_MONTHS(SYSDATE, -1))
GROUP BY c.Suburb
ORDER BY OrderCount DESC;

-- ViewJ: Late orders and average delay per suburb in a particular month
CREATE VIEW ViewJ AS
SELECT
    c.Suburb,
    COUNT(o.OrderID) AS LateOrders,
    AVG(EXTRACT(MINUTE FROM (o.ActualDeliveryTime - o.RequestedDeliveryTime))) AS AvgDelayMinutes
FROM CUSTOMER c
JOIN "ORDER" o ON c.CustomerID = o.CustomerID
WHERE o.OrderDate BETWEEN TO_DATE('2024-01-01', 'YYYY-MM-DD') AND LAST_DAY(TO_DATE('2024-01-01', 'YYYY-MM-DD'))
  AND o.ActualDeliveryTime > o.RequestedDeliveryTime
GROUP BY c.Suburb;

COMMIT;







GRANT SELECT ON ViewA TO MARKERTL;
GRANT SELECT ON ViewB TO MARKERTL;
GRANT SELECT ON ViewC TO MARKERTL;
GRANT SELECT ON ViewD TO MARKERTL;
GRANT SELECT ON ViewE TO MARKERTL;
GRANT SELECT ON ViewF TO MARKERTL;
GRANT SELECT ON ViewG TO MARKERTL;
GRANT SELECT ON ViewH TO MARKERTL;
GRANT SELECT ON ViewI TO MARKERTL;
GRANT SELECT ON ViewJ TO MARKERTL;
COMMIT;
