
global frraa

rollout 查看版本 "旋转平行" width:226 height:135
(
	button st " 转水平 " pos:[10,30] width:202 height:35 
	button tg " 与选择平行 " pos:[10,79] width:202 height:38 

	on st pressed do
	(
	local pp1,pp,pp2,p1,p2,b,ddd,c,e,eea,aaa
	 pp1=pickpoint prompt:"\n" snap:#3d 
	if classOf pp1== Point3   do pp=pickpoint prompt:"\n" snap:#3d rubberBand:pp1
	if classof pp1==point3 and classof pp==point3 then
	(
	c=rectangle()
	c.width=(distance pp1 pp)
	c.length=0
	c.pos=[pp.x-c.width/2,pp.y,pp.z]
	sbs=#()
	for nnm in selection do
	(
	if (isgrouphead nnm)==false do append sbs nnm
	)
	sbs.pivot=pp
	aaa=acos((Pp.X-Pp1.X)/(distance pp1 pp))
	if aaa<0 do aaa+=180
	if pp.y>pp1.y then in coordsys screen ROTATE sbs (eulerangles 0 0 -aaa) else in coordsys screen ROTATE sbs (eulerangles 0 0 aaa)
	c.pivot=pp
	if pp.y>pp1.y then in coordsys screen ROTATE c (eulerangles 0 0 aaa) else in coordsys screen ROTATE c (eulerangles 0 0 -aaa)
	addmodifier c (extrude())
	c.extrude.amount=0
	)
	)
	on tg pressed do
	(
	
	local pp1,pp,pp2,p1,p2,b,ddd,c,e,eea,aaa
	pp1=pickpoint prompt:"\n" snap:#3d 
	if classOf pp1 == Point3   do pp=pickpoint prompt:"\n" snap:#3d rubberBand:pp1
	if classof pp1==point3 and classof pp==point3 then
	(
	sbs=#()
	for nnm in selection do
	(
	if (isgrouphead nnm)==false do append sbs nnm
	)
	sbs.pivot=pp
	aaa=acos((Pp.X-Pp1.X)/(distance pp1 pp))
	if aaa<0 do aaa+=180
	if pp.y>pp1.y then in coordsys screen ROTATE sbs (eulerangles 0 0 aaa) else in coordsys screen ROTATE sbs (eulerangles 0 0 -aaa)
	)
	)
)
createdialog 查看版本 style:#(#style_minimizebox, #style_titlebar, #style_sysmenu)






