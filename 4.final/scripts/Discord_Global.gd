extends Node

var CLIENT_ID;

func _ready():
	Godotcord.init(CLIENT_ID, Godotcord.CreateFlags_DEFAULT);
	reset_activity();
	
func reset_activity():
	var activity = GodotcordActivity.new();
	activity.state = "Main menu";
	activity.details = "";
	activity.start = OS.get_unix_time();
	
	GodotcordActivityManager.set_activity(activity);
	
	
func _process(_delta):
	Godotcord.run_callbacks();

