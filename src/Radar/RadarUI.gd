extends MarginContainer

onready var radar = $Radar;
onready var player_sprite = $Radar/Player;

var player = null;
var player_position = Vector2.ZERO;
var objects = {};

export var size = Vector2(250, 250);
# scale: first number should equal size (above) and second number is maximum range of radar at default zoom
export var scale = (250.0 / 40000.0);

func add_object(object, texture):
	var sprite = Sprite.new();
	radar.add_child(sprite)
	sprite.texture = texture;
#	uncomment the below to make sprites bigger
#	sprite.scale = Vector2(2,2)
	objects[object] = sprite;

func remove_object(object):
	objects[object].queue_free();
	objects.erase(object);

func _physics_process(delta: float) -> void:
	# MAY NOT NEED +90 TO ROTATION_DEGREES!!!!
	player_sprite.rotation_degrees = player.get_node("Sprite").rotation_degrees;
	player_sprite.position = size;
	player_position = player.position;
	
	for object in objects.keys():
		if is_instance_valid(object):
			# if the object's distance relative to the player times the scale is more than the size of our radar, then the icon is invisible
			if (object.position - player_position).length() * scale > size.x:
				objects[object].visible = false;
			# Otherwise it should be visible
			else:
				objects[object].visible = true;
			# if the object is an enemy sprite then we'll access its sprite and set the rotation degrees accordingly
#			if object.is_in_group("enemies"):
#				objects[object].rotation_degrees = object.get_node("Sprite").rotation_degrees + 90;
				
			# set the object's icon relative to the player icon
			objects[object].position = (object.position - player_position) * scale + size;
			# if the object is outside the maximum radius of our radar (radius of collision shape) then we'll also delete it
#			if (object.position - player_position).length() > 16800:
#				remove_object(object);
				
		else:
			remove_object(object);


func _on_Radar_body_exited(body: Node) -> void:
	remove_object(body);
