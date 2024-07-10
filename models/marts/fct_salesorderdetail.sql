{{ config(schema='CURATED', materialized='table') }}

with stg_salesorderdetail as (
    SELECT * 
    FROM {{ source('fivetran_database', 'salesorderdetail') }}
),

stg_salesorderheader as (
    SELECT * 
    FROM {{ source('fivetran_database', 'salesorderheader') }}
),


FINAL AS (
    SELECT
    {{ dbt_utils.generate_surrogate_key(['SH.salesorderid', 'SD.salesorderdetailid']) }} as sales_keyv2,
    SD.SalesOrderDetailID AS SalesOrderDetailKey,
    SH.SalesOrderID AS SalesOrderKey,
    SD.ProductID AS ProductKey,
    SH.Status AS SalesOrderStatusKey,
    SH.OnlineOrderFlag AS SalesOnlineOrderFlag,
    SH.AccountNumber AS SalesOrderAccountNumber,
    SH.CustomerID AS SalesOrderCustomerKey,
    -- SD.SpecialOfferID AS SpecialOfferKey,
    -- ISNULL(SH.SalesPersonID,0) AS SalesPersonKey,
    -- SH.TerritoryID AS TerritoryKey,
    SH.BillToAddressID AS BillToAddressKey,
    SH.ShipToAddressID AS ShipToAddressKey,
    -- SH.ShipMethodID AS ShipMethodKey,
    TO_VARCHAR(SD.ModifiedDate,'DDMMYYYY')::int AS SalesOrderDetailModifiedDateKey,
    TO_VARCHAR(SH.OrderDate,'DDMMYYYY')::int AS SalesOrderDateKey,
    TO_VARCHAR(SH.DueDate,'DDMMYYYY')::int AS SalesOrderDueDateKey,
    TO_VARCHAR(SH.ShipDate,'DDMMYYYY')::int AS SalesOrderShipDateKey,
    TO_VARCHAR(SH.ModifiedDate,'DDMMYYYY')::int AS SalesOrderModifiedDateKey,
    SD.OrderQty,
    SD.UnitPrice,
    SD.UnitPriceDiscount,
    SD.LineTotal,
    SH.SubTotal AS SalesOrderSubTotal,
    SH.TaxAmt AS SalesOrderTaxAmount,
    SH.Freight AS SalesOrderFreightAmount,
    SH.TotalDue AS SalesOrderTotalDueAmount,
    SH.OrderDate As SalesOrderDate
    FROM stg_salesorderdetail SD
    LEFT JOIN stg_salesorderheader SH ON SD.SalesOrderID = SH.SalesOrderID
)


SELECT * FROM FINAL