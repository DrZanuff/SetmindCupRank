extends Node

export (Array,VideoStreamWebm) var array : Array


func _ready():
	randomize()
	array.shuffle()
	var dir = Directory.new()
	dir.open("res://Videos/")
	dir.list_dir_begin(true,true)
	var filename = dir.get_next()
	while filename != "":
		if !dir.current_is_dir():
			array.push_back(dir.get_current_dir()+filename)
		filename = dir.get_next()
	


func _on_VideoPlayer_finished():
	pass # Replace with function body.


func play_video():
	
	
