extends Position2D

class_name Element

var speed = 15
var acc = 0
var element_name = ""
var element_score = 0
var element_pos = 0
var element_anchor_y = 0
var element_ranking_pos = 0 #Posição em Vetor relacioando ao pos do Rank

export(Resource) var type = null

export var shuffle = "shuffle"
var shuffle_time = 0
var shuffle_interval = 0.04


func _physics_process(delta):
	if global_position.y != element_ranking_pos:
		acc = lerp(acc+0.09,speed,0.02)
		shuffle = "shuffle"
		
	if global_position.y == element_ranking_pos:
		acc = 0
		shuffle = "stop"
		
	if shuffle == "shuffle":
		randomize()
		if shuffle_time < shuffle_interval:
			shuffle_time += delta
		if shuffle_time >= shuffle_interval:
			shuffle_time = 0
			$hbox/Postion.text = str( int(rand_range(0,10)), int(rand_range(0,10)) )
		
	if shuffle == "stop":
		def_pos(element_pos)
		shuffle = "idle"
		

	
	if global_position.y > element_ranking_pos:
		global_position.y = max(global_position.y-(speed * delta * acc) , element_ranking_pos)
	
	if global_position.y < element_ranking_pos:
		global_position.y = min(global_position.y+(speed * delta * acc) , element_ranking_pos)

func def_score(score):
	$hbox/Score.text = str(score)
	element_score = score

func def_anchor_y(y):
	element_anchor_y = y
	
func def_name(name):
	$hbox/Turma.text = str(name)
	element_name = name
	def_logo(name)
	

func def_logo(name):
	var file = File.new()
	if file.file_exists(str("res://Elemento/Fonts&Logos/",name,"/",name,".tres") ):
		type = load( str("res://Elemento/Fonts&Logos/",name,"/",name,".tres") )
		if type is Emblem:
			type.color2.a = 0.88
			$hbox/Logo/Draw.texture = type.logo
			$hbox/Logo/Draw.self_modulate = type.color1
			$hbox/Logo.get("custom_styles/normal").bg_color = type.color2
			$hbox/Turma.get("custom_fonts/font").font_data = type.font.font_data
			$hbox/Turma.get("custom_fonts/font").size = type.font_size
			$hbox/Turma.set("custom_colors/font_color",type.color1)
			$hbox/Turma.get("custom_styles/normal").bg_color = type.color2
			$hbox/Score.get("custom_styles/normal").bg_color = type.color2
			$hbox/Postion.get("custom_styles/normal").bg_color = type.color2
	else:
		print(str("Resource not Found ",name,".tres") )
	pass
	

func def_global_pos(x,y):
	global_position.x = x
	global_position.y = y

func def_pos(val):
	element_pos = val
	$hbox/Postion.text = str(element_pos,"º")
	element_ranking_pos = element_anchor_y + (element_pos * 72 )
