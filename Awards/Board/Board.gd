extends PanelContainer


func update_data(array,index):

	$Body/Title.text = array[0][index]
	var winner = array[1][index].split(" -")
	if winner.size() > 1:
		$Body/Winner.text = winner[0] + "\n" + winner[1].replace("-","")
	elif winner.size() == 1:
		$Body/Winner.text =  winner[0].replace("-","") + "\n"
	
	##File Method
#	var file  = File.new()
#	if file.file_exists("res://Photos/"+winner[0].replace("-","")+".png"):
#		var img = load("res://Photos/"+winner[0].replace("-","")+".png")
#		$Body/WinnerPhoto.texture = img

	#GAS Method
	var images = get_parent().get_parent().get_node("imgLoader/ScrollContainer/VBoxContainer")
	if images.has_node( winner[0].replace("-","") ):
		var img = images.get_node( winner[0].replace("-","") ).texture
		$Body/WinnerPhoto.texture = img
	else:
		var img = load("res://icon.png")
		$Body/WinnerPhoto.texture = img
	
	for i in range($Body/Nominiees.get_child_count() ):
#		var photo = ""
		var n = $Body/Nominiees.get_child(i).get_node("Info/Nome")
		var t = $Body/Nominiees.get_child(i).get_node("Info/Turma")
		var p = $Body/Nominiees.get_child(i).get_node("Photo")
		var nominee = array[i+2][index].split(" -")
		if nominee.size() > 1:
			n.text = nominee[0]
			t.text = nominee[1].replace("-","")
		elif nominee.size() == 1:
			n.text = nominee[0].replace("-","")
		
#		file  = File.new()
#		if file.file_exists("res://Photos/"+n.text+".png"):
#			var img = load("res://Photos/"+n.text+".png")
#			p.texture = img
		if images.has_node( n.text ):
			var img = images.get_node( n.text ).texture
			p.texture = img
		else:
			var img = load("res://icon.png")
			p.texture = img
		
	pass
