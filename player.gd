extends Node2D		

signal hit
@onready var tile_map =  $"../TileMap2"
@onready var player_sprite = $Sprite2D
@onready var bridge =  $"../bridge"

var is_moving = false
func _physics_process(delta: float) -> void:
	if is_moving == false:
		return
	if global_position == player_sprite.global_position:
		is_moving = false
		return
	player_sprite.global_position = player_sprite.global_position.move_toward(global_position,1)
	
func _process(delta: float) -> void:
	if is_moving:
		return
	if Input.is_action_pressed("up"):
		move(Vector2.UP)
	elif Input.is_action_pressed("down"):
		move(Vector2.DOWN)
	elif Input.is_action_pressed("right"):
		move(Vector2.RIGHT)
	elif Input.is_action_pressed("left"):
		move(Vector2.LEFT)

func move(direction: Vector2):
	#Get current tile vector2i
	var current_tile: Vector2i = tile_map.local_to_map(global_position)
	#Get target tile vector2i
	var target_tile: Vector2i = Vector2i(
		current_tile.x + direction.x,
		current_tile.y + direction.y
	)
	#Get custom data layer from target tile
	var tile_data: TileData = tile_map.get_cell_tile_data(0,target_tile)
	
	if tile_data.get_custom_data("walkable") == false:
		return
	
	#Move Player
	is_moving = true
	global_position = tile_map.map_to_local(target_tile)
	player_sprite.global_position = tile_map.map_to_local(current_tile)
	


func _on_area_2d_body_entered(body: Node2D) -> void:
	if body.is_in_group("bridge"):
		return
	print("hit")	
	hide()
	hit.emit()
	$Area2D/CollisionShape2D.set_deferred("disabled", true)
	pass # Replace with function body.

func start(pos):
	position = pos
	show()
	await get_tree().create_timer(0.5).timeout
	$Area2D/CollisionShape2D.disabled = false
