------------------------------------------------
--Script: 		Pinscreen
--Version:		1.6
--Last update:  26.09.2002
--By:     		Adam Wierzchowski
--Web:			pixelfactory.mchtr.pw.edu.pl
--E-mail: 		pixelfactory@op.pl
------------------------------------------------
--If You create something interesting with one of my scripts,
--please mail it to me and I will place it on my web site as an example.
---------------------------------------------------------

------------------
--Global variables
------------------
global current_bitmap
global currentx
global currenty
global orygx
global orygy
global current_action
global progframetext
global custom_obj

---------
--Utility
---------
Rollout pins "Pinscreen"
(

-----------
--Functions
-----------

------------
--No scale 1
------------
fn noscale1 =
(
global target_arr =#()
local pixline =#()
for i in 0 to orygy-1 do
	(
	pixline = getpixels current_bitmap [0,i] orygx
	for j in 1 to pixline.count do
		(
		case pins.channel.selection of
				(
				1: append target_arr pixline[j].r
				2: append target_arr pixline[j].g
				3: append target_arr pixline[j].b
				4: append target_arr pixline[j].h
				5: append target_arr pixline[j].s
				6: append target_arr pixline[j].v
				7: append target_arr pixline[j].a
				)
		)
	pins.prog.text = (current_action + (100*(i+1)/orygy) as string + " %")
	pins.progframe.text = progframetext
	)
)

--------------
--Scale down 1
--------------
fn scaledown1 =
(
global target_arr =#()
local pixline =#()
local currentpix
ratio = orygx/currentx as float
for i in 0 to orygy-1 do
(
	pixline = getpixels current_bitmap [0,i] orygx
	for j in 1 to currentx do
	(
		if (j == 1) then start = 1
			else start = ratio * (j - 1)
		end = ratio * j
		if ((start - (floor start)) == 0) then pixstart = start
			else pixstart = ceil start
		if ((end - (floor end)) == 0) then pixend = end
			else pixend = ceil end
		pixtotal = 0
		for pix = pixstart to pixend do
		(				
			case pins.channel.selection of
				(
				1: currentpix = pixline[pix].r
				2: currentpix = pixline[pix].g
				3: currentpix = pixline[pix].b
				4: currentpix = pixline[pix].h
				5: currentpix = pixline[pix].s
				6: currentpix = pixline[pix].v
				7: currentpix = pixline[pix].a
				)
			if ((pix != pixstart) and (pix != pixend)) then pixtotal += currentpix
			else
			(
				if (end - (floor end)) == 0 then qwe=1 else qwe=(end - (floor end))
				if pixstart == 1 then qwe2=1 else qwe2 = (pixstart - start)
							
				if ((pix == 1) and (pix != pixstart)) then pixtotal += currentpix
				if ((pix == orygx) and (pix != pixend)) then pixtotal += currentpix
				if pix == pixstart then pixtotal += (currentpix) * qwe2
				if pix == pixend then pixtotal += (currentpix) * qwe
			)
		)
		append target_arr ((pixtotal/ratio) as integer)		
	)
	pins.prog.text = (current_action + (100*(i+1)/orygy) as string + " %")
	pins.progframe.text = progframetext
)
)

------------
--Scale up 1
------------
fn scaleup1 =
(
global target_arr =#()
local pixline =#()
local nextpix
local prevpix
ratio = (orygx-1)/(currentx-1) as float
for j in 0 to orygy-1 do
(
	pixline = getpixels current_bitmap [0,j] orygx
	for i in 0 to (currentx-1) do
	(
		ir = i * ratio
		prev = floor(ir) + 1
		next = ceil(ir) + 1
		case pins.channel.selection of
			(
			1: (nextpix = pixline[next].r
				prevpix	= pixline[prev].r)	
			2: (nextpix = pixline[next].g
				prevpix	= pixline[prev].g)
			3: (nextpix = pixline[next].b
				prevpix	= pixline[prev].b)
			4: (nextpix = pixline[next].h
				prevpix	= pixline[prev].h)
			5: (nextpix = pixline[next].s
				prevpix	= pixline[prev].s)
			6: (nextpix = pixline[next].v
				prevpix	= pixline[prev].v)
			7: (nextpix = pixline[next].a
				prevpix	= pixline[prev].a)
			)
		pixtotal = (prevpix * (1-(ir-floor(ir))))+(nextpix * (ir - floor(ir)))
		append target_arr (pixtotal as integer)
	)
	pins.prog.text = (current_action + (100*(j+1)/orygy) as string + " %")
	pins.progframe.text = progframetext
)
)

--------
--Rotate
--------
fn rotate =
(
current_action = "Rotating array... "
global target_arr2 =#()
for i in (currentx - 1) to 0 by -1 do
(
	for j in 0 to (orygy - 1) do 
	(
		append target_arr2 (target_arr[target_arr.count - j * currentx - i])
	)	
	pins.prog.text = (current_action + (100-(100*(i+1)/currentx)) as string + " %")
	pins.progframe.text = progframetext
)
global target_arr =#()
)

------------
--No scale 2
------------
fn noscale2 =
(
global target_arr =#()
for i in 1 to target_arr2.count do
(
	append target_arr target_arr2[i]
	pins.prog.text = (current_action + (100*(i+1)/target_arr2.count) as string + " %")
	pins.progframe.text = progframetext
)
)

--------------
--Scale down 2
--------------
fn scaledown2 =
(
global target_arr =#()
ratio = orygx/currentx as float
for i in 0 to orygy-1 do
(
	for j in 1 to currentx do
	(
		if (j == 1) then start = 1+(orygx-1)*i+i
			else start = ratio * (j - 1) + (orygx-1)*i+i
		end = ratio * j + (orygx-1)*i+i
		if ((start - (floor start)) == 0) then pixstart = start
			else pixstart = ceil start
		if ((end - (floor end)) == 0) then pixend = end
			else pixend = ceil end
		pixtotal = 0
		for pix = pixstart to pixend do
		(			
			if ((pix != pixstart) and (pix != pixend)) then pixtotal += target_arr2[pix]
			else
			(
				if (end - (floor end)) == 0 then qwe=1 else qwe=(end - (floor end))
				if (pixstart - i * orygx) == 1 then qwe2=1 else qwe2 = (pixstart - start)
							
				if ((pix == 1) and (pix != pixstart)) then pixtotal += target_arr2[pix]
				if ((pix == orygx) and (pix != pixend)) then pixtotal += target_arr2[pix]
				if pix == pixstart then pixtotal += (target_arr2[pix]) * qwe2
				if pix == pixend then pixtotal += (target_arr2[pix]) * qwe
			)
		)
		append target_arr ((pixtotal/ratio) as integer)
	)
	pins.prog.text = (current_action + (100*(i+1)/orygy) as string + " %")
	pins.progframe.text = progframetext
)
)

------------
--Scale up 2
------------
fn scaleup2 =
(
global target_arr =#()
ratio = (orygx-1)/(currentx-1) as float
for j in 0 to orygy-1 do
(
	for i in 0 to (currentx-1) do
	(
		ir = i * ratio
		prev = floor(ir) + 1
		next = ceil(ir) + 1
		pixtotal = (target_arr2[j*orygx+prev] * (1-(ir-floor(ir))))+(target_arr2[j*orygx+next] * (ir - floor(ir)))
		append target_arr (pixtotal as integer)
	)
	pins.prog.text = (current_action + (100*(j+1)/orygy) as string + " %")
	pins.progframe.text = progframetext
)
)

---------------
--Array to file
---------------
fn arr2file =
(
current_action = "Saving bitmap... "
new_bmp = bitmap pins.sizex.value pins.sizey.value filename:"g:\\max\\scripts\\pin\\40a.bmp"
local pixline =#()
for i in 0 to (pins.sizey.value-1) do
(
	for j in 1 to pins.sizex.value do
	(
	append pixline (color target_arr[pins.sizey.value*j-i] target_arr[pins.sizey.value*j-i] target_arr[pins.sizey.value*j-i])
	)
	setpixels new_bmp [0,i] pixline
	for k in 1 to pixline.count do deleteItem pixline 1
	pins.prog.text = (current_action + (100*(i+1)/pins.sizey.value) as string + " %")
)


/*for i in 1 to pins.sizey.value do
(
	for j in 1 to pins.sizex.value do
	(
	append pixline (color target_arr[(i-1)*pins.sizex.value+j] target_arr[(i-1)*pins.sizex.value+j] target_arr[(i-1)*pins.sizex.value+j])
	setpixels new_bmp [0,i-1] pixline
	)
	for k in 1 to pixline.count do deleteItem pixline 1
)*/

save new_bmp
close new_bmp
)

------------
--Set limits
------------
fn setlimits =
(
for i in 1 to target_arr.count do
	(
	if (target_arr[i] > pins.highlimit.value) then (target_arr[i] = pins.highlimit.value)
	if (target_arr[i] < pins.lowlimit.value) then (target_arr[i] = pins.lowlimit.value)
	)
)

--------
--Create
--------
fn create =
(
global obj_array =#()
local first
current_action = "Creating... "
for i in 0 to pins.sizey.value-1 do
(
	for j in 1 to pins.sizex.value do
	(
		case pins.obj_type.selection of
		(
			2:
			(
				if (i == 0) and (j == 1) then
					(
					first = capsule sides:pins.obj_sides.value radius:pins.obj_rad.value height:pins.obj_height.value position:[j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
					append obj_array first
					)
				else 
				(
					copy = reference first
		 			copy.pos = [j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
					append obj_array copy
				)
			)
			3:
			(
				if (i == 0) and (j == 1) then
					(
					first = cylinder sides:pins.obj_sides.value radius:pins.obj_rad.value height:pins.obj_height.value position:[j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
					append obj_array first
					)
				else 
				(
					copy = reference first
		 			copy.pos = [j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
					append obj_array copy
				)
			)
			4:
			(
				
				
				(
					copy = reference custom_obj
					copy.pos = [j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
					append obj_array copy					
				)
			)
			1:
			(
				if (i == 0) and (j == 1) then
					(
					first = box length:(2*pins.obj_rad.value) width:(2*pins.obj_rad.value) height:pins.obj_height.value position:[j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
					append obj_array first
					)
				else 
				(
					copy = reference first
					copy.pos = [j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
					append obj_array copy					
				)
			)
		)
	)
	pins.prog.text = (current_action + (100*(i+1)/pins.sizey.value) as string + " %")
	pins.progframe.text = progframetext
)
)

--------------
--Set position
--------------
fn setpos =
(
counter = 0
current_action = "Animating... "
for i in 0 to pins.sizey.value-1 do
(
	for j in 1 to pins.sizex.value do
		(
		counter += 1
		obj_array[counter].pos = [j*pins.obj_rad.value*2+(pins.distx.value * (j-1)),-((i+1)*pins.obj_rad.value*2+(pins.disty.value * i)),(target_arr[pins.sizey.value*j-i])*pins.offset_mult.value]
		)
	pins.prog.text = (current_action + (100*(i+1)/pins.sizey.value) as string + " %")
	pins.progframe.text = progframetext

)

)
---------------
--Functions end
---------------


group "Image"
(
button pickimg "Pick Image" width:100
label res "Resolution: " align:#left
dropdownlist channel "Pick channel:" items:#("Red","Green","Blue","Hue","Saturation","Value","Alpha") selection:6
)

group "Animation"
(
checkbox enableanim "Enable animation" checked:false enabled:false
label noframes "Number of frames: " align:#left enabled:false
spinner startframe "Start frame: " type:#integer range:[0,1000,0] align:#right fieldwidth:48 enabled:false
spinner endframe "End frame: " type:#integer range:[0,1000,50] align:#right fieldwidth:48 enabled:false
label frameproc "Frames to process: " align:#left enabled:false
)

group "Settings"
(
spinner sizex "Size X: " type:#integer range:[2,200,36] align:#right fieldwidth:48
spinner sizey "Size Y: " type:#integer range:[2,200,48] align:#right fieldwidth:48
spinner distx "X Distance: " type:#float range:[0,2000,1] align:#right fieldwidth:48
spinner disty "Y Distance: " type:#float range:[0,2000,1] align:#right fieldwidth:48
label amount "Elements amount: 1728"
spinner highlimit "High limit: " type:#integer range:[0,255,255] fieldwidth:48 align:#right
spinner lowlimit "Low limit: " type:#integer range:[0,255,0] fieldwidth:48 align:#right
spinner offset_mult "Offset multiplier: " type:#float range:[0.01,100,0.31] align:#right fieldwidth:48 offset:[0,2]
dropdownlist obj_type "Element type:" items:#("Box","Capsule","Cylinder","Custom object")
pickbutton cust_obj "Pick custom object" width:148 enabled:false
spinner obj_rad "Element radius: " type:#float range:[1,100,3] fieldwidth:48 align:#right
spinner obj_height "Height: " type:#float range:[0.01,9999,40] fieldwidth:48 align:#right
spinner obj_sides "Sides: " type:#integer range:[3,100,6] fieldwidth:48 align:#right enabled:false
)

group "Status"
(
label prog "Please, pick image..." align:#center
label progframe "No image" align:#center enabled:true
button go "GO!" enabled:false
)

on pickimg pressed do
(
current_bitmap = selectBitmap caption:"Pick Image"
if current_bitmap != undefined then
(
	res.text = "Resolution: " + current_bitmap.width as string + "x" + current_bitmap.height as string
	if current_bitmap.numframes > 1 then
		(
		enableanim.enabled = true
		enableanim.checked = true
		noframes.enabled = true
		noframes.text = "Number of frames: " + current_bitmap.numframes as string
		startframe.enabled = true
		startframe.range = [0,current_bitmap.numframes-1,0]
		endframe.enabled = true
		endframe.range = [0,current_bitmap.numframes-1,current_bitmap.numframes-1]
		frameproc.enabled = true
		frameproc.text = "Frames to process: " + (endframe.value - startframe.value + 1) as string
		progframe.text = ""
		)
	else
		(
		enableanim.enabled = false
		enableanim.checked = false
		noframes.enabled = false
		startframe.enabled = false
		endframe.enabled = false
		frameproc.enabled = false
		progframe.text = ""
		)
	go.enabled = true
	prog.text = "Waiting..."
)
)

on obj_type selected new_arg do
(
if new_arg == 1 then
(
cust_obj.enabled = false
obj_rad.enabled = true
obj_height.enabled = true
obj_sides.enabled = false
)

if new_arg == 2 or new_arg == 3 then
(
cust_obj.enabled = false
obj_rad.enabled = true
obj_height.enabled = true
obj_sides.enabled = true
)

if new_arg == 4 then
(
cust_obj.enabled = true
obj_rad.enabled = false
obj_height.enabled = false
obj_sides.enabled = false
)
)

on cust_obj picked obj do
(
cust_obj.text = obj.name
custom_obj = obj
)

on go pressed do
(
if enableanim.checked == true then
	(
	startanim = startframe.value
	endanim = endframe.value
	)
else
	(
	startanim = 0
	endanim = 0
	)
animate on
(
for current_frame in startanim to endanim do
(
	gotoframe current_bitmap current_frame
	if current_bitmap.numframes > 1 then (progframetext = "Frame: " + (current_frame - startanim + 1) as string + " / " + (endframe.value - startframe.value + 1) as string + " (" + current_frame as string + ")")
	else progframetext = "No frames"
	
		orygx = current_bitmap.width
		orygy = current_bitmap.height
		currentx = sizex.value
		currenty = orygy
	current_action = "Scaling X ... "
	if sizex.value == current_bitmap.width then noscale1()
	else
	(
		if sizex.value < current_bitmap.width then scaledown1()
		if sizex.value > current_bitmap.width then scaleup1()
	)
	
	rotate()
		orygx = current_bitmap.height
		orygy = sizex.value
		currentx = sizey.value
		currenty = orygy
	current_action = "Scaling Y ... "
	if sizey.value == current_bitmap.height then noscale2()
	else
	(
		if sizey.value < current_bitmap.height then scaledown2()
		if sizey.value > current_bitmap.height then scaleup2()
	)
	
	--arr2file()
	setlimits()
	if current_frame == startanim then
		(
		at time 0
			(
			create()
			)
		)
	else 
		(
		at time (current_frame - startanim)
			(
			setpos()
			)
		)
)
)
close current_bitmap
prog.text = "Done !"
)--end go pressed

on enableanim changed val do
(
if val == true then
	(
	noframes.enabled = true
	noframes.text = "Number of frames: " + current_bitmap.numframes as string
	startframe.enabled = true
	endframe.enabled = true
	frameproc.enabled = true
	)
else
	(
	noframes.enabled = false
	startframe.enabled = false
	endframe.enabled = false
	frameproc.enabled = false
	)
)

on startframe changed val do
(
if startframe.value > endframe.value then endframe.value = val
frameproc.text = "Frames to process: " + (endframe.value - val + 1) as string
)
on endframe changed val do
(
if endframe.value < startframe.value then startframe.value = val
frameproc.text = "Frames to process: " + (val - startframe.value + 1) as string
)
on sizex changed val do amount.text = ("Elements amount: " + (val * sizey.value) as string)
on sizey changed val do amount.text = ("Elements amount: " + (sizex.value * val) as string)
on highlimit changed val do (if highlimit.value < lowlimit.value then lowlimit.value = val)
on lowlimit changed val do (if highlimit.value < lowlimit.value then highlimit.value = val)
)


rollout about_roll "About"
(
	label lab1 "Pinscreen 1.6 for 3ds max 4.x"
	hyperlink lab2_ab "by Adam Wierzchowski" align:#center address:" mailto:pixelfactory@op.pl" color:(color 0 0 0) hoverColor:(color 255 255 255)
	label lab3_ab "Copyright \xa9 2002 " across:2
	hyperlink lab4_ab "【3d狼设计网】出品" align:#center across:2 address:"http://www.3dlang.com" color:(color 70 70 255) hoverColor:(color 255 255 255)
)


pinscreen_floater = newRolloutFloater "Pinscreen" 200 700
addrollout pins pinscreen_floater
addrollout about_roll pinscreen_floater


