obj=#()
for i in geometry do
(	
	a=getPolygonCount i ;
	if classof i!= VRayProxy  do (if a[1]==0 then append obj i)
)
if obj.count == 0 
then messagebox"没有空物体点击确定退出" 
else
(	
	messagebox"有空物体点击确定选择空物体";select obj;delete$
)