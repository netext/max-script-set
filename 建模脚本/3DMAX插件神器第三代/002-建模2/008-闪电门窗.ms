
rollout newroll "闪电门窗_W1.1" width:168 height:191
(
  
	spinner extrude_h "倒角:" pos:[20,7] width:97 height:16 range:[-100,100,-50] type:#float scale:1  
	spinner extrude_w "挤出:" pos:[21,28] width:97 height:16 range:[-100,100,-50] type:#float scale:1 
	spinner mater_w "窗框材质:" pos:[22,47] width:97 height:16 range:[-100,100,3] type:#integer
	spinner mater_g "玻璃材质:" pos:[22,70] width:97 height:16 range:[-100,100,4] type:#integer
	button btn2 "S_P" pos:[7,119] width:27 height:32 toolTip:"普通窗"
	GroupBox grp1 "简面" pos:[3,99] width:162 height:60
	label lbl11 "QQ:260592419 (热情奉献)" pos:[20,167] width:164 height:15
	button btn29 "S_R" pos:[39,119] width:27 height:32 toolTip:"日字型窗"
	button btn36 "S_r" pos:[71,119] width:27 height:32 toolTip:"日字型窗"
	button btn45 "S_T" pos:[103,119] width:27 height:32 toolTip:"T字型窗"
	button btn53 "S_S" pos:[135,119] width:27 height:32 toolTip:"十字型窗"
	on btn2 pressed do
	for A in selection do 
	 (
	  if superclassof A==shape do
	  (
	undo on
	(
	  fn win ob tv t fp ma4 gp kp ts glass=
	  (
	ob =selection[1]
	tv=viewport.gettype()
	ob.material=meditmaterials[mater_w.value] 
	convertToPoly(ob)
	centerpivot ob
	t=gettransformaxis ob 3
	polyOp.setFaceSelection ob #{1}
	 ob.bevelFaces 0 (extrude_h.value) 
	 ob.bevelFaces (extrude_w.value) 0
	 polyop.SetFaceSelection ob #{1}
	$.EditablePoly.delete #Face 
	   fp=ob.verts[9].pos 
	   ma4=ob.verts[9].pos.z
	   gp=ob.verts[10].pos  
	   kp=ob.verts[11].pos
	glass=Rectangle length:(distance gp kp) width:(distance fp gp) transform:t
	convertToPoly(glass)
	if tv==(#view_front) or tv==(#view_back) then
	(
	glass.pos.y=ob.verts[9].pos.y
	)
	else
	(
	glass.pos.x=ob.verts[9].pos.x
	)
	
	glass.material=meditmaterials[mater_g.value]
	ts=#(ob,glass)
	group ts
	max views redraw
	select ts
	
	)
	
	 win ob tv t fp ma4 gp kp ts glass
	 )
	)
	)
	on btn29 pressed do
	(
	for A in selection do 
		 (
		  if superclassof A==shape do
	(
	undo on
	(
	fn win ob tv t fp gp kp u ts glass=
	(
	tv=viewport.gettype()
	ob =selection[1]
	convertToPoly(ob)
	centerpivot ob
	t=gettransformaxis ob 3
	polyOp.setFaceSelection ob #{1}
	ob.material=meditmaterials[mater_w.value] 
	 ob.bevelFaces 0 (extrude_h.value) 
	 ob.bevelFaces (extrude_w.value) 0
	 polyop.SetFaceSelection ob #{1}
	$.EditablePoly.delete #Face 
	    fp=ob.verts[9].pos 
	   gp=ob.verts[10].pos   
	   kp=ob.verts[11].pos
	glass=Rectangle length:(distance gp kp) width:(distance fp gp) transform:t
	convertToPoly(glass)
	if tv==(#view_front) or tv==(#view_back) then
	(
	glass.pos.y=ob.verts[9].pos.y
	)
	else
	(
	glass.pos.x=ob.verts[9].pos.x
	)
	 glass.material=meditmaterials[mater_g.value]
	u= Rectangle length:(distance gp kp) width:-(extrude_h.value) transform:t
	select u
	for a in selection do addmodifier a(extrude amount:(extrude_w.value))
	convertToPoly(u)
	polyop.SetFaceSelection u #{1,3,5}
	u.EditablePoly.delete #Face 
	select u
	      
	     for u in selection do u.attach ob u
	     ts=#(u,glass)
	     select ts
	     group selection
	)
	win ob tv t fp gp kp u ts glass
	 max views redraw
	
	 )
	 )
	)
	
	)
	on btn36 pressed do
	(
	for A in selection do 
		 (
		  if superclassof A==shape do
	(
	undo on
	(
	fn win ob tv t fp gp kp h ts glass=
	(
	tv=viewport.gettype()
	ob =selection[1]
	convertToPoly(ob)
	centerpivot ob
	t=gettransformaxis ob 3
	polyOp.setFaceSelection ob #{1}
	ob.material=meditmaterials[mater_w.value] 
	 ob.bevelFaces 0 (extrude_h.value) 
	 ob.bevelFaces (extrude_w.value) 0
	 polyop.SetFaceSelection ob #{1}
	$.EditablePoly.delete #Face 
	    fp=ob.verts[9].pos 
	   gp=ob.verts[10].pos   
	   kp=ob.verts[11].pos
	glass=Rectangle length:(distance gp kp) width:(distance fp gp) transform:t
	convertToPoly(glass)
	if tv==(#view_front) or tv==(#view_back) then
	(
	glass.pos.y=ob.verts[9].pos.y
	)
	else
	(
	glass.pos.x=ob.verts[9].pos.x
	)
	 glass.material=meditmaterials[mater_g.value]
	 h=Rectangle length:-(extrude_h.value) width:(distance fp gp) transform:t
	select h
	for a in selection do addmodifier a(extrude amount:(extrude_w.value))
	convertToPoly(h)
	polyop.SetFaceSelection h #{2,4,5}
	h.EditablePoly.delete #Face 
	select h
	      
	     for h in selection do h.attach ob h
	     ts=#(h,glass)
	     select ts
	     group selection
	)
	win ob tv t fp gp kp h ts glass
	 max views redraw
	
	 )
	 )
	)
	
	)
	on btn45 pressed do
	(
	for A in selection do 
		 (
		  if superclassof A==shape do
	(
	undo on
	(
	fn win ob tv t fp ma4  ma5 ma6 gp kp a3 h u ur ts glass=
	(
	tv=viewport.gettype()
	ob =selection[1]
	convertToPoly(ob)
	centerpivot ob
	t=gettransformaxis ob 3
	polyOp.setFaceSelection ob #{1}
	ob.material=meditmaterials[mater_w.value] 
	 ob.bevelFaces 0 (extrude_h.value) 
	 ob.bevelFaces (extrude_w.value) 0
	 polyop.SetFaceSelection ob #{1}
	$.EditablePoly.delete #Face 
	    fp=ob.verts[9].pos 
	    ma4=ob.verts[9].pos.z
	   gp=ob.verts[10].pos   
	   kp=ob.verts[11].pos
	glass=Rectangle length:(distance gp kp) width:(distance fp gp) transform:t
	convertToPoly(glass)
	if tv==(#view_front) or tv==(#view_back) then
	(
	glass.pos.y=ob.verts[9].pos.y
	)
	else
	(
	glass.pos.x=ob.verts[9].pos.x
	)
	 glass.material=meditmaterials[mater_g.value]
	a3=distance kp gp 
	 h=Rectangle length:-(extrude_h.value) width:(distance fp gp) transform:t
	select h
	for a in selection do addmodifier a(extrude amount:(extrude_w.value))
	convertToPoly(h)
	polyop.SetFaceSelection h #{2,4,5}
	h.EditablePoly.delete #Face 
	   move h [0,0,(a3*0.2)]
	   ma2=h.verts[3].pos
	   ma6=h.verts[3].pos.z
	u= Rectangle length:(distance fp ma2) width:-(extrude_h.value) transform:t
	select u
	for a in selection do addmodifier a(extrude amount:extrude_w.value)
	convertToPoly(u)
	polyop.SetFaceSelection u #{1,3,5}
	u.EditablePoly.delete #Face
	ma5=u.verts[7].pos.z
	ur=ma5-ma4
	move u [0,0,-ur]
	select u
	     for u in selection do u.attach h u
	     for h in selection do h.attach ob h
	     ts=#(u,glass)
	     select ts
	     group selection
	)
	win ob tv t fp ma4  ma5 ma6 gp kp a3 h u ur ts glass
	 max views redraw
	
	 )
	 )
	)
	)
	on btn53 pressed do
	(
	for A in selection do 
		 (
		  if superclassof A==shape do
	(
	undo on
	(
	fn win ob tv t fp gp kp glass h u ts=
	(
	tv=viewport.gettype()
	ob =selection[1]
	convertToPoly(ob)
	centerpivot ob
	t=gettransformaxis ob 3
	polyOp.setFaceSelection ob #{1}
	ob.material=meditmaterials[mater_w.value] 
	 ob.bevelFaces 0 (extrude_h.value) 
	 ob.bevelFaces (extrude_w.value) 0
	 polyop.SetFaceSelection ob #{1}
	$.EditablePoly.delete #Face 
	    fp=ob.verts[9].pos 
	   gp=ob.verts[10].pos   
	   kp=ob.verts[11].pos
	glass=Rectangle length:(distance gp kp) width:(distance fp gp) transform:t
	convertToPoly(glass)
	if tv==(#view_front) or tv==(#view_back) then
	(
	glass.pos.y=ob.verts[9].pos.y
	)
	else
	(
	glass.pos.x=ob.verts[9].pos.x
	)
	 glass.material=meditmaterials[mater_g.value]
	
	 h=Rectangle length:-(extrude_h.value) width:(distance fp gp) transform:t
	select h
	for a in selection do addmodifier a(extrude amount:(extrude_w.value))
	convertToPoly(h)
	polyop.SetFaceSelection h #{2,4,5}
	h.EditablePoly.delete #Face 
	u= Rectangle length:(distance gp kp) width:-(extrude_h.value) transform:t
	select u
	for a in selection do addmodifier a(extrude amount:extrude_w.value)
	convertToPoly(u)
	polyop.SetFaceSelection u #{1,3,5}
	u.EditablePoly.delete #Face
	select u
	     for u in selection do u.attach h u
	      for u in selection do u.attach ob u
	
	     ts=#(u,glass)
	     select ts
	     group selection
	)
	win ob tv t fp gp kp glass h u ts
	
	 max views redraw
	 )
	 )
	)
	)
)



































createdialog newroll


--newroll width:200 height:200


--encryptscript "e:\max8\qq.ms"