extends Node2D

@onready var tilemap = $TileMap
var has_key = false

# Called when the node enters the scene tree for the first time.
func _ready():
	var empty_cells = tilemap.get_used_cells_by_id(-1, -1, Vector2i(5, 0))
	empty_cells.shuffle()  # Randomly shuffle them
	var cell_size = tilemap.tile_set.tile_size
	$Key.set_position(empty_cells.pop_front() * cell_size + cell_size/2)
	$Door.set_position(empty_cells.pop_back() * cell_size + cell_size/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func _on_door_body_entered(body):
	if has_key == false:
		$Popup.dialog_text = "Find the key first!"
		$Popup.show()

	if has_key == true:
		$Popup.dialog_text = "You escaped the maze! Play again?"
		get_tree().paused = true
		$Popup.show()

func _on_key_body_entered(body):
	has_key = true


func _on_door_body_exited(body):
	$Popup.hide()


func _on_key_body_exited(body):
	$Key/Sprite2D.hide()
	$Key/PointLight2D.enabled = false


func _on_popup_confirmed():
	if has_key == true:
		get_tree().paused = false
		get_tree().reload_current_scene()
