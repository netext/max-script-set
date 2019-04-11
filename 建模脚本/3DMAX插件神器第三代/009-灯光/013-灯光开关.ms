

--关灯
fn closelight lightselection:#()=
    (
     for i in lightselection do
	 (
	  try i.on=false catch()
	  try i.enable=false catch()
	  )
	 )


--开灯
fn openlight lightselection:#()=
    (
     for i in lightselection do
	 (
	  try i.on=true catch()
	  try i.enable=true catch()
	  )
	 )
	 
--选择场景中的VR灯光
fn collectvrlight =
    (
     vrlight=(for i in lights where (classof i==VRayLight) collect i)
	 select vrlight
	 )


--选择IES灯光
fn collectIESlight =
    (
    IESlight=(for i in lights where 
      (classof i==Target_Point) or (classof i==Free_Point)
        collect i
		)
	 select IESlight
    )

--选择omni灯光
fn collectomnilight =
    (
    omlight=(for i in lights where (classof i==Omnilight)
        collect i
		)
	 select omlight
    )
	
--选择泛光灯
fn collectSpotlight =
    (
    Spotlight=(for i in lights where 
      (classof i==targetSpot) or (classof i==freeSpot)
        collect i
		)
	 select Spotlight
    )
	
--选择平行灯光
fn collectDirectionallight =
    (
    Dirlight=(for i in lights where 
      (classof i==TargetDirectionallight) or (classof i==Directionallight)
        collect i
		)
	 select Dirlight
    )
	
lig_op=newrolloutfloater "灯光开关选择控制" 200 200

rollout light_op "灯光开关" width:200 height:60
(
	button btn1 "关闭选择灯光" pos:[5,10] width:90 height:25
	button btn2 "开启选择灯光" pos:[100,9] width:90 height:25
	button btn3 "关闭所有灯光" pos:[5,35] width:90 height:25
	button btn4 "开启所有灯光" pos:[100,35] width:90 height:25
      on btn1 pressed do 
	 ( closelight lightselection:selection
	 )
	 on btn2 pressed do 
	 ( openlight lightselection:selection
	 )
      on btn3 pressed do 
	 ( closelight lightselection:lights
	 )
	 on btn4 pressed do 
	 ( openlight lightselection:lights
	 ) 
)

rollout selectlight "选择灯光" width:200 height:124
(
	button sel_lg01 "选择VR灯光" pos:[5,10] width:90 height:20
	button sel_lg02 "选择IES灯光" pos:[100,10] width:90 height:20
	button sel_lg03 "选择omni灯光" pos:[5,40] width:90 height:20
	button sel_lg04 "选择泛光灯" pos:[100,40] width:90 height:20
	button sel_lg05 "选择平行光" pos:[5,70] width:90 height:20
	button sel_lg06 "选择所有灯光" pos:[100,70] width:90 height:20
     
	on sel_lg01 pressed do collectvrlight()
	on sel_lg02 pressed do collectIESlight()
	on sel_lg03 pressed do collectomnilight()
	on sel_lg04 pressed do collectSpotlight()
	on sel_lg05 pressed do collectDirectionallight()
	on sel_lg06 pressed do select lights
)
rollout ty "......" width:200 height:20
(
	label lbl1 "for max9           BY：windowxu" pos:[10,5] width:200 height:15
)

addrollout light_op lig_op 
addrollout  selectlight lig_op
addrollout  ty lig_op

