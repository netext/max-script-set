



try(destroyDialog Books_rollout) catch()
rollout Books_rollout "摆书工具(黑马设计网)"
(
	local polka
	local sredniaGrubosc
	local logoRozmiar = 50
	local obj_polka
	local pre_polka
	local ileRzedow = 0
	local ktoryRzad = 0
	local ks_pos_wekt = #()
	local wspolczynniki = #()
	local WszystkieWszystkie = #()
	
	fn fixpivot obj = obj.pivot = obj.min
		
	fn kat_miedzy_wektorami wv1 wv2 =
	(
		return (acos (dot (normalize wv1) (normalize wv2)))
	)
	
	fn czyRownolegle v1 v2 = 
	(
		iw = cross (normalize v1) (normalize v2)
		if iw.x == 0 and iw.y == 0 and iw.z == 0 then true else false
	)
		
	fn przeciecie pA pB pC pD =
	(
		local a=pB-pA
		local b=pD-pC
		local c=pC-pA
		local cross1 = cross a b
		local cross2 = cross c b
		pA + ( a*( (dot cross2 cross1)/((length cross1)^2) ) )
	)
	
	fn stworzBBox n =
	(
		local bounds
		if (isGroupMember n == true) then ( bounds= in coordsys local nodeLocalBoundingBox n.parent) else (bounds= in coordsys local nodeLocalBoundingBox n)
		b = box()
		local bb = bounds[2] - bounds[1]
		b.width = bb[1]
		b.length = bb[2] 
		b.height = bb[3]
		CenterPivot b
		obj = n
		if (isGroupMember n == true) then obj = n.parent else obj = n
		tm = obj.objecttransform 
		if (isGroupMember obj == true) then 
		(
			b.transform = tm
			b.pos = obj.parent.center
			b.pivot = obj.parent.pivot
		)
		else
		(
			b.transform = tm
			b.pos = obj.center
			b.pivot = obj.pivot
		)
		return b
	)
	
	fn wektorWyrownaniaX objl objr =
	(
		bbl = stworzBBox objl
		convertToPoly bbl
		
		--szukanie najbardziej wysunietego do przodu
		best = 1
		for i = 2 to (polyop.getNumFaces bbl) do
			if (polyop.getFaceCenter bbl i).y < (polyop.getFaceCenter bbl best).y then best = i
		--punkty z tego face'a
		punktyl = polyop.GetFaceVerts bbl best
		
		bbr = stworzBBox objr
		convertToPoly bbr
		--szukanie najbardziej wysunietego do przodu
		best = 1
		for i = 2 to (polyop.getNumFaces bbr) do
			if (polyop.getFaceCenter bbr i).y < (polyop.getFaceCenter bbr best).y then best = i
		--punkty z tego face'a
		punktyr = polyop.GetFaceVerts bbr best
		
		--start
		posunWX = 0
		for i = 1 to 4 do
		(
			p1 = polyop.getVert bbr punktyr[i]
			p2 = [p1.x+1,p1.y,p1.z]
			p1.y = 0
			p2.y = 0
			for j = 1 to 4 do
			(
				p3 = polyop.getVert bbl punktyl[j]
				if j != 4 then p4 = polyop.getVert bbl punktyl[j+1] else p4 = polyop.getVert bbl punktyl[1]
				p3.y = 0
				p4.y = 0
				
				pPrzeciecia = przeciecie p1 p2 p3 p4
				if ((czyRownolegle (p2-p1) (p4-p3)) == false) then
				(
					--zakres x
					if p3.x <= p4.x then
					(
						pMniejszyX = p3.x
						pWiekszyX = p4.x
					)
					else
					(
						pMniejszyX = p4.x
						pWiekszyX = p3.x
					)
					
					--zakres z
					if p3.z <= p4.z then
					(
						pMniejszyZ = p3.z
						pWiekszyZ = p4.z
					)
					else
					(
						pMniejszyZ = p4.z
						pWiekszyZ = p3.z
					)
					
					--sprawdzanie czy przecial
					if (((pPrzeciecia.x >= pmniejszyx) or (abs (pPrzeciecia.x-pmniejszyx) < (sredniaGrubosc/1000.0))) and ((pPrzeciecia.x <= pwiekszyx) or (abs (pPrzeciecia.x-pwiekszyx) < (sredniaGrubosc/1000.0))) and ((pPrzeciecia.z >= pmniejszyz) or (abs (pPrzeciecia.z-pmniejszyz) < (sredniaGrubosc/1000.0))) and ((pPrzeciecia.z <= pwiekszyz) or (abs (pPrzeciecia.z-pwiekszyz) < (sredniaGrubosc/1000.0)))) then
						--jesli tak, to sprawdz czy jest najlepszym do tej pory typem
							if abs (pPrzeciecia.x - p1.x) >posunWX then posunWX = abs (pPrzeciecia.x - p1.x)
				)
			)
		)
		
		for i = 1 to 4 do
		(
			p1 = polyop.getVert bbl punktyl[i]
			p2 = [p1.x+1,p1.y,p1.z]
			p1.y = 0
			p2.y = 0
			for j = 1 to 4 do
			(
				p3 = polyop.getVert bbr punktyr[j]
				if j != 4 then p4 = polyop.getVert bbr punktyr[j+1] else p4 = polyop.getVert bbr punktyr[1]
				p3.y = 0
				p4.y = 0
				
				pPrzeciecia = przeciecie p1 p2 p3 p4
				if (czyRownolegle (p2-p1) (p4-p3)) == false then
				(
					--zakres x
					if p3.x <= p4.x then
					(
						pMniejszyX = p3.x
						pWiekszyX = p4.x
					)
					else
					(
						pMniejszyX = p4.x
						pWiekszyX = p3.x
					)
					
					--zakres z
					if p3.z <= p4.z then
					(
						pMniejszyZ = p3.z
						pWiekszyZ = p4.z
					)
					else
					(
						pMniejszyZ = p4.z
						pWiekszyZ = p3.z
					)
					
					--sprawdzanie czy przecial
					if (((pPrzeciecia.x >= pmniejszyx) or (abs (pPrzeciecia.x-pmniejszyx) < (sredniaGrubosc/1000.0))) and ((pPrzeciecia.x <= pwiekszyx) or (abs (pPrzeciecia.x-pwiekszyx) < (sredniaGrubosc/1000.0))) and ((pPrzeciecia.z >= pmniejszyz) or (abs (pPrzeciecia.z-pmniejszyz) < (sredniaGrubosc/1000.0))) and ((pPrzeciecia.z <= pwiekszyz) or (abs (pPrzeciecia.z-pwiekszyz) < (sredniaGrubosc/1000.0)))) then
						--jesli tak, to sprawdz czy jest najlepszym do tej pory typem
							if abs (pPrzeciecia.x - p1.x) > posunWX then posunWX = abs (pPrzeciecia.x - p1.x)
				)
			)
		)
		--usuwanie bboxow
		delete bbl
		delete bbr
		return posunWX
	)

	fn setrot obj rx ry rz =
	(
		local translateMat = transMatrix obj.transform.pos
		local scaleMat = scaleMatrix obj.transform.scale
		obj.transform = scaleMat * translateMat
		rotate obj (angleaxis rx [1,0,0])
		rotate obj (angleaxis ry [0,1,0])
		rotate obj (angleaxis rz [0,0,1])
	)
	
	function zaokr liczba =
	(
		local ulamek = (liczba-(floor liczba))*1000.0
		ulamek = floor ulamek
		local dodac=false
		if (mod ulamek 10.0)>=5.0 then dodac=true
		ulamek =floor (ulamek/10.0)
		if dodac then ulamek+=1
		return ((floor liczba)+(ulamek/100.0))
	)

	local listawys = #()
	local listagrub = #()
	local StacksProbability = 10.0
	local los
	local listaUtworzonych = #()

	


    dotNetControl lbBooks "System.Windows.Forms.Label" pos:[173,5] width:143 height:18 
	
	button btnAdd "添加书籍" pos:[172,29] width:145 height:25
	button btnDel "删除书籍" pos:[172,56] width:145 height:25
		
	GroupBox gbProperties "属性" pos:[172,112] width:145 height:86
	radiobuttons rbCopyType "" pos:[175,130] width:159 height:16 labels:#("复制", "实例", "参考") columns:3
	spinner spHorFlip "水平翻转(%):" pos:[183,154] width:127 height:16 range:[0,100,5] type:#float fieldwidth:50
	spinner spVertFlip "垂直翻转(%):" pos:[183,174] width:127 height:16 range:[0,100,5] type:#float fieldwidth:50
	
	GroupBox gbSinglerow "单行在视口的中心" pos:[171,206] width:145 height:73
	spinner spLength "长度:" pos:[185,229] width:119 height:16 range:[0,1000000,100] type:#worldunits fieldwidth:80
	button btnCreateRow "创建" pos:[195,254] width:100 height:20 enabled:false
	
	GroupBox gbStanding "站立的书籍" pos:[3,5] width:165 height:82
	checkbox chbStanding "站立的书籍" pos:[85,5] width:17 height:15 checked:true type:#float
	spinner spStandingProbability "概率(%):" pos:[62,22] width:103 height:16 range:[0,100,60] type:#float scale:0.1 fieldwidth:50
	spinner spStandingMinBooks "最小数量的书籍:" pos:[16,43] width:149 height:16 range:[1,10000,1] type:#integer fieldwidth:50
	spinner spStandingMaxBooks "最大数量的书籍:" pos:[16,64] width:149 height:16 range:[1,10000,15] type:#integer fieldwidth:50
	
	GroupBox gbLeaning "倾斜的书籍" pos:[3,94] width:165 height:168
	checkbox chbLeaning "倾斜的书籍" pos:[85,92] width:17 height:17 checked:true type:#float
	radiobuttons rbLeftRight "" pos:[23,113] width:129 height:16 labels:#("左", "右", "兼有") default:3 columns:3
	spinner spLeaningProbability "概率(%):" pos:[62,134] width:103 height:16 range:[0,100,30] type:#float scale:0.1 fieldwidth:50
	spinner spLeaningMinBooks "最小数量的书籍:" pos:[16,155] width:149 height:16 range:[1,10000,1] type:#integer fieldwidth:50
	spinner spLeaningMaxBooks "最大数量的书籍:" pos:[16,176] width:149 height:16 range:[1,10000,10] type:#integer fieldwidth:50
	spinner spLeaningMinAngle "最小角度:" pos:[52,197] width:113 height:16 range:[0,70,5] type:#float fieldwidth:50
	spinner spLeaningMaxAngle "最大角度:" pos:[52,218] width:113 height:16 range:[0,70,25] type:#float fieldwidth:50
	spinner spLeaningDivergence "不同概率(%):" pos:[38,239] width:127 height:16 range:[0,100,80] type:#float fieldwidth:50
	
	GroupBox gbStacks "堆叠的书籍" pos:[2,270] width:165 height:202
	checkbox chbStacks "堆叠的书籍" pos:[85,269] width:17 height:17 checked:true type:#float
	radiobuttons rbStacksAlignType "" pos:[7,289] width:93 height:32 labels:#("对齐到中心", "对齐到前面") columns:1
	radiobuttons rbStacksInitialRotation "" pos:[7,322] width:106 height:16 labels:#("背面", "前面") columns:2
	label lbStacksProbability "概率: 10 %" pos:[15,342] width:150 height:13
	spinner spStacksMinBooks "最小数量的书籍:" pos:[15,364] width:149 height:16 range:[1,10000,8] type:#integer fieldwidth:50
	spinner spStacksMaxBooks "最大数量的书籍:" pos:[15,385] width:149 height:16 range:[1,10000,12] type:#integer fieldwidth:50
	spinner spStacksRotation "随机旋转(度):" pos:[33,406] width:131 height:16 range:[0,180,10] fieldwidth:50
	spinner spStacksOffset "随机偏移(%):" pos:[37,427] width:127 height:16 range:[0,100,10] fieldwidth:50
	spinner spStacksDivergence "不同概率(%):" pos:[37,448] width:127 height:16 range:[0,100,50] type:#float fieldwidth:50
	
	GroupBox gbShelves "书架" pos:[171,284] width:145 height:97
	label lbPoly "请选择书架" pos:[180,305] width:120 height:13 
	pickbutton pickShelfObj "拾取书架" pos:[195,323] width:100 height:20
	button btnCreateShelf "创建" pos:[195,351] width:100 height:20 enabled:false
	
	GroupBox gbPostpro "编辑" pos:[171,387] width:145 height:85
	button btnNewSeed "随机种子" pos:[195,447] width:100 height:20 
	spinner spMove "偏移:" pos:[185,406]  height:16 range:[-1000000,1000000,0] type:#worldunits fieldwidth:80
	spinner spVariation "变化:" pos:[185,425] height:16 range:[-1000000,1000000,0] type:#worldunits fieldwidth:80
	
	dotNetControl pbarPolki "System.Windows.Forms.ProgressBar" pos:[1,475] width:318 height:12 
	dotNetControl pbarRzad "System.Windows.Forms.ProgressBar" pos:[1,490] width:318 height:12 
	button btnDeleteRow "删除上步操作" pos:[172,83] width:145 height:25 enabled:true









	fn wysokosc obj = (obj.max.z - obj.min.z)
	fn szerokosc obj = (obj.max.y - obj.min.y)
	fn grubosc obj= (obj.max.x - obj.min.x)
	

	
	fn czyWyzsza k1 k2 =
	(
		local hk1 = k1.max.z - k1.min.z
		local hk2 = k2.max.z - k2.min.z
		case of
		(
			(hk1-hk2 < 0.0): -1
			(hk1-hk2 > 0.0): 1
			default: 0
		)
	)
	
	fn czyGrubsza k1 k2 =
	(
		local hk1 = k1.max.x - k1.min.x
		local hk2 = k2.max.x - k2.min.x
		case of
		(
			(hk1-hk2 < 0.0): -1
			(hk1-hk2 > 0.0): 1
			default: 0
		)
	)
	
	fn setProb =
	(
		if chbStanding.state == true and chbLeaning.state == false and chbStacks.state == false then spStandingProbability.enabled = false
			else if chbStanding.state == false and chbLeaning.state == true and chbStacks.state == false then spLeaningProbability.enabled = false
				else 
				(
					if chbStanding.state == true then spStandingProbability.enabled = true
					if chbLeaning.state == true then spLeaningProbability.enabled = true
				)
	)
	
	fn obrocWPionie obj prob=
	(
		--czy obrocic w pionie
		los = random 0 100
		if los < prob then
		(
			rotate obj (angleaxis 180 [0,1,0])
			fixpivot obj
			move obj [obj.max.x-obj.pos.x,0,obj.max.z-obj.pos.z]
		)
	)
	
	fn obrocWPoziomie obj prob=
	(
		--czy obrocic w poziomie
		los = random 0 100
		if los < prob then
		(
			rotate obj (angleaxis 180 [0,0,1])
			fixpivot obj
			move obj [obj.max.x-obj.pos.x,obj.max.y-obj.pos.y,0]
		)
	)
		
	fn skaluj listaskalowania calosc koncowka=
	(
		for obj in listaskalowania do
		(
			if ((classof obj) as string) != "Array" then
				about [0,0,0] scale obj [(calosc/koncowka),1,1]
			else
			(
				for obj2 in obj do
					if ((classof obj2) as string) != "BooleanClass" then
						about [0,0,0] scale obj2 [(calosc/koncowka),1,1]
			)
		)
	)
	
	fn ksiazkaDoStosu ksiazka stos =
	(
		if (stos[stos.count] == false) then
		(
			local bestwektor = wektorWyrownaniaX stos[1] ksiazka
			local wtmp
			for i = 1 to stos.count-1 do
			(
				wtmp = wektorWyrownaniaX stos[i] ksiazka
				if wtmp > bestwektor then bestwektor = wtmp
			)
			return bestwektor
		)
		else
		(
			local maxx = 0
			for i = 1 to stos.count-1 do
				if (stos[i].max.x > maxx) then maxx = stos[i].max.x
			return (maxx-ksiazka.min.x)
		)
	)
	
	fn stosDoKsiazki stos ksiazka=
	(
		if (stos[stos.count] == false) then
		(
			local bestwektor = wektorWyrownaniaX ksiazka stos[1]
			local wtmp
			for i = 1 to stos.count-1 do
			(
				wtmp = wektorWyrownaniaX ksiazka stos[i]
				if wtmp > bestwektor then bestwektor = wtmp
			)
			return bestwektor
		)
		else
		(
			local minx = 0
			for i = 1 to stos.count-1 do
				if (stos[i].min.x < minx) then minx = stos[i].min.x
			return (ksiazka.max.x-minx)
		)
	)
	
	fn stosDoStosu stoslewy stosprawy =
	(
		local minl = stoslewy[1].min.x
		local maxp = stosprawy[1].max.x
		for i = 1 to stoslewy.count-1 do
			if (stoslewy[i].min.x < minl) then minl = stoslewy[i].min.x
		for i = 1 to stosprawy.count-1 do
			if (stosprawy[i].max.x > maxp) then maxp = stosprawy[i].max.x
		return (maxp-minl)
	)
	
	fn wyrownaj lewyo =
	(
		local najp = 0.0
		local tmpret = 0.0
		for i = 0 to 2 do
		(
			if (listaUtworzonych.count-i)>0 then
			(
				if ((classof lewyo) as string) == "Array" and ((classof listaUtworzonych[listaUtworzonych.count-i]) as string) == "Array" then tmpret = (stosDoStosu lewyo listaUtworzonych[listaUtworzonych.count-i])
				if ((classof lewyo) as string) == "Array" and ((classof listaUtworzonych[listaUtworzonych.count-i]) as string) != "Array" then tmpret = (stosDoKsiazki lewyo listaUtworzonych[listaUtworzonych.count-i])
				if ((classof lewyo) as string) != "Array" and ((classof listaUtworzonych[listaUtworzonych.count-i]) as string) == "Array" then tmpret = (ksiazkaDoStosu lewyo listaUtworzonych[listaUtworzonych.count-i])
				if ((classof lewyo) as string) != "Array" and ((classof listaUtworzonych[listaUtworzonych.count-i]) as string) != "Array" then tmpret = (wektorWyrownaniaX lewyo listaUtworzonych[listaUtworzonych.count-i])
			)
			else exit
			if tmpret > najp then najp = tmpret
			if ((classof listaUtworzonych[listaUtworzonych.count-i]) as string) == "Array" then exit
		)
		return najp
	)
	
	fn wypelnijstanding calosc ost cpfn=
	(
		local maxx = 0
		if ((classof ost) as string) != "Array" then
			maxx = ost.max.x
		else
			for i = 1 to ost.count-1 do
				if (ost[i].max.x > maxx) then maxx = ost[i].max.x
			
		for i = 0 to listagrub.count-1 do
		(
			if (grubosc listagrub[listagrub.count-i] <= (calosc - maxx)) then
			(
				--mozna wstawic
				local newbook = cpfn listagrub[listagrub.count-i] pos:[-(grubosc listagrub[listagrub.count-i]),0,0]
				obrocWPionie newbook spVertFlip.value
				obrocWPoziomie newbook spHorFlip.value
				move newbook [wyrownaj newbook,0,0]
				maxx = newbook.max.x
				append listaUtworzonych newbook
			)
		)
		skaluj listaUtworzonych calosc maxx
	)
	
	fn stworzStos listaks minbooks maxbooks rotation_deg offset_per VertFlipProb HorFlipProb centruj czyRozny PrzewrocWPrawo=
	(
		local copyfn = case rbCopyType.state of
		(
			1: copy
			2: instance
			3: reference
		)
		local ostatnialos = -1
		local los = -1
		local stos = #()
		--losowanie zakresu
		local ileKsiazek = random minbooks maxbooks
		for i = 1 to ileKsiazek do
		(
			--losowanie roznej od ostatniej
			los = random 1 listaks.count
			while ((stos.count > 0) and (listaks.count > 1) and (los == ostatnialos)) do
				los = random 1 listaks.count
			local newbook = copyfn listaks[(los)] pos:[0,0,0]
			ostatnialos = los
			
			local gr = grubosc newbook
			obrocWPionie newbook VertFlipProb
			obrocWPoziomie newbook HorFlipProb
			centerPivot newbook
			if centruj == true then
				move newbook -newbook.pos
				else move newbook [-gr/2.0,0,0]
			local katPrzewrotu
			if przewrocWPrawo == true then katPrzewrotu = 90 else katPrzewrotu = -90
			rotate newbook (angleaxis katPrzewrotu [0,1,0])
			move newbook [0,0,((-newbook.pos.z)+(wysokosc newbook)/2.0)]
			--teraz jest na 0,0,0
			if stos.count > 0 then
				move newbook [0,0,stos[stos.count].max.z]
			append stos newbook
		)
		if centruj == true then
		(
			local bestY = 0.0
			for i in stos do
				if i.max.y > bestY then bestY = i.max.y
			for i in stos do
				move i [0,bestY,0]
		)
		if czyRozny == true then
		(
			--najdluzsza i najszersza (do procentowego przesuniecia)
			local najwyzsza = 0.0
			local najszersza = 0.0
			for n in listaks do
			(
				if wysokosc n > najwyzsza then najwyzsza = wysokosc n
				if szerokosc n > najszersza then najszersza = szerokosc n
			)
			for obj in stos do
			(
				--przesuniecie
				local randXOffset = random (((-offset_per/100.0)*najwyzsza)/2.0) (((offset_per/100.0)*najwyzsza)/2.0)
				local randYOffset = random (((-offset_per/100.0)*najszersza)/2.0) (((offset_per/100.0)*najszersza)/2.0)
				move obj [randXOffset,randYoffset,0]
				--rotacja
				local randRot = random (-rotation_deg/2.0) (rotation_deg/2.0)
				rotate obj (angleaxis randRot [0,0,1])
			)
		)
		--info czy prosty czy przekrecony (rozny)
		najwyzsza = wysokosc listawys[listawys.count]
		move stos [(-najwyzsza),0,0]
		append stos czyRozny
		return stos
	)
	
	fn szerokoscStosu czyRozny =
	(
		if czyRozny == false then
			return (wysokosc listawys[listawys.count])
		else
		(
			local przekrecona = ((wysokosc listawys[listawys.count])*cos (abs(spStacksRotation.value/2.0))+(szerokosc listawys[listawys.count])*cos (90.0 - abs(spStacksRotation.value/2.0)))
			local lenZwykla = (wysokosc listawys[listawys.count])+((spStacksOffset.value/100.0)*(wysokosc listawys[listawys.count]))
			local roznica = przekrecona - (wysokosc listawys[listawys.count])
			return (lenZwykla+roznica)
		)
	)
	
	fn wypelnijleaning calosc cpfn czyplus=
	(
		local kat = 0.0
		local maxx = 0.0
		local bestkat = 0.0
		if czyplus == true then kat = 90.0 else kat = -90.0
		if czyplus == true and ((classof listaUtworzonych[listaUtworzonych.count]) as string) != "Array" and (quatToEuler listaUtworzonych[listaUtworzonych.count].transform.rotation).y > 0.0001 then
			kat = (quatToEuler listaUtworzonych[listaUtworzonych.count].transform.rotation).y
		if czyplus == false and ((classof listaUtworzonych[listaUtworzonych.count]) as string) != "Array" and (quatToEuler listaUtworzonych[listaUtworzonych.count].transform.rotation).y < -0.0001 then
			kat = (quatToEuler listaUtworzonych[listaUtworzonych.count].transform.rotation).y
		
		los = random 1 listagrub.count
		local newbook = cpfn listagrub[los] pos:[-(grubosc listagrub[los]),0,0]
		local lastroznica = wysokosc newbook
		obrocWPionie newbook spVertFlip.value
		obrocWPoziomie newbook spHorFlip.value
		resetxform newbook
		move newbook [wyrownaj newbook,0,0]
		if (newbook.max.x ) <= calosc then
		(
			while ((czyplus == true and kat >= -0.0001) or (czyplus == false and kat >= -90.0001)) do
			(
				setrot newbook 0 kat 0
				move newbook [-newbook.max.x,0,-newbook.min.z]
				move newbook [wyrownaj newbook,0,0]
				if abs (newbook.max.x-calosc) < lastroznica then
				(
					lastroznica = abs (newbook.max.x-calosc)
					bestkat = kat
				)
				kat -= 1
			)
			if (bestkat >= spLeaningMinAngle.value) and (bestkat <= spLeaningMaxAngle.value) then
			(
				setrot newbook 0 bestkat 0
				move newbook [-newbook.max.x,0,-newbook.min.z]
				move newbook [wyrownaj newbook,0,0]
				append listaUtworzonych newbook
				maxx = newbook.max.x
			)
			else
			(
				delete newbook
				return false
			)
		)
		else
		(
			delete newbook
			return false
		)
		return true
	)
	
	fn stworzRzad dlugosc = 
	(
		seed (random 1 1000000)
		
		local copyfn = case rbCopyType.state of
		(
			1: copy
			2: instance
			3: reference
		)
		
		listaUtworzonych = #()
		local ostatnia = 0.0
		local ostatniStos = false
		local ksiazkaindex = listawys.count
		local StacksRoznyW = spStacksDivergence.value
		
		local StandingProbabilityW = spStandingProbability.value
		local LeaningProbabilityW = spLeaningProbability.value
		local StacksProbabilityW = StacksProbability
		
		--utworzenie pierwszej stojacej
		listaUtworzonych[1] = copyfn listawys[listawys.count] pos:[0,0,0]
		move listaUtworzonych[1] [-(grubosc listaUtworzonych[1]),0,0]
		
		local ostatniaWylosowana = listawys.count
		
		--petla
		while (dlugosc-ostatnia) > 0.0 do
		(
			pbarRzad.value = ((ostatnia as double / dlugosc as double))*100.0
			
			local losTypKsiazki = random 0.0 100.0
			--wybor typu, 1: stojace, 2: pochylone, 3: stosy
			if losTypKsiazki < StandingProbabilityW then typKsiazki = 1
				else if (losTypKsiazki < (StandingProbabilityW+LeaningProbabilityW)) then typKsiazki = 2
					else if StacksProbabilityW > 0 then typKsiazki = 3
						else
							typKsiazki = 0
					
			--jesli nic nie da sie wstawic
			if typKsiazki == 0 then exit
			else
			(
				--wylosowano stojace
				if typKsiazki == 1 then
				(
					--losowanie zakresu
					local ileKsiazek = random spStandingMinBooks.value spStandingMaxBooks.value
					for iter = 1 to ileKsiazek do
					(
						--wylosuj rozna od ostatniej, zabezpiecz sie przed sytuacja, w ktorej jest jedna ksiazka
						if listawys.count > 1 then
							while (ksiazkaindex == ostatniaWylosowana) do ksiazkaindex = random 1 listawys.count
						else random 1 listawys.count
						
						local newbook = copyfn listawys[ksiazkaindex] pos:[(-(grubosc listaUtworzonych[1]) - (grubosc listawys[ksiazkaindex]) - 1),0,0]
						
						if (((classof listaUtworzonych[listaUtworzonych.count]) as string) == "Array") then ostatnia = (newbook.pos.x+(wyrownaj newbook))

						if (ostatnia + (grubosc listawys[ksiazkaindex]) <= dlugosc) then
						(
							--mozna wstawic, obracaj
							obrocWPionie newbook spVertFlip.value
							obrocWPoziomie newbook spHorFlip.value
							
							obj_last = listaUtworzonych[listaUtworzonych.count]
							wektorPrzes = wyrownaj newbook
							
							move newbook [wektorPrzes,0,0]
							append listaUtworzonych newbook
							ostatnia = newbook.max.x
							ostatniaWylosowana = ksiazkaindex
						)
						else 
						(
							--nie miesci sie, rozdaj wypelnij i prawdopodobienstwa
							delete newbook 
							wypelnijstanding dlugosc listaUtworzonych[listaUtworzonych.count] copyfn
							
							StacksProbabilityW = 0
							StandingProbabilityW = 0
							LeaningProbabilityW = 0
							exit
						)
					)
				)
				
				if typKsiazki == 3 then
				(
					local niedasie = false
					centr = case rbStacksAlignType.state of
					(
						1: true
						2: false
					)
					przewr = case rbStacksInitialRotation.state of
					(
						1: false
						2: true
					)
					los = random 0.0 100.0
					local czyrozn
					if los <= StacksRoznyW then czyrozn = true else czyrozn = false
						
					--sprawdzenie czy sie zmiesci
					local szer = szerokoscStosu czyrozn
					obj_last = listaUtworzonych[listaUtworzonych.count]
					
					if ((classof obj_last) as string) != "Array" and (quatToEuler obj_last.transform.rotation).y > 0.0001 then
					(
						if StacksRoznyW != 100.0 then czyrozn = false else niedasie = true
					)
					
					--szukanie najbardziej wysunietego
					local wysuniety 
					if ((classof obj_last) as string) == "Array" then
					(
						local wysuniety = obj_last[1].max.x
						for iobj = 1 to obj_last.count-1 do
							if (obj_last[iobj].max.x > wysuniety) then wysuniety = obj_last[iobj].max.x
					)
					else wysuniety = obj_last.max.x
					
					if (dlugosc-wysuniety)>=szer then
					(
						if niedasie == false then
						(
							--zmiescil sie
							newstos = stworzStos listawys spStacksMinBooks.value spStacksMaxBooks.value spStacksRotation.value spStacksOffset.value spVertFlip.value spHorFlip.value centr czyrozn przewr
							--wyrownanie
							wektorPrzes = wyrownaj newstos
							--przesun
							for kkn = 1 to newstos.count-1 do
								move newstos[kkn] [wektorPrzes,0,0]
							--dodanie
							append listaUtworzonych newstos
							
							--szukanie maksa do progress bara
							local ostt = listaUtworzonych[listaUtworzonych.count]
							local maksymalny_x = ostt[1].max.x
							for iobj = 1 to ostt.count-1 do
								if (ostt[iobj].max.x > maksymalny_x) then maksymalny_x = ostt[iobj].max.x
							ostatnia = maksymalny_x
						)
					)
					else
					(
						--nie zmiescil sie
						if (czyrozn == true) and (StacksRoznyW != 100.0) then
							StacksRoznyW = 0
						else
						(
							--oddaj prawdopodobienstwa
							if (LeaningProbabilityW > 0 and StandingProbabilityW > 0) then
							(
								LeaningProbabilityW += StacksProbabilityW / 2.0
								StandingProbabilityW += StacksProbabilityW / 2.0
							)
							if (LeaningProbabilityW > 0 and StandingProbabilityW == 0) then
								LeaningProbabilityW += StacksProbabilityW
							if (LeaningProbabilityW == 0 and StandingProbabilityW > 0) then
								StandingProbabilityW += StacksProbabilityW
							
							StacksProbabilityW = 0
						)
					)
				)
				
				--wylosowano pochylone
				if typKsiazki == 2 then
				(
					local tabrotacji = #()
					local minrot = random spLeaningMinAngle.value spLeaningMaxAngle.value
					local maxrot = 0.0
					
					los = random 0.0 100.0
					if los < spLeaningDivergence.value then
					(
						minrot = random spLeaningMinAngle.value ((spLeaningMinAngle.value+spLeaningMaxAngle.value)/2.0)
						maxrot = random ((spLeaningMinAngle.value+spLeaningMaxAngle.value)/2.0) spLeaningMaxAngle.value
					)
					else maxrot = minrot
					
					--losowanie zakresu
					local ileKsiazek = random spLeaningMinBooks.value spLeaningMaxBooks.value
					--wypelnianie katami
					append tabrotacji minrot
					append tabrotacji maxrot
					
					if ileKsiazek > 2 then
					(
						for j = 1 to ileKsiazek-2 do
							append tabrotacji (random minrot maxrot)
					)

					sort tabrotacji
					local wlewo = false
					if rbLeftRight.state == 1 and not (((classof listaUtworzonych[listaUtworzonych.count]) as string) == "Array" and listaUtworzonych[listaUtworzonych.count][listaUtworzonych[listaUtworzonych.count].count] == true) then wlewo = true
					if rbLeftRight.state == 3 then
						if (random 0.0 1.0) > 0.5 and not (((classof listaUtworzonych[listaUtworzonych.count]) as string) == "Array" and listaUtworzonych[listaUtworzonych.count][listaUtworzonych[listaUtworzonych.count].count] == true) then wlewo = true
					
					if wlewo == true then
					(
						for j = 1 to tabrotacji.count do
							tabrotacji[j] = tabrotacji[j] * -1.0
					)
					else
					(
						for j = 1 to (tabrotacji.count/2) do
						(
							local tmpd = tabrotacji[j]
							tabrotacji[j] = tabrotacji[tabrotacji.count-j+1]
							tabrotacji[tabrotacji.count-j+1] = tmpd
						)
					)
					
					--jesli poprawny wybor
					if (not (wlewo == false and rbLeftRight.state == 1)) then
					(
						for iter = 1 to ileKsiazek do
						(
							--wylosuj rozna od ostatniej, zabezpiecz sie przed sytuacja, w ktorej jest jedna ksiazka
							if listawys.count > 1 then
								while (ksiazkaindex == ostatniaWylosowana) do ksiazkaindex = random 1 listawys.count
							else random 1 listawys.count
							
							local newbook = copyfn listawys[ksiazkaindex] pos:[(-(grubosc listaUtworzonych[1]) - (grubosc listawys[ksiazkaindex]) - 1),0,0]
							
							--obracaj
							obrocWPionie newbook spVertFlip.value
							obrocWPoziomie newbook spHorFlip.value
							resetxform newbook

							local moznaw = true
							--jesli nie sytuacja w ktorej pochylona do pochylonej pod mniejszym katem
							if (((classof listaUtworzonych[listaUtworzonych.count]) as string) != "Array") then
								if (wlewo == true) then
									if ((quatToEuler (listaUtworzonych[listaUtworzonych.count].transform.rotation)).y<-0.0001) then
										if ((quatToEuler (listaUtworzonych[listaUtworzonych.count].transform.rotation)).y < tabrotacji[iter]) then
											moznaw = false
										
							if (((classof listaUtworzonych[listaUtworzonych.count]) as string) != "Array") then
								if (wlewo == false) then
									if ((quatToEuler (listaUtworzonych[listaUtworzonych.count].transform.rotation)).y>0.0001) then
										if ((quatToEuler (listaUtworzonych[listaUtworzonych.count].transform.rotation)).y < tabrotacji[iter]) then
											moznaw = false
										
							if (moznaw == true) then
								setrot newbook 0 tabrotacji[iter] 0
							else
								setrot newbook 0 ((quatToEuler (listaUtworzonych[listaUtworzonych.count].transform.rotation)).y) 0
							
							move newbook [-(newbook.max.x-newbook.min.x),0,-(newbook.min.z)]
							
							wektorPrzes = wyrownaj newbook
							move newbook [wektorPrzes,0,0]

							if (newbook.max.x <= dlugosc) then
							(
								append listaUtworzonych newbook
								ostatnia = newbook.max.x
								ostatniaWylosowana = ksiazkaindex
							)
							else 
							(
								--nie miesci sie, rozdaj wypelnij i prawdopodobienstwa
								local rort = (quatToEuler (newbook.transform.rotation)).y
								local czypr = false
								if rort > 0.0001 then czypr = true
								delete newbook
								local te = wypelnijleaning dlugosc copyfn czypr
								if te == false and StandingProbabilityW > 0.0 then
									wypelnijstanding dlugosc listaUtworzonych[listaUtworzonych.count] copyfn
								else
								(
									local maxx = 0.0
									if ((classof listaUtworzonych[listaUtworzonych.count]) as string) != "Array" then
										maxx = listaUtworzonych[listaUtworzonych.count].max.x
									else
										for i = 1 to listaUtworzonych[listaUtworzonych.count].count-1 do
											if (listaUtworzonych[listaUtworzonych.count][i].max.x > maxx) then maxx = listaUtworzonych[listaUtworzonych.count][i].max.x
									skaluj listaUtworzonych dlugosc maxx
								)
								
								StacksProbabilityW = 0
								StandingProbabilityW = 0
								LeaningProbabilityW = 0
								exit
							)
						)
					)
					else
						if StandingProbabilityW == 0 and StacksProbabilityW == 0 then LeaningProbabilityW = 0
				)
			)
		)
		--usuniecie pierwszej
		delete listaUtworzonych[1]
		deleteitem listaUtworzonych 1
		
		Wynikowa = #()
		
		--czyszczenie utworzonych
		for element in listaUtworzonych do
		(
			if (classof element as string == "Array") then
			(
				if (classof element[element.count] as string == "BooleanClass") then deleteitem element element.count
				local elg = group element
				append Wynikowa elg
			)
			else append Wynikowa element
		)
		
		if (listaUtworzonych.count > 0) then
		(
			--presuniecie stosow
			if (spStandingProbability.value == 0.0 and spLeaningProbability.value == 0.0) then
			(
				grn = group Wynikowa
				grn.pivot = [0.0, 0.0, 0.0]
				
				los = random 0.0 10.0
				if los < 2.0 then
				(
					--przesun do prawej
					move grn [dlugosc-ostatnia,0,0]
				)
				if los >= 2.0 and los < 8.0 then
				(
					--przesun w losowe miejsce
					move grn [(random 0.0 (dlugosc-ostatnia)),0,0]
				)
				ungroup grn
			)
		)
		return Wynikowa
	)
	
	on spStacksMinBooks changed val do
		if val > spStacksMaxBooks.value then spStacksMaxBooks.value = val
	
	on spStacksMaxBooks changed val do
		if val < spStacksMinBooks.value then spStacksMinBooks.value = val
	
	on spStandingMinBooks changed val do
		if val > spStandingMaxBooks.value then spStandingMaxBooks.value = val
	
	on spStandingMaxBooks changed val do
		if val < spStandingMinBooks.value then spStandingMinBooks.value = val
	
	on spLeaningMinBooks changed val do
		if val > spLeaningMaxBooks.value then spLeaningMaxBooks.value = val
	
	on spLeaningMaxBooks changed val do
		if val < spLeaningMinBooks.value then spLeaningMinBooks.value = val
	
	on spLeaningMinAngle changed val do
		if val > spLeaningMaxAngle.value then spLeaningMaxAngle.value = val
	
	on spLeaningMaxAngle changed val do
		if val < spLeaningMinAngle.value then spLeaningMinAngle.value = val
			
	on btnCreateRow pressed do
	(
		--sortuj wg wysokosci
		qsort listawys czyWyzsza
		--sortuj wg grubosci
		qsort listagrub czyGrubsza
		
		--czysc wczesniej utworzone
		wspolczynniki = #()
		ks_pos_wekt = #()
		WszystkieWszystkie = #()
		
		max create mode
		spMove.value = 0
		spVariation.value = 0
		local grn = stworzRzad spLength.value
		if grn != undefined then
		(
			append WszystkieWszystkie grn
			for kss in grn do
			(
				if (classof kss as string == "Dummy") then 
				(
					local loss = random -1.0 1.0
					for elg in kss do
					(
						if (classof elg as string != "Dummy") then 
						(
							local listakstmp = #()
							append listakstmp elg
							append listakstmp elg.pos
							append listakstmp [0.0,1.0,0.0]
							append wspolczynniki loss
							append ks_pos_wekt listakstmp
						)
					)
				)
				else
				(
					local listakstmp = #()
					append listakstmp kss
					append listakstmp kss.pos
					append listakstmp [0.0,1.0,0.0]
					append wspolczynniki (random -1.0 1.0)
					append ks_pos_wekt listakstmp
				)
			)
		)
		pbarRzad.value = 0
		CompleteRedraw()
	)
	
	on spStandingProbability changed val do
	(
		--ustawianie prawdopodobienstw
		if val<(100.0-spLeaningProbability.value) then spStandingProbability.value = val else 
		(
			if spLeaningProbability.value > 0 then
			(
				spLeaningProbability.value = 100 - spStandingProbability.value
				spStandingProbability.value = val
			)
		)
		if chbStacks.state == true then 
		(
			StacksProbability = 100 - spStandingProbability.value - spLeaningProbability.value
			lbStacksProbability.text = "概率: "+(zaokr StacksProbability) as string+" %"
		)
		else spLeaningProbability.value = 100 - spStandingProbability.value
	)
	
	on spLeaningProbability changed val do
	(
		--ustawianie prawdopodobienstw
		if val<(100.0-spStandingProbability.value) then spLeaningProbability.value = val else
		(
			if spStandingProbability.value > 0 then
			(
				spStandingProbability.value = 100 - spLeaningProbability.value
				spLeaningProbability.value = val
			)
		)
		if chbStacks.state == true then
		(
			StacksProbability = 100 - spStandingProbability.value - spLeaningProbability.value
			lbStacksProbability.text = "概率: "+(zaokr StacksProbability) as string+" %"
		)
		else spStandingProbability.value = 100 - spLeaningProbability.value
	)

	on chbStanding changed state do
	(
		--wlaczanie/wylaczanie opcji
		if not (state == false and chbLeaning.state == false and chbStacks.state == false) then
		(
			if state == false then 
			(
				if chbLeaning.state == true and chbStacks.state == true then
				(
					spLeaningProbability.value += spStandingProbability.value / 2.0
					StacksProbability += spStandingProbability.value / 2.0
					lbStacksProbability.text = "概率: "+(zaokr StacksProbability) as string+" %."
				)
				else
				(
					if chbLeaning.state == true then spLeaningProbability.value += spStandingProbability.value
					if chbStacks.state == true then
					(
						StacksProbability += spStandingProbability.value
						lbStacksProbability.text = "概率: "+(zaokr StacksProbability) as string+" %."
					)
				)
				spStandingProbability.value = 0
			)
			spStandingProbability.enabled = state
			spStandingMinBooks.enabled = state
			spStandingMaxBooks.enabled = state
		)
		else chbStanding.state = true
		setProb()
	)
	
	on chbleaning changed state do
	(
		--wlaczanie/wylaczanie opcji
		if not (state == false and chbStanding.state == false and chbStacks.state == false) then
		(
			if state == false then 
			(
				if chbStanding.state == true and chbStacks.state == true then
				(
					spStandingProbability.value += spLeaningProbability.value / 2.0
					StacksProbability += spLeaningProbability.value / 2.0
					lbStacksProbability.text = "概率: "+(zaokr StacksProbability) as string+" %."
				)
				else
				(
					if chbStanding.state == true then spStandingProbability.value += spLeaningProbability.value
					if chbStacks.state == true then 
					(
						StacksProbability += spLeaningProbability.value
						lbStacksProbability.text = "概率: "+(zaokr StacksProbability) as string+" %."
					)
				)
				spLeaningProbability.value = 0
			)
			spLeaningProbability.enabled = state
			spLeaningMinBooks.enabled = state
			spLeaningMaxBooks.enabled = state
			rbLeftRight.enabled = state
			spLeaningMinAngle.enabled = state
			spLeaningMaxAngle.enabled = state
			spLeaningDivergence.enabled = state
		)
		else chbLeaning.state = true
		setProb()
	)
	
	on chbstacks changed state do
	(
		--wlaczanie/wylaczanie opcji
		if not (state == false and chbStanding.state == false and chbLeaning.state == false) then
		(
			if state == false then 
			(
				if chbLeaning.state == true and chbStanding.state == true then
				(
					spLeaningProbability.value += (StacksProbability / 2.0)
					spStandingProbability.value += (StacksProbability / 2.0)
				)
				else
				(
					if chbLeaning.state == true then spLeaningProbability.value += StacksProbability
					if chbStanding.state == true then spStandingProbability.value += StacksProbability
				)
				StacksProbability = 0
				lbStacksProbability.text = "概率: "+StacksProbability as string+" %."
			)
			StacksProbability = 0
			lbStacksProbability.text = "概率: 0 %"
			lbStacksProbability.enabled = state
			spStacksMinBooks.enabled = state
			spStacksMaxBooks.enabled = state
			spStacksRotation.enabled = state
			spStacksOffset.enabled = state
			spStacksDivergence.enabled = state
			rbStacksAlignType.enabled = state
			rbStacksInitialRotation.enabled = state
		)
		else chbStacks.state = true
		setProb()
	)
	
	on btnAdd pressed do
	(
	
		for o in selection do
		(
			fixpivot o
			appendifunique listawys o
		)
		lbBooks.text = "添加了[ "+(listawys.count)as string+" ]本书籍"
		sredniaGrubosc = 0
		for o in listawys do
		(
			sredniaGrubosc += grubosc o
			append listagrub o
		)
		--jesli sa dodane ksiazki, to wlacz button tworzenia rzedu i policz srednia
		if listawys.count != 0 then 
		(
			sredniaGrubosc /= listagrub.count
			btnCreateRow.enabled = true
		)
		if (obj_polka != undefined) then btnCreateShelf.enabled = true
	
)
	on btnDel pressed do
	(
		listawys = #()
		listagrub = #()
		btnCreateRow.enabled = false
		btnCreateShelf.enabled = false
		lbBooks.text = "删除成功"
		btnCreateShelf.enabled = false
	)
	
	on btnDeleteRow pressed do
	(
		if (WszystkieWszystkie.count >0) then
			for i in WszystkieWszystkie do try delete i catch()
		wspolczynniki = #()
		WszystkieWszystkie = #()
		ks_pos_wekt = #()
	)
	
	fn daj_kat objs nr =
	(
		local posv = polyop.getvert objs nr
		local edgesy = polyop.getEdgesusingVert objs nr
		local sasiedzi_e = #{}
		append sasiedzi_e ((edgesy as array)[1])
		append sasiedzi_e ((edgesy as array)[2])
		local vertexy = #{}
		vertexy += (polyop.getedgeverts objs ((sasiedzi_e as array)[1])) as bitarray
		vertexy += (polyop.getedgeverts objs ((sasiedzi_e as array)[2])) as bitarray
		deleteitem vertexy nr
		local vect1 = (polyop.getvert objs ((vertexy as array)[1])) - posv
		local vect2 = (polyop.getvert objs ((vertexy as array)[2])) - posv
		return (kat_miedzy_wektorami vect1 vect2)
	)
	
	fn update_polka =
	(
		try delete obj_polka catch()
		polka = copy pre_polka
		converttopoly polka
		pickShelfObj.text = pre_polka.name
		tab_sel = polyOp.getFaceSelection polka
		tab_all = #{}
		for i = 1 to polyop.getnumfaces polka do
			append tab_all i
		tab_inv = tab_all - tab_sel
		polyop.deleteFaces polka tab_inv delIsoVerts:true
		do_usuniecia = #{}
		for i = 1 to (polyop.getnumedges polka) do
		(
			if (polyop.getedgefaces polka i).count > 1 then
				append do_usuniecia i
		)
		polyop.setEdgeSelection polka do_usuniecia 
		polka.EditablePoly.Remove selLevel:#Edge
		do_usuniecia = #{}
		local kat_v = 0.0
		for i = 1 to (polyop.getnumverts polka) do
			if ((daj_kat polka i) > 130) then append do_usuniecia i 
		polyop.setVertSelection polka do_usuniecia 
		polka.EditablePoly.Remove selLevel:#Vertex
		obj_polka = polka
		lbPoly.text = "添加了"+(polyop.getnumfaces obj_polka as string) + " 个书架"
		hide obj_polka
	)
	
	on pickShelfObj picked obj do
	(
		pre_polka = obj
		update_polka()
		if (listawys.count > 0) then btnCreateShelf.enabled = true
	)
	
	fn dajpromien obj faceid =
	(
		local punkty = (polyop.getFaceEdges obj faceid) as array
		local srodek_w = polyop.getFaceCenter obj faceid
		local srodek_w = [srodek_w.x, srodek_w.y, 0.0]
		local wektor = obj.transform[2]
		local wektor_w = [wektor.x, wektor.y, 0.0]
		local posrednie = #()
		for k = 1 to 4 do
		(
			local krawedz = ((polyop.getFaceEdges obj faceid) as array)[k]
			local vert1 = polyop.getVert obj ((polyop.getEdgeVerts obj krawedz)[1])
			vert1 = [vert1.x, vert1.y, 0.0]
			local vert2 = polyop.getVert obj ((polyop.getEdgeVerts obj krawedz)[2])
			vert2 = [vert2.x, vert2.y, 0.0]
			local c1 = cross (vert1-srodek_w) wektor_w
			local c2 = cross (vert2-srodek_w) wektor_w
			if (c1.z*c2.z) < 0.00001 then
			(
				local tmp = #()
				if c1.z >= 0.0 then
				(
					append tmp ((polyop.getEdgeVerts obj krawedz)[1])
					append tmp ((polyop.getEdgeVerts obj krawedz)[2])
				)
				else
				(
					append tmp ((polyop.getEdgeVerts obj krawedz)[2])
					append tmp ((polyop.getEdgeVerts obj krawedz)[1])
				)
				append posrednie tmp
			)
		)
		
		local best_tk = 1
		local wt1 = (polyop.getVert obj posrednie[1][1])
		wt1 = [wt1.x, wt1.y, 0.0]
		local wt2 = (polyop.getVert obj posrednie[1][2])
		wt2 = [wt2.x, wt2.y, 0.0]
		local p_przeciecia = przeciecie (srodek_w) (srodek_w+wektor_w) wt1 wt2
		local minangle = (kat_miedzy_wektorami wektor_w (p_przeciecia-srodek_w))
				
		for tab_kraw = 2 to posrednie.count do
		(
			wt1 = (polyop.getVert obj posrednie[tab_kraw][1])
			wt1 = [wt1.x, wt1.y, 0.0]
			wt2 = (polyop.getVert obj posrednie[tab_kraw][2])
			wt2 = [wt2.x, wt2.y, 0.0]
			p_przeciecia = przeciecie (srodek_w) (srodek_w+wektor_w) wt1 wt2
			local kat_tmp = (kat_miedzy_wektorami wektor_w (p_przeciecia-srodek_w))
			if kat_tmp < minangle then
			(
				best_tk = tab_kraw
				minangle = kat_tmp
			)
		)
		
		local punkt_zaczepienia = posrednie[best_tk][1]
		local punkt_koncowy = posrednie[best_tk][2]

		local promien = #()
		local normalny = polyop.getfacenormal obj faceid
		--1 punkt zaczepienia, 2-x, 3-y, 4-z
		append promien (polyop.getVert obj punkt_zaczepienia)
		append promien ((polyop.getVert obj punkt_koncowy)-promien[1])
		
		local krawedzie_dzielace = (polyop.getEdgesUsingVert obj punkt_zaczepienia) as array
		local krawedz_wybrana = krawedzie_dzielace[1]
		local vertexy_z_krawedzi = polyop.getedgeverts obj krawedzie_dzielace[2]
		if (finditem vertexy_z_krawedzi punkt_koncowy) == 0 then krawedz_wybrana = krawedzie_dzielace[2]
		vertexy_z_krawedzi = polyop.getedgeverts obj krawedz_wybrana
		local szukany_vertex = vertexy_z_krawedzi[1]
		if szukany_vertex == punkt_zaczepienia then szukany_vertex = vertexy_z_krawedzi[2]
		
		local wektor_z_szukanego = ((polyop.getVert obj szukany_vertex)-promien[1])
		local iloczyn_wektorowy = cross promien[2] normalny

		if (kat_miedzy_wektorami wektor_z_szukanego iloczyn_wektorowy) < 90.0 then
			append promien iloczyn_wektorowy
		else
			append promien (-iloczyn_wektorowy)
		
		append promien normalny
		return promien
	)
	
	fn arrange_on_shelves =
	(
		--sortuj wg wysokosci
		qsort listawys czyWyzsza
		--sortuj wg grubosci
		qsort listagrub czyGrubsza
		
		--czysc wczesniej utworzone
		wspolczynniki = #()
		ks_pos_wekt = #()
		WszystkieWszystkie = #()

		for nr_face = 1 to polyop.getnumfaces obj_polka do
		(
			local promien = dajpromien obj_polka nr_face
			local dlugosc = distance (promien[1]) (promien[1]+promien[2])
			local utworzonyRzad = stworzRzad dlugosc
			if utworzonyRzad != undefined then
			(
				local grupatmp = group utworzonyRzad
				grupatmp.pivot = [0.0,0.0,0.0]
				move grupatmp promien[1]
				local tr = grupatmp.transform
				tr[1] = normalize promien[2]
				tr[2] = normalize promien[3]
				tr[3] = normalize promien[4]
				grupatmp.transform = tr
				ungroup grupatmp
				
				ktoryRzad = nr_face
				pbarPolki.value = ((ktoryRzad as double / ileRzedow as double))*100.0
				
				append WszystkieWszystkie utworzonyRzad
				
				for kss in utworzonyRzad do
				(
					if (classof kss as string == "Dummy") then 
					(
						local loss = random -1.0 1.0
						for elg in kss do
						(
							if (classof elg as string != "Dummy") then 
							(
								local listakstmp = #()
								append listakstmp elg
								append listakstmp elg.pos
								append listakstmp (normalize promien[3])
								append wspolczynniki loss
								append ks_pos_wekt listakstmp
							)
						)
					)
					else
					(
						local listakstmp = #()
						append listakstmp kss
						append listakstmp kss.pos
						append listakstmp (normalize promien[3])
						append wspolczynniki (random -1.0 1.0)
						append ks_pos_wekt listakstmp
					)
				)
			)
			CompleteRedraw()
		)
	)
	
	fn przesun_ksiazki =
	(
		for i = 1 to ks_pos_wekt.count do
		(
			local wariacja = spVariation.value*wspolczynniki[i]
			local pos_pierwotna = ks_pos_wekt[i][2]
			local przesuniecie = ks_pos_wekt[i][3]*spMove.value
			if spMove.value > 0.0 then
				ks_pos_wekt[i][1].pos = pos_pierwotna + ((normalize przesuniecie)*((length przesuniecie)+wariacja))
			if spMove.value < 0.0 then
				ks_pos_wekt[i][1].pos = pos_pierwotna + ((((normalize przesuniecie)*-1.0)*((length przesuniecie)-wariacja))*-1.0)
			if spMove.value == 0.0 then
				ks_pos_wekt[i][1].pos = pos_pierwotna + ks_pos_wekt[i][3]*wariacja
		)
	)
	
	fn aktualizuj_wspolczynniki =
	(
		wspolczynniki = #()
		for i in WszystkieWszystkie do
		(
			for kss in i do
			(
				if (classof kss as string == "Dummy") then 
				(
					local loss = random -1.0 1.0
					for elg in kss do
						if (classof elg as string != "Dummy") then append wspolczynniki loss
				)
				else
					append wspolczynniki (random -1.0 1.0)
			)
		)
	)
	
	on btnNewSeed pressed do
	(
		aktualizuj_wspolczynniki()
		przesun_ksiazki()
	)
	
	on spMove changed val do
	(
		przesun_ksiazki()
	)
	
	on spVariation changed val do
	(
		przesun_ksiazki()
	)
	
	on btnCreateShelf pressed do
	(
		update_polka()
		local moznaulozyc = true
		for i = 1 to polyop.getnumfaces obj_polka do
			if ((polyop.getFaceVerts obj_polka i) as array).count != 4 then moznaulozyc = false
		
		if (moznaulozyc) then
		(
			spMove.value = 0
			spVariation.value = 0
			max create mode
			ileRzedow = polyop.getnumfaces obj_polka
			arrange_on_shelves()
			pbarPolki.value = 0
			pbarRzad.value = 0
		)
		else
			messageBox "书架选择错误."
	)
	
	on Books_rollout open do
	(
	lbBooks.text="请添加书籍"
	lbBooks.ForeColor = (dotNetClass "System.Drawing.Color").FromArgb 100 220 50	
    lbBooks.BackColor = (dotNetClass "System.Drawing.Color").FromArgb 70 100 70	
	lbBooks.Font = dotNetObject "System.Drawing.Font" "黑体" 10
	lbBooks.TextAlign = (dotNetClass "System.Drawing.ContentAlignment").BottomCenter	
		
		
	)
	
	
	on Books_rollout close do
	(
		try delete obj_polka catch()
	)
)
createdialog Books_rollout 320 505 pos:mouse.screenpos style:#(#style_sysmenu, #style_toolwindow)
	