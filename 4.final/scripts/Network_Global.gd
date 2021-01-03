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
	peer.join_lobby(lobby_id, lobby_secret);
	_init_peer(peer);

func _activity_join(activity_secret):
	if active:
		return;
	var peer = NetworkedMultiplayerGodotcord.new();
	peer.join_server_activity(activity_secret);
	_init_peer(peer);
	
func _init_peer(peer):
	get_tree().network_peer = peer;
	peer.connect("network_peer_connected", self, "_peer_connected");
	peer.connect("created_server", self, "_update_activity");
	peer.connect("server_conected", self, "_update_activity");
	#Change to Chat scene
	
func _update_activity():
	var activity = GodotcordActivity.new();
	activity.state = "Chatting";
	activity.joinSecret = get_tree().network_peer.get_lobby_activity_secret();
	activity.start = OS.get_unix_time();
	
	GodotcordActivityManager.set_activity(activity);
	
func _peer_connected(id):
	var user_id = get_tree().network_peer.get_user_id_by_peer(id);
	GodotcordUserManager.get_user(user_id, self, "_user_return");
	
func _user_return(user):
	var peer_id = get_tree().network_peer.get_peer_id_by_user(user["id"]);
	users[peer_id] = user;
	
	emit_signal("new_user", user["name"]);

remotesync func send_message(msg):
	var author;
	if (users.has(get_tree().get_rpc_sender_id())):
		#TOOD: is it really name?
		author = users[get_tree().get_rpc_sender_id()]["name"];
	else:
		author = "Unknown";
	
	emit_signal("new_message", author, msg);
