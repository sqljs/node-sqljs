SELECT
	p.productId as productId,
	p.name as name,
	p.EANproduct as EANproduct,
	p.EANpackage as EANpackage,
	SUM(
		IF(sm.state = 'done',
		IF(sm.storeIdTo = '1',
		sm.quantity,
		IF(sm.storeIdFrom = '1', - sm.quantity, 0)
		), 0)
	) as total,
	SUM(
		IF(sm.state = 'reserved',
		IF(sm.storeIdTo = '1', sm.quantity, 0),
		0)
	) as ordered,
	SUM(
		IF(sm.state = 'reserved',
		IF(sm.storeIdFrom = '1', sm.quantity, 0),
		0)
	) as reserved
FROM `storeMovements` sm
LEFT OUTER JOIN `products` p ON sm.`productId` = p.`productId`
WHERE ((sm.storeIdFrom = '1') OR (sm.storeIdTo = '1'))
GROUP BY p.productId, p.name, p.EANproduct, p.EANpackage
ORDER BY p.productId
