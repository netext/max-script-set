try(Destroydialog Poly_bianzhi)catch()
rollout Poly_bianzhi "Ploy网格编织【黑马设计网】出品" width:230 height:90
(
	spinner spi_1 "编织宽度: "  fieldwidth:55 range:[1,9999999,200] across:2  Offset:[10,0] type:#worldunits
	spinner spi_2 "Push: "  fieldwidth:55	range:[1,9999999,100]	 Offset:[10,0] type:#worldunits
	button btn_ok "确   认   编   织"   width:150 height:30	Offset:[25,0] across:2
	checkbox chb_l "修正" width:100 Offset:[60,10]
	progressBar prgsbra "ProgressBar"  width:220 height:10  align:#center	
	HyperLink  lb2	"_____【黑马设计网】出品_____"  color:(color 100 0 0) address:"http://www.3dheima.com" align:#center 

fn openedge obj = (
	trues = false ; edges = #();vser = #()
	edgearry = polyop.getOpenEdges obj
	for i in edgearry do (
		vvv = polyop.getvertsUsingedge obj i
		for s in vvv do (
			count = ((polyop.getfacesUsingvert obj s)as array).count
			if count == 1 do (append vser s;exit)
		)
		if vser.count != 0 then (
			for ee in (polyop.getedgesUsingvert obj vser) do append edges ee
			exit
		)
	)
	edges
)

fn polyLoop_inter obj inter=(
	last_edges = #()
	sel_edges=(polyop.getEdgeSelection obj)as array
	for n in 1 to sel_edges.count do (
		polyop.setedgeselection obj sel_edges[n]
		Loop_Ed1 =	(polyop.getEdgeSelection obj)as array
		(
		ar_edges = #(((polyop.getEdgeSelection obj)as array)[1])
		end=false
		num=1
		while end!=true do (
		edge_start=(polyop.getEdgeSelection obj)as array
		obj.setLoopShift inter true false	
		edge_end=(polyop.getEdgeSelection obj)as array
		if edge_start[1]!=edge_end[1] then (
		num+=1
		append ar_edges  edge_end[1]
		if edge_end[1] == ar_edges[1] then exit		
			)

		else (
		polyop.setEdgeSelection obj #(ar_edges[ar_edges.count])	
		obj.setLoopShift -inter true false
		if num>1 then  (if 	((polyop.getEdgeSelection obj)as array)[1]!=ar_edges[ar_edges.count-1] then deleteitem ar_edges ar_edges.count )
			exit
		)
		)
		polyop.setEdgeSelection obj #(ar_edges[1])
		end=false
		num=1
		while end!=true do (
		edge_start=(polyop.getEdgeSelection obj)as array
		obj.setLoopShift -inter true false	
		edge_end=(polyop.getEdgeSelection obj)as array

		if edge_start[1]!=edge_end[1] then (
			num+=1
			 append ar_edges  edge_end[1]
		if edge_end[1] == ar_edges[1] then exit		
			)
		else (
		polyop.setEdgeSelection obj #(ar_edges[ar_edges.count])	
		obj.setLoopShift inter true false	
		if num>1 then  (if 	((polyop.getEdgeSelection obj)as array)[1]!=ar_edges[ar_edges.count-1] then deleteitem ar_edges ar_edges.count )
			exit
		)
		)
		)
		join last_edges ar_edges
	)
	last_edges
)

fn polyring_inter obj inter =(
last_edges = #()
sel_edges=(polyop.getEdgeSelection obj)as array
for n in 1 to sel_edges.count do (
	--nvnv = finditem rigs_arry ee
	prgsbra.value =(90*n/sel_edges.count)+10
	polyop.setedgeselection obj sel_edges[n]
	Ring_Ed1 =	(polyop.getEdgeSelection obj)as array
	(
	ar_edges = #(((polyop.getEdgeSelection obj)as array)[1])
	end=false
	num=1
	while end!=true do (
		edge_start=(polyop.getEdgeSelection obj)as array
		obj.setRingShift inter true false	
		edge_end=(polyop.getEdgeSelection obj)as array
		if edge_start[1]!=edge_end[1] then (
		append ar_edges  edge_end[1]
			num+=1
		if edge_end[1] == ar_edges[1] then exit		
			)
		else (
		polyop.setEdgeSelection obj #(ar_edges[ar_edges.count])	
		obj.setRingShift -inter true false
		if num>1 then  (if 	((polyop.getEdgeSelection obj)as array)[1]!=ar_edges[ar_edges.count-1] then deleteitem ar_edges ar_edges.count )
			exit
		)
	)
	polyop.setEdgeSelection obj #(ar_edges[1])
	end=false
	num=1
	while end!=true do (
		edge_start=(polyop.getEdgeSelection obj)as array
		obj.setRingShift -inter true false	
		edge_end=(polyop.getEdgeSelection obj)as array

		if edge_start[1]!=edge_end[1] then (
			 append ar_edges  edge_end[1]
			num+=1
		if edge_end[1] == ar_edges[1] then exit		
			)
		else (
		polyop.setEdgeSelection obj #(ar_edges[ar_edges.count])	
		obj.setRingShift inter true false	
		if num>1 then  (if 	((polyop.getEdgeSelection obj)as array)[1]!=ar_edges[ar_edges.count-1] then deleteitem ar_edges ar_edges.count )
			exit
		)
	)
	)
	join last_edges ar_edges
)
polyop.setEdgeSelection obj last_edges
update obj
)
	
fn bianzhi_edge obj vals arry truefalse = (
	local ring_edge_1 = #(),rigs_arry,ring_edge_2
		select obj
		subobjectLevel = 2
		polyop.setedgeselection obj arry
		edge1 = (polyop.getEdgeSelection obj)
		numedge = polyop.getnumedges obj
		all_edge = (#{1..numedge} )as array
		numface = polyop.getnumfaces obj
		face1 = (#{1..numface} )as array
		obj.EditablePoly.SelectEdgeLoop ()
		obj.EditablePoly.SelectEdgeRing ()
		edge2 = (polyop.getEdgeSelection obj)
		polyop.setedgeselection obj (for o in all_edge where finditem edge2 o==0 collect o)
		prgsbra.value =  3		-----------------------------------------
		obj.edgeChamfer = vals/2
		obj.edgeChamferOpen = off
		obj.edgeChamferSegments = 1
		obj.EditablePoly.buttonOp #Chamfer
	
		numface = polyop.getnumfaces obj
		all_face = (#{1..numface} )as array
		polyop.setfaceselection obj (for o in all_face where finditem face1 o!=0 collect o)
		polyop.setedgeselection obj edge1
		vst = 2
		$.setLoopShift -1 true false  
		fff = polyop.getvertsUsingedge obj (polyop.getEdgeSelection $)
		for i in fff do (
			count = ((polyop.getfacesUsingvert obj i)as array).count
			if count == 1 do (vst=1 ;exit)
		)
		if vst != 1 then (
			obj.setLoopShift 1 true false  
			obj.setLoopShift 1 true false 
		)
		prgsbra.value =  6		-----------------------------------------
		looparry = polyLoop_inter obj 2
		
		if truefalse == true then (
			rigs_arry = for i = 1 to looparry.count by 2 collect looparry[i]
			ring_edge_2 = for i = 2 to looparry.count by 2 collect looparry[i]
		)else(
			ring_edge_2 = for i = 1 to looparry.count by 2 collect looparry[i]
			rigs_arry = for i = 2 to looparry.count by 2 collect looparry[i]
		)
		prgsbra.value =  10		-----------------------------------------
		for ee in rigs_arry do (
			polyop.setedgeselection obj ee
			edge_1 = polyop.getEdgeSelection obj
			obj.setRingShift 1 true false	
			edge_2 =polyop.getEdgeSelection obj
			numbers = (edge_1 * edge_2).numberset 
			if numbers != 0 then (
				obj.setRingShift -1 true false
				edges =polyop.getEdgeSelection obj			
				append ring_edge_1 (edges as array)[1]
			)else (
				edges =polyop.getEdgeSelection obj			
				append ring_edge_1 (edges as array)[1]
			)
		)
		polyop.setedgeSelection obj (ring_edge_1+ring_edge_2)
		obj.EditablePoly.delete #Face
	--	prgsbra.value =  100	-----------------------------------------
		polyring_inter obj 2 
)	
	
on btn_ok pressed do undo on (
	if classOf $ == Editable_Poly then	(
		max modify mode
		local fss = polyop.getNumFaces $,onf = true
		for f = 1 to fss do(
			prgsbra.value = 100.*f/fss
			vv = polyop.getFaceDeg $ f
			if vv != 4 do (onf=false;exit)
		)
		if onf == true then (
			try(
				obj = $;newbj = copy $
				startedge = openedge obj
				if startedge.count != 2 then (
					edgs = (polyop.getOpenEdges $) as array 
					vvv = (polyop.getvertsUsingedge $ edgs[1])as array
					edgss = (polyop.getedgesUsingvert $ vvv[1])as array
					edgse = for o in edgss where finditem edgs o==0 collect o
					startedge = #(edgs[1],edgse[1])
				)
				if chb_l.checked then (
					bianzhi_edge obj spi_1.value startedge[1] true
					bianzhi_edge newbj spi_1.value startedge[2] true
				) else (
					bianzhi_edge obj spi_1.value startedge[1] true
					bianzhi_edge newbj spi_1.value startedge[2] false
				)
				obj.EditablePoly.attach newbj obj
				addModifier obj (Push ()) ui:on
				obj.modifiers[#Push].Push_Value = spi_2.value
			)catch()
		)else (messageBox "模型不符合自动编织条件" title:"黑马设计网 提示" )
	)
)

)
createdialog Poly_bianzhi
