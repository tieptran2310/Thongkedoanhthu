
--Case01: Thống kê theo mỗi khu vực: tổng số hóa đơn, tỷ lệ % Online, Offline tại quý II năm 2013

Select 
	TerritoryID MaKV,
	COUNT (*) TongsoHD,
	Format(SUM(Case when OnlineOrderFlag = 1 then 1 else 0 end)*1.0/count(*),'P1') [%DonhangOnline],
	Format(SUM(Case when OnlineOrderFlag = 0 then 1 else 0 end)*1.0/count(*),'P1') [%DonhangOffline]
From Sales.SalesOrderHeader
Where YEAR(OrderDate)=2013 and DATEPART(Quarter,OrderDate)=2
Group by TerritoryID
Order by TerritoryID

-- Case 02: Thống kê 10 sản phẩm có doanh thu cao nhất

-- sales.SalesOrderHeader: hóa đơn
-- sales.SalesOrderDetail: chi tiết hóa đơn
-- Production.Product: sản phẩm

Select Top 10
	c.Name Ten_sanpham,
	SUM(a.LineTotal) So_tien
From Sales.SalesOrderDetail a inner join Sales.SalesOrderHeader b on b.SalesOrderID=a.SalesOrderID
	 Inner join Production.Product c on a.ProductID=c.ProductID
Where YEAR(b.OrderDate)=2013
Group by c.Name
Order by SUM(a.LineTotal) DESC


--Case 03: Thống kê có bao nhiêu hóa đơn mà trong đó có ID sản phẩm trong hóa đơn thuộc top 10 sản phẩm có doanh thu lớn nhất ở trên.

Select * from Sales.SalesOrderHeader
Select * from Sales.SalesOrderDetail

Drop table #Top10 -- xóa bảng tạm nếu đã tồn tại
Select Top 10
	a.ProductID ID_sanpham,
	SUM(a.LineTotal) So_tien
	INTO #Top10
From Sales.SalesOrderDetail a inner join Sales.SalesOrderHeader b on b.SalesOrderID=a.SalesOrderID
	 Inner join Production.Product c on a.ProductID=c.ProductID
Where YEAR(b.OrderDate)=2013
Group by a.ProductID
Order by SUM(a.LineTotal) DESC

Select 
	COUNT(Distinct d.SalesOrderID) So_luong
From Sales.SalesOrderHeader d inner join Sales.SalesOrderDetail e on d.SalesOrderID=e.SalesOrderID
Where d.SalesOrderID in (Select d.SalesOrderID from #Top10) 
	  and Year(d.OrderDate)=2013