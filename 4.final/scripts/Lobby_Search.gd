extends Node2D

func _ready():
	GodotcordLobbyManager.connect("search_lobbies_callback", self, "_lobby_results");
	var param = [];
	GodotcordLobbyManager.search_lobbies(param, 10);

func _lobby_results(lobby: GodotcordLobby):
	var lobby_scene = preload("res://Lobby_Search_Result.tscn").instance();
	lobby_scene.get_node("VBoxContainer/name").text = String(lobby.id);
	lobby_scene.get_node("VBoxContainer/owner").text = "Owner: " + String(lobby.owner_id);
	lobby_scene.get_node("secret").text = lobby.secret;
	
	lobby_scene.get_node("join").connect("pressed", self, "_on_join", [String(lobby.id), String(lobby.secret)]);
	
	$ScrollContainer/VBoxContainer.add_child(lobby_scene);

func _on_join(id, secret):
	NetworkGlobal.connect_to_lobby(id, secret);
	

func _on_back_pressed():
	SceneSwitcher.change_scene_instant("res://Start_Menu.tscn");
