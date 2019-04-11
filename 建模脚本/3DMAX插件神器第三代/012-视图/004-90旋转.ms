
fn rotatesel =
(
	undo on
	(	
		_arrCanRotate=for i in selection where (not isGroupHead i and not isGroupMember i) collect i  --获取不是组里的物体
		_arrGroups=for i in selection where (isGroupHead i and not isGroupMember i) collect i  --获取最上层的组
		
		join _arrCanRotate _arrGroups;
		
		for i in _arrCanRotate do
		(
			rotangles = eulerangles 0 0 90
			in coordsys grid rotate i rotangles
		)
	)
)
rotatesel()