extends Node

var CLIENT_ID;

func _ready():
	Godotcord.init(CLIENT_ID, 1);
	
	var activity = GodotcordActivity.new();
	activity.state = ""
	activity.details = "";
	activity.start = OS.get_unix_time();
	
	GodotcordActivityManager.set_activity(activity);
	
func _process(_delta):
	Godotcord.run_callbacks();

