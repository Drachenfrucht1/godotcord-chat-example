extends Node

var current_scene = null;

func _ready():
	var root = get_tree().get_root()
	current_scene = root.get_child(root.get_child_count() - 1)
	
#Run to switch scenes instantly. Only call from singletons other wise could crash the game
func change_scene_instant(path):
	current_scene.name = "old_scene"
	current_scene.queue_free()
	
	var s = ResourceLoader.load(path)
	current_scene = s.instance()
	
	# Add it to the active scene, as child of root.
	get_tree().get_root().add_child(current_scene)
	get_tree().get_root().move_child(current_scene, 0);

	# Optionally, to make it compatible with the SceneTree.change_scene() API.
	get_tree().set_current_scene(current_scene)
	
func change_scene(path):
	get_tree().call_deferred("change_scene_instant", path)
	
