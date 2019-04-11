fn units_setup = 
(
	case units.SystemType of -- 获取当前单位系统名称
	(
		#inches:(global unitsval=0.03937;global unit="in")   ---英寸
		#feet:(global  unitsval=0.003280;global unit="ft")    ---英尺
		#miles:(global  unitsval=1000.0;global unit="μm")     ---微米
		#millimeters:(global  unitsval=1.0;global unit="mm")  ---毫米
		#centimeters:(global  unitsval=0.1;global unit="cm")  ---厘米
		#meters:(global  unitsval=0.001;global unit="m")     ---米
		#kilometers:(global  unitsval=0.000001;global unit="km")---千米
		default:(global unitsval=1.0;global unit="毫米")     ---毫米
	)		
)
units_setup()
try(destroydialog spli_refine) catch()
rollout spli_refine "线条细分【黑马设计网】出品" width:200 height:95 
(
	radiobuttons radbts ""  height:20 labels:#("细分间距    ", "细分段数 ") default:1 columns:2
	checkbox chck_1 ""  width:30 height:15 toolTip:"保留转折点" Offset:[168,-23]
	spinner spi_1 "细分间距:" fieldwidth:60 range:[10*unitsval,100000*unitsval,1000*unitsval]  Offset:[60,0] across:2
	hyperlink lab1 "mm"  color:(color 200 0 0) Offset:[65,0]	enabled:false
	spinner spi_2 "细分段数:" fieldwidth:60 range:[2,1000,10] type:#integer Offset:[-27,-21] visible:false
	checkbox chck_s "Smooth" height:15 Offset:[30,0] checked:true across:2 
	checkbox chck_c "Corner" height:15 Offset:[15,0]
	button btn_ok  "确定" width:130  Offset:[30,0] across:2 
	checkbox chck_del "del" height:15 Offset:[60,5]  checked:true
	
local newsplie
	
fn 	setjianju val = (
		num_count = numsplines $
		newsplie = SplineShape()
	for n = 1 to num_count do (
		leng = curvelength $ n
		duan = leng/val	-- 计算最少段数 
		duan_1 = (dotNetObject "System.Single" duan).toString "0.0" as float
		duan = (dotNetObject "System.Single" duan_1).toString "0" as integer -- 精确到 后一位数值	
		xxx = 1.0/duan
		new_p = 0.0
		addNewSpline newsplie
		if chck_s.checked then addKnot newsplie n #smooth #curve (getKnotPoint $ n 1) else addKnot newsplie n #corner #curve (getKnotPoint $ n 1)
		for s = 1 to duan do (
			new_p += xxx
			pos = (interpCurve3D $ n new_p)
			if chck_s.checked then addKnot newsplie n #smooth #curve pos else addKnot newsplie n #corner #curve pos
		)
		if isClosed $ n then (deleteKnot newsplie n (numKnots newsplie n );close newsplie n)
	)
	updateShape newsplie
)
fn 	setjianju_Corner val = (
	num_count = numsplines $
	newsplie = SplineShape() 
	for n = 1 to num_count do (
		local new_p = vvv = 0.0
		get_num = numsegments $ n  -- 线条 段数
		get_leng = getSegLengths $ n   -- 获取每段 比例 和 长度
		addNewSpline newsplie
		if chck_s.checked then addKnot newsplie n #smooth #curve (getKnotPoint $ n 1) else addKnot newsplie n #corner #curve (getKnotPoint $ n 1)
		for i = 1 to get_num do (
			num = get_num+i
			sss = get_leng[i]
			vvv+= sss
			leng = get_leng[num]
			duan = leng/val	-- 计算最少段数 
			duan_1 = (dotNetObject "System.Single" duan).toString "0.0" as float
			duan = (dotNetObject "System.Single" duan_1).toString "0" as integer -- 精确到 后一位数值
			xxx = sss/duan
			for s = 1 to duan do (
				new_p += xxx
				pos = (interpCurve3D $ n new_p)
				if chck_s.checked then addKnot newsplie n #smooth #curve pos else addKnot newsplie n #corner #curve pos
			)
			new_p = vvv
		)
		if isClosed $ n then (deleteKnot newsplie n (numKnots newsplie n );close newsplie n)
	)
	updateShape newsplie 
)
fn 	setduanshu val = (
	num_count = numsplines $
	newsplie = SplineShape()
	for n = 1 to num_count do (
		xxx = 1.0/val
		addNewSpline newsplie
		for p = 0.0 to (xxx*(val+1)) by xxx do (
			pos = (interpCurve3D $ n p)
			if chck_s.checked then addKnot newsplie n #smooth #curve pos else addKnot newsplie n #corner #curve pos
		)
		if isClosed $ n then (deleteKnot newsplie n (numKnots newsplie n );close newsplie n)
		updateShape newsplie
	)
)
fn 	setduanshu_Corner val = (
	num_count = numsplines $
	newsplie = SplineShape() 
	for n = 1 to num_count do (
		local new_p = vvv = 0.0
		get_num = numsegments $ n  -- 线条 段数
		get_leng = getSegLengths $ n   -- 获取每段 比例 和 长度
		addNewSpline newsplie
		if chck_s.checked then addKnot newsplie n #smooth #curve (getKnotPoint $ n 1) else addKnot newsplie n #corner #curve (getKnotPoint $ n 1)
		for i = 1 to get_num do (
			sss = get_leng[i]
			vvv+= sss
			xxx = sss/val
			for s = 1 to val do (
				new_p += xxx
				pos = (interpCurve3D $ n new_p)
				if chck_s.checked then addKnot newsplie n #smooth #curve pos else addKnot newsplie n #corner #curve pos
			)
			new_p = vvv
		)
		if isClosed $ n then (deleteKnot newsplie n (numKnots newsplie n );close newsplie n)
	)
	updateShape newsplie
)

on spli_refine open do lab1.text = unit

on radbts changed state do(			
	if radbts.state == 1 then ( spi_2.visible = false ; spi_1.visible = lab1.visible = true )
	else (	spi_1.visible = lab1.visible = false ; spi_2.visible = true	)
)
on chck_s changed state do	if state then chck_c.checked = false else chck_c.checked = true
on chck_c changed state do	if state then chck_s.checked = false else chck_s.checked = true

on btn_ok pressed do undo on (
	if classOf $ == SplineShape or classof $ == line then (
		if radbts.state == 1 then (
			if chck_1.checked then setjianju_Corner spi_1.value else setjianju spi_1.value
		)else if chck_1.checked then setduanshu_Corner spi_2.value else setduanshu spi_2.value
		if chck_del.checked then (delete $);select newsplie ; max modify mode ; subObjectLevel = 1
	) else messageBox "操作错误" title:"Ace提示"
)
)
createDialog spli_refine style:#(#style_toolwindow,#style_sysmenu)