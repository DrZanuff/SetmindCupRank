extends Node

var url = "https://script.google.com/a/setmind.com.br/macros/s/AKfycby4h1_nt9QM5-IlEeAo7WdpqBLpIKHSnN7FHGRs/exec"
#var url = "http://www.json-generator.com/api/json/get/ceIHFlusjm?indent=2"
var type_of_connection = 0
var ranking #Updated Ranking
var new_ranking #New Ranking from request
var swap_ranking = [] #Array for swap and update the ranking array
var element = load("res://Elemento/Elemento.tscn")

var last_year_rank = [["Ultron",2595],["Zilla",2573],["Excalibur",2505],["Zebes",2503],["Smaug",2481],["Merlin",2099],["Han Solo",2061],["Tygra",2055],["Arton",2050],["Jango",2047],["Matrix",1986],["Yordle",1912],["Moltres",1910],["Thundera",1891],["Yoda",1729],["Korg",1643],["R2D2",1470],["Bat",1459],["Tatooine",1220]]

var new_req_time = 20 #Tempo do novo request

var is_requesting = false

func _ready():
	Input.set_mouse_mode(Input.MOUSE_MODE_HIDDEN)
	$Hud/Button_Req.connect("pressed",self,"btn_req_pressed")
	$TimerPos.connect("timeout",self,"TimerPos_time_out")
	$TimerReq.connect("timeout",self,"TimerReq_time_out")
	$HTTPRequest.request(url)



func btn_req_pressed():
	$HTTPRequest.request(url)

func _physics_process(delta):
	$BackGround/BG.texture_offset.x += 10 * delta
	
	if Input.is_action_just_pressed("ui_select") and is_requesting == false:
		owner.get_node("AnimationPlayer").play("FadeRestart")
		$Hud/Loading.show()
		is_requesting = true
		$HTTPRequest.request(url)
		
	
	if Input.is_action_just_pressed("ui_cancel"):
		get_tree().quit()


func _on_HTTPRequest_request_completed(result, response_code, headers, body):
	var r = body as PoolByteArray
	var j = JSON.parse(r.get_string_from_utf8())
	var arr = j.result
	
	$Hud/Output.text = ""
	
	
	if arr.size() > 0:
		for i in arr:
			$Hud/Output.text += str(i[0],":  ") 
			$Hud/Output.text += str(i[1],"\n\n")
	else:
		print("Error!")
	
	if type_of_connection == 0:
		ranking = arr
	if type_of_connection == 1:
		new_ranking = arr
	update_ranking(type_of_connection)
	

func update_ranking(type):
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.play_theme()
	var instance_last_year = false
	var date = OS.get_date()

	#SetmindCup 2020 10/02/2020
	instance_last_year = OS.get_unix_time() < 1581321600
#	instance_last_year = OS.get_unix_time() < 1579507200

	if instance_last_year:
		if type == 0:
			instanciate_elements(last_year_rank)
		if type == 1:
			reorder_rank(last_year_rank)
	else:
		$Art/Title.text = "Setmind Cup 2020"
		if type == 0:
			instanciate_elements(ranking)
		if type == 1:
			reorder_rank(new_ranking)


func reorder_rank(rank):
	new_ranking = rank
	var camera_focus
	
#	swap_ranking.resize( ranking.size() )
	swap_ranking = ranking
	for i in range( swap_ranking.size() ):
		if new_ranking[i][0] != ranking[i][0]:
			swap_ranking[i] = null
			break
	
	#Acha onde deve haver o foco
	for i in range(swap_ranking.size() ):
		if swap_ranking[i] == null:
			camera_focus = i
	
	ranking = new_ranking
	# Faz uma busca em cada Elemento filho do Node Ranking
	# e compara se o nome é o mesmo da Ranking novo
	for i in range( $Ranking.get_child_count() ):
		for v in range( ranking.size() ):
			if $Ranking.get_child(i).element_name == ranking[v][0]:
				var e = $Ranking.get_child(i) as Element
				e.def_pos(v+1)
				e.def_score(ranking[v][1])
	#Inicia o Timer para fazer novas requests com o passar do tempo
#	$TimerReq.start(new_req_time)
	is_requesting = false
	$Hud/Loading.hide()
	if camera_focus != null:
		$Camera.scroll_target(camera_focus)


func instanciate_elements(rank):
	ranking = rank
	
	var index = 0
	for i in ranking:
		var new_element = element.instance() as Element # Instancia como Elemento
		get_node("Ranking").add_child(new_element)
		new_element.def_anchor_y($Pos.global_position.y)
		new_element.def_name(i[0]) #Definie nome
		new_element.def_logo(i[0]) #Define logo e arte
		new_element.def_score(i[1]) #Define Score
		new_element.def_pos(index+1) # Define Pos do Ranking
		#Pega o root e o X eo Y do Pos
		var x = get_node("Pos").global_position.x
		var y = get_node("Pos").global_position.y + ( (index * 72) )
		new_element.def_global_pos(x,y) # Define a position do element
		index += 1
	$Hud/ColorRect/Label/AnimationPlayer.play("Fade")
	$Hud/Loading.hide()
	$End.global_position.x = $Pos.global_position.x
	$End.global_position.y = $Pos.global_position.y + (ranking.size() * 72)
	$Camera.scroll_down()
	type_of_connection = 1
	#Inicia o Timer para fazer novas requests com o passar do tempo
#	$TimerReq.start(new_req_time)

func TimerPos_time_out():
	if $Camera.type == "idle":
		randomize()
		var last_node = $Ranking.get_child_count() * 72
		var rand = int(rand_range( -72,72 ) )
		$Camera.target = clamp($Camera.target+rand,0, last_node) 
		
func TimerReq_time_out():
	print("Fazendo nova Request")
	$HTTPRequest.request(url)


func _on_AudioStreamPlayer_finished():
	$AudioStreamPlayer.stop()
	$AudioStreamPlayer.play_bg()
	pass # Replace with function body.
