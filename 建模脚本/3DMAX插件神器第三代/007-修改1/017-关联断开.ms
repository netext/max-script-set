(
if  selection.count !=0 then 
(
	cool_sel =for a in selection collect a
	maxOps.cloneNodes cool_sel cloneType:#copy newNodes:&nnl
	delete cool_sel;select nnl
)else(messageBox "请选择一个或多个物体" title:"Ace提示")
)