extends Node

var active = false;

var users = {};

signal new_user(name);
signal new_message(author, msg);

func _ready():
	GodotcordActivityManager.connect("activity_join", self, "_activity_join");
	
func create_lobby():
	if active:
		return;
	var peer = NetworkedMultiplayerGodotcord.new();
	peer.create_lobby(10, true);
	_init_peer(peer);
	
func connect_to_lobby(lobby_id, lobby_secret):
	if active:
		return;
	var peer = NetworkedMultiplayerGodotcord.new();
	peer.join_lobby(int(lobby_id), lobby_secret);
	_init_peer(peer);

func _activity_join(activity_secret):
	if active:
		return;
	var peer = NetworkedMultiplayerGodotcord.new();
	_init_peer(peer);
	peer.join_server_activity(activity_secret);
	
func _init_peer(peer):
	get_tree().network_peer = peer;
	peer.connect("connection_succeeded", self, "_connected");
	peer.connect("peer_connected", self, "_peer_connected");
	peer.connect("created_lobby", self, "_connected");
	#Change to Chat scene
	#TODO
	SceneSwitcher.change_scene_instant("res://Chat.tscn");
	
func _update_activity():
	var activity = GodotcordActivity.new();
	activity.state = "Chatting";
	activity.join_secret = get_tree().network_peer.get_lobby_activity_secret();
	activity.party_current = get_tree().network_peer.get_current_members();
	activity.party_max = get_tree().network_peer.get_max_members();
	activity.party_id = str(get_tree().network_peer.get_lobby_id());
	activity.start = OS.get_unix_time();
	
	GodotcordActivityManager.set_activity(activity);
	
func _connected():
	var user = GodotcordUserManager.get_current_user();
	_add_user(user);
	_update_activity();
	 
	
func _peer_connected(id):
	var user_id = get_tree().network_peer.get_user_id_by_peer(id);
	GodotcordUserManager.get_user(user_id)
	var user = yield(GodotcordUserManager, "get_user_callback");
	_add_user(user);
	
func _add_user(user):
	var peer_id = get_tree().network_peer.get_peer_id_by_user(user["id"]);
	users[peer_id] = user;
	
	emit_signal("new_user", user["name"]);
	
func close_connection():
	active = false;
	get_tree().network_peer.close_connection();
	DiscordGlobal.reset_activity();
	get_tree().network_peer = null;
	

remotesync func send_message(msg):
	var author;
	if (users.has(get_tree().get_rpc_sender_id())):
		#TOOD: is it really name?
		author = users[get_tree().get_rpc_sender_id()]["name"];
	else:
		author = "Unknown";
	
	emit_signal("new_message", author, msg);
