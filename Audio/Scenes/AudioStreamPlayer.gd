extends AudioStreamPlayer

export (Array,AudioStreamOGGVorbis)var audios : Array
export (Array,AudioStreamOGGVorbis)var bg : Array

func _ready():
	var dir = Directory.new()
#	dir.open("res://Audio/")
	var path = OS.get_executable_path().get_base_dir()
	dir.open(path+"/Audio/")
	dir.list_dir_begin(true,true)
	var filename = dir.get_next()


	while filename != "":
		if !dir.current_is_dir():
			if filename.find(".import") == -1:
				
				var file = File.new()
				file.open(path+"/Audio/"+filename , file.READ_WRITE )
				var content = file.get_buffer( file.get_len() )
				file.close()
				
				var audio = AudioStreamOGGVorbis.new()
				audio.data = content
				
#				var sound = load(path+"/Audio/"+filename)
				var sound = audio
#				if sound is AudioStreamOGGVorbis:
#				print(path+"/Audio/"+filename)

				audios.push_back(sound)
		filename = dir.get_next()
		
	dir.list_dir_end()
	
	
	randomize()
	audios.shuffle()
	stream = audios[0]
	
	####GET BG MUSIC
	dir.open(path+"/Audio/BG Music/")
	dir.list_dir_begin(true,true)
	filename = dir.get_next()
	
	while filename != "":
		if !dir.current_is_dir():
			if filename.find(".import") == -1:
				
				var file = File.new()
				file.open(path+"/Audio/BG Music/"+filename , file.READ_WRITE )
				var content = file.get_buffer( file.get_len() )
				file.close()
				
				var audio = AudioStreamOGGVorbis.new()
				audio.data = content
				var sound = audio
				bg.push_back(sound)
				
		filename = dir.get_next()
		
	dir.list_dir_end()
	bg.shuffle()

func play_theme():
	audios.push_back(audios[0])
	audios.pop_front()
	stream = audios[0]
	play(0)

func play_bg():
	bg.push_back(bg[0])
	bg.pop_front()
	stream = bg[0]
	play(0)
