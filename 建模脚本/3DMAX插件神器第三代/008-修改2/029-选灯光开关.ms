global facenum
global vertnum
global tolfacenum
global tolvtnum
global biggroup 
global objectsel=#()   --定义操作物体的范围


--选择的物体点面数
fn v_f_num sel:selection=(
facenum=0
vertnum=0
polynum=#()
for i in sel do 
(polynum=(try getpolygoncount i catch polynum=())
 facenum=facenum+polynum[1]
 vertnum=vertnum+polynum[2]
 ) 
 vertnum
 facenum
)


--全部物体的点面数
fn tolv_f_num=(
tolfacenum=0
tolvtnum=0
polynum=#()
for i in objects do 
(polynum=(try getpolygoncount i catch polynum=())
 tolfacenum=tolfacenum+polynum[1]
 tolvtnum=tolvtnum+polynum[2]
 ) 
 vertnum
 facenum
)





rollout NUMcount "点面统计" width:162 height:500
(
	GroupBox grp1 "点面数" pos:[5,12] width:152 height:114
	spinner fac "面数" pos:[20,55] width:122 height:16 enabled:false range:[0,1e+099,0] scale:1
	spinner vet "点数" pos:[20,35] width:122 height:16 enabled:false range:[0,1e+099,0] scale:1
	button btn1 "刷新" pos:[20,130] width:110 height:20

	spinner tolvet "总点数" pos:[20,80] width:122 height:16 enabled:false range:[0,1e+099,0] scale:1
	spinner tolfac "总面数" pos:[20,100] width:122 height:16 enabled:false range:[0,1e+099,0] scale:1
	
	
	on NUMcount open  do
( vertnum=0
	  facenum=0
	  tolvtnum=0
	  tolfacenum=0
	  v_f_num()
	  tolv_f_num()
	  fac.value=facenum
	  vet.value=vertnum
	  tolvet.value=tolvtnum
	  tolfac.value=tolfacenum
	
	)
	on btn1 pressed do
	( vertnum=0
	  facenum=0
	  tolvtnum=0
	  tolfacenum=0
	  v_f_num()
	  tolv_f_num()
	  fac.value=facenum
	  vet.value=vertnum
	  tolvet.value=tolvtnum
	  tolfac.value=tolfacenum
	)
)





rollout dis_op "选择、优化显示" width:162 height:300
(
	spinner maxface "面数阀值" pos:[10,32] width:150 height:16 range:[0,1e+013,1000] type:#float scale:1
	button sel01 "选择小于阀值" pos:[20,76] width:120 height:18 enabled:true
	button sel02 "选择大于阀值" pos:[20,56] width:120 height:18 enabled:true
	button disopt "大于阀值显示为BOX" pos:[20,98] width:120 height:18 enabled:true
	button disres "恢复box为实体显示" pos:[20,119] width:120 height:18 enabled:true toolTip:""
	
	
	spinner vrtxnums "点数阀值" pos:[10,145] width:150 height:16 range:[0,1e+013,1000] type:#float scale:1
	button btn6 "选择大于阀值" pos:[20,165] width:120 height:18 enabled:true
	button btn7 "选择小于阀值" pos:[20,185] width:120 height:18 enabled:true
	checkbox gbop "对全部物体操作" pos:[3,12] width:145 height:15 checked:true


	on sel01 pressed do
	(
	objectsel=(if gbop.state==on then (geometry as array) else ($selection as array))

	clearSelection()
	
	simgroup=for i in objectsel where (getpolygoncount i)[1]<(maxface.value) collect i
	select simgroup
	
	)
	on sel02 pressed do
	(
	objectsel=(if gbop.state==on then (geometry as array) else ($selection as array))

	
	clearSelection()
	
	biggroup=for i in objectsel where (getpolygoncount i)[1]>=(maxface.value) collect i
	select biggroup
	
	)
	on disopt pressed do
	(
	global opgroup=#()
	
	objectsel=(if gbop.state==on then (geometry as array) else ($selection as array))

	
	clearSelection()

	
	opgroup=for i in objectsel where (getpolygoncount i)[1]>=(maxface.value) collect i
	for i in opgroup do try i.boxmode=true catch ()
	)
	on disres pressed do
	(
	for i in opgroup do try i.boxmode=false catch ()
	opgroup=#()
	)
	on btn6 pressed do
	(
	objectsel=(if gbop.state==on then (geometry as array) else ($selection as array))

	clearSelection()
	
	biggroup=for i in objectsel where (getpolygoncount i)[2]>=(vrtxnums.value) collect i
	select biggroup
	
	)
	on btn7 pressed do
	(
	objectsel=(if gbop.state==on then (geometry as array) else ($selection as array))
	clearSelection()
	minGroup=for i in objectsel where (getpolygoncount i)[2]<(vrtxnums.value) collect i
	select mingroup
	)
	
)


rollout byme "by 3d狼设计网 ,for max9" width:162 height:80
(
	label lbl1 "修改于2010.7.12" pos:[10,26] width:148 height:17 enabled:false
	label lbl3 "修改一个出错bug" pos:[10,2] width:148 height:17 enabled:false
)





numfloater=newrolloutfloater "物体选择器" 200 400
addrollout NUMcount numfloater
addrollout dis_op numfloater
addrollout byme numfloater

