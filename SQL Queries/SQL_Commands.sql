-- Join & Aggregate functions: Calculate each customer’s monetary balance by joining CUSTOMER_ACQUIRES_PACKAGES, PACKAGES and PAYMENT.
SELECT PAYMENT.CustomerID, SUM(DISTINCT PAYMENT.PaymentAmount) AS "Total Paid", SUM(DISTINCT PACKAGES.PackagePrice) AS "Total Purchased", 
        SUM(DISTINCT PAYMENT.PaymentAmount) - SUM(DISTINCT PACKAGES.PackagePrice) AS "Balance" 
    FROM PAYMENT INNER JOIN CUSTOMER_ACQUIRES_PACKAGES 
    ON CUSTOMER_ACQUIRES_PACKAGES.CustomerID = PAYMENT.CustomerID 
    INNER JOIN PACKAGES ON PACKAGES.PackageID = CUSTOMER_ACQUIRES_PACKAGES.PackageID 
        GROUP BY PAYMENT.CustomerID;

-- Anti join: Show customers that did not acquire any packages
SELECT DISTINCT(CustomerID) AS "Customers Without Packages" FROM CUSTOMER 
    LEFT JOIN CUSTOMER_ACQUIRES_PACKAGES ON CUSTOMER.CustomerID = CUSTOMER_ACQUIRES_PACKAGES.CustomerID
        WHERE PackageID = NULL;

-- Window functions & create view: Querying customer data for RFM analysis (Recency, Monetary, and Frequency of purchases)
CREATE VIEW CUSTOMER_RFM AS SELECT CustomerID,
    SUM(PaymentAmount) OVER
         (PARTITION BY CustomerID) AS "Monetary Value",
    COUNT(PaymentID) OVER
         (PARTITION BY CustomerID) AS "Frequency Value",
    MAX(PaymentDate) OVER
         (PARTITION BY CustomerID) AS "Recency Value"
  FROM PAYMENT
  ORDER BY "Total Paid";

-- Nested query: Identify customers that attended events of 2 different types (Easy Stroll and Easy Peasy Hike).
SELECT CustomerID, COUNT(CustomerID) AS "Events Attended", EventCategory FROM CUSTOMER_ATTENDS_EVENTS 
    WHERE (EventCategory = 'Easy Peasy Hike' AND CustomerID IN (SELECT CustomerID FROM CUSTOMER_ATTENDS_EVENTS WHERE EventCategory = 'Easy Stroll')) 
    OR (EventCategory = 'Easy Stroll' AND CustomerID IN (SELECT CustomerID FROM CUSTOMER_ATTENDS_EVENTS WHERE EventCategory = 'Easy Peasy Hike'))  
        GROUP BY CustomerID, EventCategory;

-- With Statement: Calculate each customer’s event balance (events acquired – events attended), joining CUSTOMER_ATTENDS_EVENTS, CUSTOMER_ACQUIRES_PACKAGES and PACKAGES. Show customers with balance > 8.
WITH Event_Balance(CustomerID, EventCategory, EventsAcquired, EventsAttended, Balance) AS
            (SELECT CAP.CUSTOMERID, PKG.EVENTCATEGORY, SUM(DISTINCT PKG.NUMBEROFEVENTS), COUNT(DISTINCT CAE.EVENTCATEGORY),  
            (SUM(DISTINCT PKG.NUMBEROFEVENTS) - COUNT(DISTINCT CAE.EVENTCATEGORY)) 
            FROM (CUSTOMER_ACQUIRES_PACKAGES CAP INNER JOIN PACKAGES PKG ON CAP.PACKAGEID = PKG.PACKAGEID)),
    SELECT CustomerID, EventCategory, EventsAcquired, EventsAttended, Balance
    FROM Event_Balance
    ORDER BY Balance;

-- Case Statement: Calculate taxes to be paid, considering year of payment.
SELECT PaymentDate, PaymentID, PaymentAmount, 
    CASE
        WHEN YEAR(PaymentDate) <= 2015 THEN PaymentAmount*0.2
        WHEN YEAR(PaymentDate) <= 2017 THEN PaymentAmount*0.25
        WHEN YEAR(PaymentDate) <= 2020 THEN PaymentAmount*0.3
    END AS "Total Taxes" 
    FROM PAYMENT ORDER BY PaymentDate;

-- Aggregation with substring: Show number of packages acquired by month to identify potential seasonality.
SELECT SUBSTR(REGISTRATIONDATE,1,2) AS "Month", COUNT(CUSTOMERID) AS "Packages Acquired" 
    FROM CUSTOMER GROUP BY SUBSTR(REGISTRATIONDATE,1,2) 
        ORDER BY SUBSTR(REGISTRATIONDATE,1,2);

-- Aggregation: Show photos to be sent for each customer, given their event attendance.
SELECT CAE.CUSTOMERID, P.DIRECTORY AS "Photos to Send"
    FROM PHOTO P INNER JOIN CUSTOMER_ATTENDS_EVENTS CAE ON P.EVENTDATE = CAE.EVENTDATE AND P.EVENTCATEGORY=CAE.EVENTCATEGORY
        ORDER BY CAE.CUSTOMERID;

-- Update statement: Update price of 2 event categories, increasing it by 10%.
UPDATE PACKAGES SET PackagePrice = PackagePrice * 1.1 
    WHERE EventCategory = 'Hiking Overhaul' OR EventCategory = 'Intermediate Hike';

-- Delete statement: Delete a type of package.
DELETE FROM PACKAGES 
    WHERE EventCategory = 'Easy Peasy Hike';

-- Create view: Create a view of photos from advanced level events.
CREATE VIEW AdvancedPhotos AS SELECT * FROM Photo 
    WHERE EventCategory = 'Hiking Overhaul' OR  EventCategory = 'Intermediate Hike';
