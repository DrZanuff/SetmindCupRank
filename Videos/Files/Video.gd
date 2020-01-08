extends Node

export (Array,VideoStreamTheora) var array : Array


func _ready():

	var dir = Directory.new()
	var path = OS.get_executable_path().get_base_dir()
	dir.open(path+"/Videos/")
#	dir.open("res://Videos/")
	dir.list_dir_begin(true,true)

	var filename = dir.get_next()
	while filename != "":
		if !dir.current_is_dir():
			array.push_back( path+"/Videos/"+filename )
		filename = dir.get_next()

	randomize()
	array.shuffle()
	play_video()



func _on_VideoPlayer_finished():
	play_video()


func play_video():
	$VideoPlayer.stream = load(array[0])
	array.push_back(array[0])
	array.pop_front()
	$VideoPlayer.play()
	
