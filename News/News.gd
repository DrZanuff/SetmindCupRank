extends Node

# 1800s = 30 minutos
var key = "60a9dd4bd7704cb4914a3e2819f6f494"
var link = ["https://newsapi.org/v2/top-headlines?country=br&category=technology&apiKey=",
			"https://newsapi.org/v2/top-headlines?country=br&category=science&apiKey=",
			"https://newsapi.org/v2/top-headlines?country=br&category=business&apiKey="]
func _ready() -> void:
	get_news()


func _on_HTTPRequest_request_completed(result: int, response_code: int, headers: PoolStringArray, body: PoolByteArray) -> void:
	var response = body.get_string_from_utf8()
	var json = JSON.parse(response).result
	
	var n = clamp( json.articles.size() , 0 , 8 )
	
	for i in range(n):
		var title = json.articles[i].title
		var img = json.articles[i].urlToImage
		var desc = json.articles[i].description
		var content = json.articles[i].content
		
		var find = str(content).find("[+")
		content = str(content).left(find) + "..."
		
		
		var news = $Main/Body/News
		
		if img != null:
			news.get_child(i).get_node("ImageRequest").request(img)
			if get_visibles() < 4:
				news.get_child(i).show()
		else:
			news.get_child(i).hide()
		
		news.get_child(i).get_node("PC/VB/Title/t").text = title
		news.get_child(i).get_node("PC/VB/Desc/d").text = desc + "\n\n" + content


func get_visibles():
	var visibles = 0
	var news = $Main/Body/News
	for i in news.get_children():
		if i.visible:
			visibles+=1
	
	return visibles

func _on_Timer_timeout() -> void:
	get_news()


func get_news():
	$HTTPRequest.request(link[0]+key)
	link.push_back(link[0])
	link.pop_front()
	pass
