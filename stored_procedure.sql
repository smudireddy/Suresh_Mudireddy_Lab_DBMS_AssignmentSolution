CREATE DEFINER=`root`@`localhost` PROCEDURE `DisplaySupplierRatingsAndTypeOfService`()
BEGIN
   select s.supp_id 'Supplier ID', s.supp_name 'Supplier Name', r.rat_ratstars 'Rating', 
   CASE
		when r.rat_ratstars = 5 then 'Excellent Service'
		when r.rat_ratstars > 4 then 'Good Service'
		when r.rat_ratstars > 2 then 'Average Service'
		else 'Poor Service'
    END as 'Type_of_Service'
    from rating r inner join orders o on (o.ord_id = r.ord_id)
    inner join supplier_pricing sp on (sp.pricing_id = o.pricing_id) 
    inner join supplier s on(s.supp_id = sp.supp_id);
END