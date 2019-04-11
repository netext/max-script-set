---By Ｄ.調dē嘩麗  撰写
(
	a = getcurrentselection();d = 0;f = 0
	if (a.count != 0) then
		(
			for i = 1 to a.count do 
				(
					b = getTransformLockFlags a[i];c = b[1]
					if c == false then    
						(
						d+=1   --d = 4  d = 3 d = 0
						)
					else
					(
						f+=1   -- f = 0 f = 1 f = 4
					)
				)
			if d <= a.count and d != 0 then
				(
					for i in a do setTransformLockFlags i #all
					displayTempPrompt ("锁定成功！！！")5000
					print "锁定成功！！！"
				)
			else if f == a.count then
				(
					for i in a do setTransformLockFlags i #none
					displayTempPrompt ("解锁成功！！！")5000
					print "解锁成功！！！"
				)
		)
	else(messagebox "请选择锁定物体")

)