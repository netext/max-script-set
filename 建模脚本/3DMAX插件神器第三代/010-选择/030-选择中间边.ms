(
	local curObj = selection[1]	
	
	function SelEdgesCnt = 
	(
		(polyOp.getEdgeSelection curObj).numberSet
	)
	
	function SelEdgeFormValidedgeRing =
	(
		result = false
		if SelEdgesCnt() != 1 then
		(
			with undo on
			(
				with redraw off
				(
					local curEdgeSel = polyOp.getEdgeSelection curObj as array
					polyOp.setEdgeSelection curObj curEdgeSel[1]
					curObj.buttonOp #selectEdgeRing
					local ringEdgeSel = polyOp.getEdgeSelection curObj
					if (ringEdgeSel * #{curEdgeSel[2]}).numberSet == 1 do
					(
						result = true
					)
					polyOp.setEdgeSelection curObj curEdgeSel
				)
			)
		)
		else (result = false)
		--
		result
	)
	
	function FindNeighborEdge02 edge01 edge02 edge03 =
	(
		local edge01Verts = polyOp.getEdgeVerts curObj edge01
		local edge02Verts = polyOp.getEdgeVerts curObj edge02
		local targetVerts = polyOp.getEdgeVerts curObj edge03
		local middlePoint01 = (((polyOp.getVert curObj edge01Verts[1]) + (polyOp.getVert curObj edge01Verts[2])) / 2)
		local middlePoint02 = (((polyOp.getVert curObj edge02Verts[1]) + (polyOp.getVert curObj edge02Verts[2])) / 2)
		local middlePoint03 = (((polyOp.getVert curObj targetVerts[1]) + (polyOp.getVert curObj targetVerts[2])) / 2)
		if (distance middlePoint03 middlePoint01) > (distance middlePoint03 middlePoint02) then
		(
			edge02
		)
		else
		(
			edge01
		)
	)
	
	function FindNeighborEdge01 edge01 desired =
	(
		local edgeVerts = polyOp.getEdgeVerts curObj edge01
		local vertEdges01 = polyOp.getEdgesUsingVert curObj edgeVerts[1]
		local vertEdges02 = polyOp.getEdgesUsingVert curObj edgeVerts[2]
		local twoEdges = #()
		local edgeFaces = polyOp.getFacesUsingEdge curObj edge01 as array
		if edgeFaces.count == 1 then
		(
			local faceEdges = polyOp.getEdgesUsingFace curObj edgeFaces[1]
			if faceEdges.numberSet == 4 do
			(
				(((faceEdges - vertEdges01) - vertEdges02) as array)[1]
			)
		)
		else
		(
			local faceEdges01 = polyOp.getEdgesUsingFace curObj edgeFaces[1]
			local faceEdges02 = polyOp.getEdgesUsingFace curObj edgeFaces[2]
			if faceEdges01.numberSet == 4 do
			(
				append twoEdges (((faceEdges01 - vertEdges01) - vertEdges02) as array)[1]
			)
			if faceEdges02.numberSet == 4 do
			(
				append twoEdges (((faceEdges02 - vertEdges01) - vertEdges02) as array)[1]
			)
			if twoEdges.count == 1 then
			(
				twoEdges[1]
			)
			else
			(
				FindNeighborEdge02 twoEdges[1] twoEdges[2] desired
			)
		)
	)
	
	function DoStepRing =
	(
		local selEdges = polyOp.getEdgeSelection curObj as array
		local edge01 = selEdges[1]
		local edgeRing = #{}
		append edgeRing selEdges[1]
		while edge01 != selEdges[2] do
		(
			local neighbor = FindNeighborEdge01 edge01 selEdges[2]
			edge01 = neighbor
			append edgeRing neighbor
		)
		edgeRing
	)
	
	function SelectEdgeRing =
	(
		if subobjectlevel == 2 and (SelEdgesCnt() != 0) then
		(
			if SelEdgeFormValidedgeRing() then
			(
				if SelEdgesCnt() == 2 do
				(
					local selEdges = polyOp.getEdgeSelection curObj
					with undo on
					(
						with redraw off
						(
							local edgeRing = DoStepRing()
							polyOp.setEdgeSelection curObj edgeRing
						)
						redrawViews()
					)
				)
			)
			else
				messagebox "选择的边缘不是来自同一个环形." title:"温馨提示"
		)
		else
			messagebox "亲！请选择两个边" title:"温馨提示"
	)
	
	on execute do 
	(
		if selection.count == 1 and classof selection[1] == Editable_Poly then
			SelectEdgeRing()
		else
			messagebox "Select only one Editable Poly object" title:"Invalid Selection"
	)
)