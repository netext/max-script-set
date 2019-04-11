/****************************************************************************

	-------------------------------------------------------------------
	SPLINESURFACE v0.11
	-------------------------------------------------------------------

	DESCRIPTION
	SplineSurface is a small tool that creates a quad surface based
	on 4 spline shapes.
					
	AUTHOR
	Jorge Rodr韌uez
	
	DATE
	03.08.2016

	USAGE
	Pick up your 4 splines, set the number of subdivisions and click on
	Build Surface. You can reverse the order of each shape with
	the "R" button.

	DISCLAIMER
	Use at your own risk.
	
	http://www.3dheima.com

****************************************************************************/

try (destroydialog ::RO_SPLINES_SURFACE) catch()
rollout RO_SPLINES_SURFACE "Splines Surface v0.11" width:196 height:260
(
	fn FilterShapes obj =
	(
		(classof obj == line or classof obj == splineshape) and numsplines obj == 1
	)
	
	label lbl1 "Top:"    pos:[8, 16] width:48
	label lbl2 "Bottom:" pos:[8, 48] width:48
	label lbl3 "Left:"   pos:[8, 80] width:48
	label lbl4 "Right:"  pos:[8,112] width:48
	
	pickbutton bt1 "Pick Spline" pos:[56,  8] width:96 height:32 autoDisplay:on filter:FilterShapes
	pickbutton bt2 "Pick Spline" pos:[56, 40] width:96 height:32 autoDisplay:on filter:FilterShapes
	pickbutton bt3 "Pick Spline" pos:[56, 72] width:96 height:32 autoDisplay:on filter:FilterShapes
	pickbutton bt4 "Pick Spline" pos:[56,104] width:96 height:32 autoDisplay:on filter:FilterShapes
	
	button bt1r "R" pos:[156,  8] width:32 height:32
	button bt2r "R" pos:[156, 40] width:32 height:32
	button bt3r "R" pos:[156, 72] width:32 height:32
	button bt4r "R" pos:[156,104] width:32 height:32
	
	groupBox grp1 "Subdivisions:" pos:[8,144] width:180 height:48
	spinner  spn_sx "Width:"  pos:[ 16,164] fieldwidth:34 range:[4,100,10] type:#integer
	spinner  spn_sy "Height:" pos:[100,164] fieldwidth:34 range:[4,100,10] type:#integer
	
	button bt_build "Build Surface" pos:[8,200] width:180 height:32
	
	hyperlink lbl_url "【黑马设计网】出品" pos:[130,240] width:109 address:"www.3dheima.com" color:[40,100,255] hovercolor:[255,255,255] visitedcolor:[40,100,255]
	
	local surf
	
	fn BuildSurface =
	(
		top    = bt1.object
		bottom = bt2.object
		left   = bt3.object
		right  = bt4.object
		
		if top     == undefined do return messagebox "Invalid Top Shape"
		if left    == undefined do return messagebox "Invalid Left Shape"
		if bottom  == undefined do return messagebox "Invalid Bottom Shape"
		if right   == undefined do return messagebox "Invalid Right Shape"
		
		sx = spn_sx.value
		sy = spn_sy.value
		
		topPos    = for j = 0. to 1. by (1./sx) collect lengthInterp top    1 j
		bottomPos = for j = 0. to 1. by (1./sx) collect lengthInterp bottom 1 j
		leftPos   = for j = 0. to 1. by (1./sy) collect lengthInterp left   1 j
		rightPos  = for j = 0. to 1. by (1./sy) collect lengthInterp right  1 j

		_left   = for j = 1 to ((sx+1)*(sy+1)) by (sx+1) collect j
		_right  = for j = (sx+1) to ((sx+1)*(sy+1)) by (sx+1) collect j
		_top    = for j = (((sx+1)*sy)+1) to (((sx+1)*sy)+1+sx) collect j
		_bottom = for j = 1 to (sx+1) collect j
		
		undo off
		(
			if surf != undefined and not isdeleted surf do delete surf
			surf = converttopoly (plane width:sx length:sy widthsegs:sx lengthsegs:sy wirecolor:[150,220,50])

			for j = 1 to topPos.count    do polyop.setvert surf _top[j] topPos[j]
			for j = 1 to leftPos.count   do polyop.setvert surf _left[j] leftPos[j]
			for j = 1 to bottomPos.count do polyop.setvert surf _bottom[j] bottomPos[j]
			for j = 1 to rightPos.count  do polyop.setvert surf _right[j] rightPos[j]
			
			surf.relaxAmount = 1
			surf.relaxIterations = sx*sy*10
			surf.editablepoly.relax()
		)
	)
	
	fn ReverseShape mShape =
	(
		undo off
		(
			reverse mShape 1
			updateshape mShape
		)
		BuildSurface()
	)
	
	on bt_build pressed do BuildSurface()
	
	on bt1r pressed do if bt1.object != undefined do ReverseShape bt1.object
	on bt2r pressed do if bt2.object != undefined do ReverseShape bt2.object
	on bt3r pressed do if bt3.object != undefined do ReverseShape bt3.object
	on bt4r pressed do if bt4.object != undefined do ReverseShape bt4.object
)

createdialog RO_SPLINES_SURFACE