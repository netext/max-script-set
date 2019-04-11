try destroydialog ymld catch()
rollout ymld "黑马线条同向 V0.5"
( 	
	local zyline,sp = #()
	---
	button getspl "加 入 待 处 理 线 条" pos:[5,5] width:190 height:40
	groupbox gba "" pos:[0,45] width:200
	radiobuttons nos "" labels:#("顺时针方向","逆时针方向") pos:[15,55]
	button doit "开 始 处 理" pos:[5,80] width:190 height:50
	--
	hyperlink hla "注意：仅对样条线中的封闭线条有效" color:red pos:[5,135] enabled:FALSE
	button findno "找到样条线中不封闭的线条"  pos:[5,155] width:190 height:18
	-----
	activeXControl ax "http://www.3dheima.com" align:#left  height:20 pos:[0,180] width:200
	-----
	on getspl pressed do if selection.count == 1 and (classof $ == line or classof $ == splineshape) then
	(
		zyline = $
		getspl.caption = "已选到线条 " + zyline.name
	)else(messagebox "你是故意的吗？你 (选择) 的根本就不是 (一条) (可编辑样条线)" title:"黑马提示：" beep:off)
	-----
	on doit pressed do
	(
				 
		numsp = numsplines zyline 
		sp=#()
		if numsp > 1 then
		( 
			for i in 1 to numsp do 
			( 	
				tempS = splineShape pos:(getKnotPoint zyline i 1)
				addNewSpline tempS 
				for k in 1 to numKnots zyline i do 
				addKnot tempS 1 (getKnotType zyline i k) #curve (getKnotPoint zyline i k) (getInVec zyline i k) (getOutVec zyline i k)
				if isclosed zyline i then close tempS 1 
				updateShape tempS
				if isClosed temps 1 then
					(
						applyoffset temps 20
						aa1 = curveLength temps 1
						aa2 = curvelength temps 2
						if nos.state == 1 then 
						(
							if aa1 >= aa2 do reverse zyline i
						)else
						(
							if aa1 <= aa2 do reverse zyline i
						)
					)
				--
				append sp tempS
			) 
		) 
		delete sp 
	)
-------
	on findno pressed do if selection.count == 1 and (classof $ == line or classof $ == splineshape) then
	(
	nono = #()
	numsp2 = numsplines $
	for j in 1 to numsp2 do
	(
		if isclosed $ j != true then append nono j
	)
	max modify mode
	subobjectLevel = 3
	setSplineSelection $ nono
	
	)else(messagebox "你是故意的吗？你 (选择) 的根本就不是 (一条) (可编辑样条线)" title:"云梦提示：" beep:off)
)
createdialog ymld 200 200