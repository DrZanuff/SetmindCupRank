extends AudioStreamPlayer

export (Array,AudioStreamOGGVorbis)var audios : Array

func _ready():
	var dir = Directory.new()
	dir.open("res://Audio/")
	dir.list_dir_begin(true,true)
	var filename = dir.get_next()


	while filename != "":
		if !dir.current_is_dir():
			if filename.find(".import") == -1:
				var sound = load(dir.get_current_dir()+filename)
				if sound is AudioStreamOGGVorbis:
					audios.push_back(sound)
		filename = dir.get_next()

	randomize()
	audios.shuffle()
	stream = audios[0]


func play_audio():
	audios.push_back(audios[0])
	audios.pop_front()
	stream = audios[0]
	play(0)
