--==--==--==--==--==--==--==--==--==--==--==--==--
			--Pillars, ver : 0.1.0
			--A maxscript to create pillars
			--by laohuxiaoqianzi
			--http://www.3dheima.com
--==--==--==--==--==--==--==--==--==--==--==--==--

(
clearlistener()
--delete objects

proll = undefined
isbase = on
iscol = on
istop = on

struct pillar
(
	pilbase1		= undefined,
	maxr 			= 30,
	nsteps 		= 10,
	nsides 		= 8,
	cham 		= 0.0,
	minstep 		= 5,
	maxstep 	= 15,
	minout 		= -5,
	maxout 		= 5,
	fluting 		= 0,
	isdelends 	= off,
	issmooth 	= off,
	zpos 			= #(),
	xpos 			= #(),
	wire			= orange,
	
	fn setparams =
	(
		maxr 			= proll.controls[4].value
		nsteps 		= proll.controls[5].value
		nsides 		= proll.controls[6].value
		cham 		= proll.controls[7].value
		minstep 		= proll.controls[8].value
		maxstep 	= proll.controls[9].value
		minout 		= proll.controls[10].value
		maxout 		= proll.controls[11].value
		fluting 		= proll.controls[12].value
		isdelends 	= proll.controls[13].checked
		issmooth 	= proll.controls[14].checked
	),
	
	fn loadparams =
	(
		proll.controls[4].value = maxr 			 
		proll.controls[5].value = nsteps 		 
		proll.controls[6].value = nsides 		 
		proll.controls[7].value = cham 		 
		proll.controls[8].value = minstep 		 
		proll.controls[9].value = maxstep 	 
		proll.controls[10].value = minout 		 
		proll.controls[11].value = maxout 		 
		proll.controls[12].value = fluting 		 
		proll.controls[13].checked = isdelends 	 
		proll.controls[14].checked = issmooth 	 
	),
	
	fn create =
	(
		with undo off
		(
			setparams()
			try (delete pilbase1)
			catch()
			pilbase1 = undefined

			pilbase1 = Cylinder heightsegs:1 capsegs:1 sides:(2*nsides) height:0 radius:maxr mapcoords:on wirecolor:wire
			converttopoly pilbase1
			npoly = polyop.getnumfaces pilbase1
			polyop.setfaceSelection pilbase1 #{npoly}

			--fluting
			if fluting>0 then
			(
				nv = polyop.getnumverts pilbase1
				anv = #{1..nv} as array
				for a=anv.count to 1 by -2 do deleteItem anv a
				polyop.setvertSelection pilbase1 (anv)
				for v=1 to anv.count do
				(
					pv = polyop.getvert pilbase1 anv[v]
					ndiff = normalize [pv.x,pv.y,0]
					nmat = matrixFromNormal ndiff 
					in coordsys nmat (polyop.moveVert pilbase1 anv[v] [0,0,fluting])
				)
				
			)
			
			if nsteps>zpos.count then
			(
				for s=zpos.count+1 to nsteps do 
				(
					zpos[s] = random minstep maxstep
				)
			)
			--print this
			
			if nsteps>xpos.count then
			(
				for s=xpos.count+1 to nsteps do 
				(
					xpos[s] = random minout maxout
					if s==1 then xpos[s] = 0
				)
			)

			for s=1 to nsteps do
			(
				polyop.bevelFaces pilbase1 #{npoly} zpos[s] xpos[s]
				if cham>0.0 then
				(
					elist = polyop.getEdgesUsingFace pilbase1 #{npoly}
					polyop.chamferEdges pilbase1 elist cham
				)
			)
			
			if not isdelends then polyop.deleteFaces pilbase1 #{npoly-1,npoly}
			else 
			(
				polyop.extrudeFaces pilbase1 #{npoly} 0
				polyop.collapseFaces pilbase1 #{npoly-1,npoly}
			)
			
			if issmooth then
			(
				addmodifier pilbase1 (smooth autosmooth:on threshold:30.0)
				collapsestack pilbase1
			)
		)
		
	),
	
	fn setpos ppos =
	(
		if pilbase1 !=undefined then pilbase1.pos = [0,0,ppos]
	),
	
	fn setpreset parr =
	(
		maxr 			= parr[1]
		nsteps 		= parr[2]
		nsides 		= parr[3]
		cham 		= parr[4]
		minstep 		= parr[5]
		maxstep 	= parr[6]
		minout 		= parr[7]
		maxout 		= parr[8]
		fluting 		= parr[9]
		isdelends 	= parr[10]
		issmooth 	= parr[11]
		loadparams()
	)
	

)--struct pillar


base = pillar()
column = pillar()
top = pillar()

fn updatepillar =
(			
	if isbase then base.create()
	if iscol	then column.create()
	if base.pilbase1 !=undefined then column.setpos base.pilbase1.max.z
	if istop 	then top.create()
	if column.pilbase1 !=undefined then top.setpos column.pilbase1.max.z
)

fn init =
(
	if isbase then base.zpos = #(); base.xpos = #()
	if iscol then column.zpos = #(); column.xpos = #()
	if istop then top.zpos = #(); top.xpos = #()
	updatepillar()
)

fn collapsepillar =
(
	if base.pilbase1==undefined then return 0
	ep = converttopoly (Editable_Mesh())
	polyop.attach ep base.pilbase1 
	polyop.attach ep column.pilbase1
	polyop.attach ep top.pilbase1
	addmodifier ep (uvwmap maptype:1)
	collapsestack ep
	ep.name = uniquename "Pillar"
	ep.wirecolor = red/2
	base.pilbase1 = undefined
	column.pilbase1 = undefined
	top.pilbase1 = undefined
)

fn loadpreset npre =
(
	base.zpos = #()
	base.xpos = #()
	column.zpos = #()
	column.xpos = #()
	top.zpos = #()
	top.xpos = #()
	barr = #()
	carr = #()
	tarr = #()
	
	if npre==1 then
	(
		barr = #(45,8,3,0,2,10,-5,5,0,on,off)
		carr = #(25,1,16,0,200,400,-5,5,0,on,on)
		tarr = #(50,3,2,0,5,15,-15,15,0,on,off)
	)
	if npre==2 then
	(
		barr = #(60,8,4,1,2,30,-10,5,0,on,off)
		carr = #(25,1,16,0,200,400,-5,5,2,on,on)
		tarr = #(70,4,2,0,5,15,-15,15,0,on,off)
	)
	if npre==3 then
	(
		barr = #(70,8,3,0,2,30,-10,2,0,on,off)
		carr = #(25,12,3,0,0,50,-5,5,0,off,off)
		tarr = #(40,5,3,0,5,15,-15,15,0,on,off)
	)
	if npre==4 then
	(
		barr = #(60,8,3,0,2,30,-10,2,0,on,off)
		carr = #(45,12,16,0,0,15,0,20,0,on,on)
		tarr = #(24,12,10,0,5,15,-15,15,0,on,off)
	)
	if npre>4 then
	(
		messagebox "No such preset is defined !"
		return 0
	)
		
		base.setpreset barr
		base.create()
		column.setpreset carr
		column.create()
		if base.pilbase1 !=undefined then column.setpos base.pilbase1.max.z
		top.setpreset tarr
		top.create()
		if column.pilbase1 !=undefined then top.setpos column.pilbase1.max.z

		istop = on
		iscol = off
		isbase = off
		proll.controls[3].checked = on
		proll.controls[2].checked = off
		proll.controls[1].checked = off
)

rollout ppre "Presets"
(
	dropdownlist predd "" width:150  height:200 items:#("Simple", "Fluted", "Temple", "Fountain") 
	
	on predd selected p do loadpreset p
)

rollout proll "Pillars 0.1.0" width:180 height:410
(
	checkButton ckb_base "Base" pos:[8,8] width:50 height:20 checked:true
	checkButton ckb_col "Column" pos:[64,8] width:50 height:20
	checkButton ckb_top "Top" pos:[120,8] width:50 height:20
	
	spinner spn_maxr "" pos:[90,40] width:80 height:16 range:[0,1e+006,30] type:#float
	spinner spn_steps "" pos:[90,70] width:80 height:16 range:[0,1000,10] type:#integer scale:1
	spinner spn_sides "" pos:[90,100] width:80 height:16 range:[2,100,8] type:#integer scale:1
	spinner spn_cham "" pos:[90,130] width:80 height:16 range:[0.0,1000.0,0.0] type:#float scale:0.01
	spinner spn_minstep "" pos:[90,160] width:80 height:16 range:[0,10000,5]
	spinner spn_maxstep "" pos:[90,190] width:80 height:16 range:[0,10000,15] type:#float
	spinner spn_minout "" pos:[90,220] width:80 height:16 range:[-10000,10000,-5]
	spinner spn_maxout "" pos:[90,250] width:80 height:16 range:[0,10000,5]
	spinner spn_fluting "" pos:[90,280] width:80 height:16 range:[0.0,10000.0,0.0] type:#float scale:0.01
	
	checkbox chk_ecaps "End Caps" pos:[10,310] width:80 height:20 checked:on
	checkbox chk_sm "Smooth" pos:[90,310] width:80 height:20
	
	label lbl1 "Radius" pos:[10,40] width:75 height:16
	label lbl2 "Steps" pos:[10,70] width:75 height:16
	label lbl3 "Sides x 2" pos:[10,100] width:75 height:16
	label lbl4 "Chamfer" pos:[10,130] width:75 height:16
	label lbl5 "Min Step Size" pos:[10,160] width:75 height:16
	label lbl6 "Max Step Size" pos:[10,190] width:75 height:16
	label lbl7 "Min Outline" pos:[10,220] width:75 height:16
	label lbl8 "Max Outline" pos:[10,250] width:75 height:16
	label lbl9 "Fluting" pos:[10,280] width:75 height:16
	
	button btn_newseed "New" pos:[10,340] width:160 height:20
	button btn_commit "Commit" pos:[10,370] width:160 height:20
	
	
	on proll open do loadpreset 1
	
	on ckb_base changed state do
	(
		isbase = ckb_base.checked
		if isbase then
		(
			ckb_col.checked = off
			ckb_top.checked = off
			iscol = off
			istop = off
			base.loadparams()
		)
	)
	on ckb_col changed state do
	(
		iscol= ckb_col.checked
		if iscol then
		(
			ckb_base.checked = off
			ckb_top.checked = off
			isbase = off
			istop = off
			column.loadparams()
		)
	)
	on ckb_top changed state do
	(
		istop= ckb_top.checked
		if istop then
		(
			iscol = off
			isbase = off
			ckb_col.checked = off
			ckb_base.checked = off
			top.loadparams()
		)
	)

	on spn_maxr changed 		val do updatepillar()
	on spn_steps changed 		val do updatepillar()
	on spn_sides changed 		val do updatepillar()
	on spn_minstep changed 	val do init()
	on spn_maxstep changed 	val do init()
	on spn_minout changed 	val do init()
	on spn_maxout changed 	val do init()
	on spn_fluting changed 	val do updatepillar()
	on spn_cham changed 		val do updatepillar()
	on chk_sm changed state 	do updatepillar()
	on chk_ecaps changed state do	updatepillar()
	on btn_commit pressed  		do collapsepillar()
	on btn_newseed pressed  		do init()
)

rollout phelp "Help & About" width:162 height:89
(
	HyperLink hlink1 "Online Help" pos:[65,10] width:55 height:15 address:"http://www.3dheima.com/" color:(color 0 255 0)
	label lab1 "Pillars by 3dheima.com " pos:[40,32] width:119 height:13
	HyperLink hlink2 "QQ:363613301" pos:[72,48] width:16 height:15 address:"http://www.3dheima.com/" color:(color 255 255 0)
 
 
	HyperLink hlink3 "SUCAI@3Dheima.com" pos:[28,70] width:98 height:15 address:"www.3dheima.com" color:(color 255 127.5 0)
)

rollout promos "Promotions" width:162 height:100
(
	HyperLink hlink1 "Pillars for free" pos:[25,6] width:63 height:15 address:"http://www.3dheima.com/" color:(color 0 255 0)
	HyperLink hlink2 "Fracture Voronoi Script" pos:[10,25] width:108 height:15 address:"http://www.3dheima.com/" color:(color 255 127.5 0)
	HyperLink hlink3 "Pillars Script" pos:[34,45] width:57 height:15 address:"http://www.3dheima.com/" color:(color 255 255 0)
)

rollout breakpil "Break" width:180 height:300
(
	pickButton btn_pick "Pick Pillar" pos:[10,20] width:160 height:20
	label lbl1 "Size" pos:[10,60] width:65 height:20
	spinner spn_sz "" pos:[90,60] width:80 height:16 range:[0,10000,200]
	label lbl2 "Detail" pos:[10,90] width:65 height:20
	spinner spn_det "" pos:[90,90] width:80 height:16 range:[0,10000,40] type:#integer scale:1
	label lbl3 "Angle" pos:[10,120] width:65 height:20
	spinner spn_ang "" pos:[90,120] width:80 height:16 range:[0,360,45] scale:5
	label lbl4 "Roughness" pos:[10,150] width:65 height:20
	spinner spn_rough "" pos:[90,150] width:80 height:16 range:[0,10000,40]
	label lbl5 "Position" pos:[10,180] width:65 height:20
	spinner spn_pos "" pos:[90,180] width:80 height:16 range:[0.0,1.0,0.5] type:#float scale:0.01
	button btn_brk "Break" pos:[10,210] width:160 height:20
	button btn_rev "Revert" pos:[10,240] width:160 height:20
	button btn_com "Commit" pos:[10,270] width:160 height:20
	
	local pil=undefined
	local pilc=undefined
	
	on btn_pick picked obj do
	(
		pil = obj
		btn_pick.text = pil.name
	)

	on btn_brk pressed do
	(
		if pil != undefined then (if isdeleted pil then pil=undefined)
		if pil != undefined then
		(
			if pilc !=undefined then (if isdeleted pilc then pilc=undefined)
			pilc = copy pil
			pilc.wirecolor = pil.wirecolor
			hide pil
			
			w=spn_sz.value
			nw=spn_det.value
			ang=spn_ang.value
			n=spn_rough.value

			brk=box width:w height:20 length:w lengthsegs:nw widthsegs:nw heightsegs:1
			brk.renderable = off
			brk.pos=[pil.center.x, pil.center.y, pil.max.z * spn_pos.value] 
			rotate brk (angleaxis ang [1,0,0])
			addmodifier brk (Noisemodifier fractal:on iterations:10 strength:[n,n,n] scale:100 seed:(random 0 100))
			ProBoolean.CreateBooleanObject pilc brk 2 2 1 
			try (delete brk)
			catch()
		)
	)
	
	on btn_rev pressed do
	(
		if pil != undefined then
		(
			if pilc !=undefined then delete pilc
			unhide pil
		)
	)
	
	on btn_com pressed do
	(
		if pil != undefined then
		(
			nam = pil.name
			if pilc !=undefined then
			(
				delete pil
				pil = undefined
				btn_pick.text = "Pick Pillar"
				converttopoly pilc
				pilc.name = nam
			)
		)
	)

)


rf = newrolloutfloater "Pillars" 200 600
addrollout proll rf rolledup: off
addrollout ppre rf rolledup: off
addrollout breakpil rf rolledup: off
addrollout phelp rf rolledup: on
addrollout promos rf rolledup: on
)