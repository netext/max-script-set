fn splineknotsel shapesel sub:2 offset:0=
( pointsel
  pointnum
  splinenum
  if offset>=sub then offset=(sub-1) else offset
  if classof shapesel==SplineShape then 
  (
  converttosplineshape shapesel
  clearSelection()
  select shapesel
  subobjectLevel = 1
  splinenum = numsplines shapesel
  for i=1 to splinenum  do 
  ( 
   pointnum=numknots shapesel i

   for j=1 to pointnum do 
    (
    numcol= for k=1 to pointnum by sub collect (k+offset)  
	try (pointsel=setknotselection shapesel i numcol keep:on) catch ()

	)
	)
	
	)
)


fn splinesegsel shapesel sub:2 offset:0=
( segsel
  segn
  splinenum
  if offset>=sub then offset=(sub-1) else offset
  if classof shapesel==SplineShape then 
  (converttosplineshape shapesel
   clearSelection()
   select shapesel
   subobjectLevel = 2
   splinenum = numsplines shapesel
   for i=1 to splinenum  do 
  ( 
   segn=numsegments shapesel i

   for j=1 to segn do 
    (
    numcol= for k=1 to segn by sub collect (k+offset) 
	try (segsel=setsegselection shapesel i numcol keep:on) catch ()

	)
	)
	)

)

rollout selspl "样条线间隔选择器" width:200 height:180
(
	label lbl1 "样条线间隔选点" pos:[35,5] width:100 height:15 enabled:false
	spinner subs "间隔  " pos:[22,45] width:120 height:16 range:[1,10000,2] type:#integer scale:1
	spinner offsets "偏移  " pos:[22,69] width:120 height:16 range:[0,10000,0] type:#integer scale:1
	button selp "选点" pos:[15,100] width:55 height:20
	button selsg "选线段" pos:[85,100] width:55 height:20
	
	label lbl7 "by【3dheima.com】" pos:[9,135] width:120 height:20
	
	
	label lbl8 "2010 07 09" pos:[18,155] width:120 height:20
	on selp pressed do
	(
	splineknotsel $ sub:subs.value offset:offsets.value
	)
	on selsg pressed do
	(
	
		splinesegsel $ sub:subs.value offset:offsets.value
	)
)	ss=newrolloutfloater "" 200 200 
	addrollout selspl ss
	
	
