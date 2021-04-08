extends Node2D

func _ready():
	GodotcordLobbyManager.connect("search_lobbies_callback", self, "_lobby_results");
	var param;
	GodotcordLobbyManager.search_lobbies(param, 10);

func _lobby_results(lobbies):
	for l in lobbies:
		var lobby_scene = preload("res://Lobby_Search_Result.tscn");
		#lobby_scene.$VBoxContainer/name.text = 

func _on_back_pressed():
	SceneSwitcher.change_scene_instant("res://Start_Menu.tscn");
