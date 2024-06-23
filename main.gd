extends Node2D

var has_key = false
var valid_cells
var screenSize

# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_process(true)
	screenSize = get_viewport().get_visible_rect().size
	var rng = RandomNumberGenerator.new()
	var rndX = rng.randi_range(0, screenSize.x)
	var rndY = rng.randi_range(0, screenSize.y)
	$Key.position = Vector2(rndX, rndY)
	#update_key()
	#$Key.set_position(cells_to_use.pop_front() * cell_size + cell_size/2)
	


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func update_key():
	var pos
	var valid = false
	var target_shape = CircleShape2D.new()
	target_shape.radius = 16
	while !valid:
		var x1 = $Key.global_position.x + 16
		var y1 = $Key.global_position.y + 16
		var x2 = x1 + $Key/CollisionShape2D.shape.size.x - 32
		var y2 = y1 + $Key/CollisionShape2D.shape.size.y - 32
		pos = Vector2(randi_range(x1, x2), randi_range(y1, y2))
		var space_state = get_world_2d().direct_space_state
		var param = PhysicsShapeQueryParameters2D.new()
		param.shape = target_shape
		param.transform.origin = pos
		var result = space_state.intersect_shape(param)
		if result.size() == 0:
			valid = true

func _on_door_body_entered(body):
	if has_key == false:
		$Popup.dialog_text = "Find the key first!"
		$Popup.show()
	
	if has_key == true:
		$Popup.dialog_text = "You escaped the maze! Play again?"
		$Popup.show()
		


func _on_key_body_entered(body):
	has_key = true


func _on_door_body_exited(body):
	$Popup.hide()


func _on_key_body_exited(body):
	$Key/Sprite2D.hide()


func _on_popup_confirmed():
	if has_key == true:
		get_tree().reload_current_scene()
