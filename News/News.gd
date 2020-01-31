extends Node

# 1800s = 30 minutos
var key = "60a9dd4bd7704cb4914a3e2819f6f494"
var link = ["https://newsapi.org/v2/top-headlines?country=br&category=technology&apiKey=",
			"https://newsapi.org/v2/top-headlines?country=br&category=science&apiKey="]

var news_array = []

var info = load("res://News/Info.tscn") 

func _ready() -> void:
	$Main/Body/News/Info.queue_free()
	get_news()


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response = body.get_string_from_utf8()
	var json = JSON.parse(response).result
	
	var n = json.articles.size()
	
	clear_news()
	
	if $Main/Body/News.get_child_count() > 0:
		$Main/Body/News.get_child(0).queue_free()
	
	for i in range(n):
		var title = json.articles[i].title
		var img = json.articles[i].urlToImage
		var desc = json.articles[i].description

		if desc != "":
			var news = $Main/Body/News
			
			var new_info = info.instance()
			news.add_child(new_info)
			
			if img != null:
				new_info.get_node("ImageRequest").request(img)
			new_info.get_node("VB/Body/TitleBody/VB/Title/t").text = title
			new_info.hide()
			new_info.set_time()
			news_array.push_back(new_info)
			
	$OverCurtain/Fade.play("FadeOut")
	$TimerSwap.start(15)

func _on_Timer_timeout() -> void:
	$TimerSwap.stop()
	$OverCurtain/Fade.play("FadeIn")
	get_news()

func get_news():
	$HTTPRequest.request(link[0]+key)
	link.push_back(link[0])
	link.pop_front()

func clear_news():
	news_array = []
	var news = $Main/Body/News
	for i in range( news.get_child_count()-1 ):
		if news.get_child(i).get_position_in_parent() != 0:
			news.get_child(i).queue_free()

func change_news():
	news_array[0].hide()
	news_array.push_back(news_array[0])
	news_array.pop_front()
	news_array[0].set_time()
	news_array[0].show()
	

func _on_TimerSwap_timeout():
	$Anim.play("Swap")

