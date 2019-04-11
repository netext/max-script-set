  try destroyDialog polyfacetosphere catch()
rollout polyfacetosphere "Poly面加球体 Ace" width:170 height:60
(
	button but_ok "创 建 Poly 面 上 球 体"  width:130 height:30  
HyperLink  lb1	"【黑马设计网】出品" color:(color 150 0 0)  align:#center address:"http://www.3dheima.com" 
fn arc_vert_pos	vs1 segs Radius = (
	posxy = #();extrde_outline = #()	
	pp = vs1/segs;Y = Radius
	for v = 0 to vs1 by pp do (
		X = v*pi
		sins = (sin (x*180/pi))*y ; coss = (cos (x*180/pi))*y
		append posxy #(sins,coss)
	)
	for v = 2 to posxy.count do (
		heiht = posxy[v][1] - posxy[v-1][1] ; offend = posxy[v][2] - posxy[v-1][2]
		append extrde_outline #(heiht,offend)
	)
	extrde_outline	
)
on but_ok pressed do undo on (
	max create mode
	obj = $
	getfaces = polyop.GetFaceSelection obj  as array
	getfaces = sort getfaces
	for f = getfaces.count to 1 by -1 do (
		polyop.SetFaceSelection obj getfaces[f]
		geteds=polyop.getEdgesUsingFace obj getfaces[f] as array
		segs = floor(geteds.count/2)
		Areas = polyOp.getFaceArea obj getfaces[f]
		Radius = (Areas/pi)^0.5
		extrde_outlineval = arc_vert_pos 0.5 segs Radius
		for arrys in extrde_outlineval do obj.bevelFaces arrys[1] arrys[2]
		obj.EditablePoly.collapse #Face	
	)
)
)
createdialog polyfacetosphere


/*
	obj = $
	getfaces = polyop.GetFaceSelection $  as array
	pos1 = (polyOp.getFaceCenter obj getfaces[1])
	pos2 = (polyOp.getFaceCenter obj getfaces[2])
	Areas = polyOp.getFaceArea obj getfaces[1]
	Radius = (Areas / 3.1415926535)^0.5
	N1 = distance pos1 pos2
	if rad_1.state == 1 then 
		caple = Capsule radius:Radius height:(N1-(Radius*2))
	else caple = Capsule radius:Radius height:N1
	v1 = normalize (pos1 - pos2)
	caple.dir = v1
	if rad_1.state == 1 then caple.pos = pos2 else caple.pos = pos2+(v1*(-Radius))
	caple.material = obj.material

