extends Node2D

@onready var tilemap = $TileMap
var has_key = false
var screensize
var valid_cells
# Called when the node enters the scene tree for the first time.
func _ready():
	randomize()
	set_process(true)
	screensize = get_viewport().get_visible_rect().size
	get_valid_cells() # Compute the valid cells in the tilemap
	var cells_to_use = valid_cells.duplicate() # Copy the cells
	cells_to_use.shuffle()  # Randomly shuffle them
	var cell_size = tilemap.tile_set.tile_size
	$Key.set_position(cells_to_use.pop_front() * cell_size + cell_size/2)


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):
	pass

func get_valid_cells() -> void:
	valid_cells = []
	for cell in tilemap.get_used_cells(0):
		valid_cells.append(cell)

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
