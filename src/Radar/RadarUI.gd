extends MarginContainer

onready var radar = $Radar;
onready var player_sprite = $Radar/Player;

var player = null;
var player_position = Vector2.ZERO;
var objects = {};

export var size = Vector2(250, 250);
# scale: first number should equal size (above) and second number is maximum range of radar at default zoom
export var scale = (250.0 / 25000.0);

func add_object(object, texture):
	var sprite = Sprite.new();
	radar.add_child(sprite)
	sprite.texture = texture;
	objects[object] = sprite;

func remove_object(object):
	# This seems like a very flimsy fix for radar crashing when trying to remove player from dictionary
	# but without this the game will crash when freeing the player
	if object.is_in_group("player"):
		pass
	else:
		objects[object].queue_free();
		objects.erase(object);

func _physics_process(_delta: float) -> void:
	player_sprite.position = size;
#	player_position = player.global_position;
	player_position = PlayerState.active_ship.global_position;
	
	for object in objects.keys():
		if is_instance_valid(object):
			# if the object's distance relative to the player times the scale is more than the size of our radar, then the icon is invisible
			if (object.position - player_position).length() * scale > size.x:
				objects[object].visible = false;
			# Otherwise it should be visible
			else:
				objects[object].visible = true;
			# set the object's icon relative to the player icon
			objects[object].position = (object.global_position - player_position) * scale + size;
			
		else:
			remove_object(object);


func _on_Radar_body_exited(body: Node) -> void:
	remove_object(body);
