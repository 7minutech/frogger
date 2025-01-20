extends Node2D

@export var car_scene: PackedScene
@export var hoodless_scene: PackedScene
var rng = RandomNumberGenerator.new()
	
var lives = 3
# Called when the node enters the scene tree for the first time.
func _ready() -> void:
	new_game()
	pass # Replace with function body.


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta: float) -> void:
	pass

func new_game():
	lives = 3
	$Player.start($StartPosition.position)
	start_car_timers()
	$StartTimer.start()

func start_car_timers():
	$CarTimer.start(rng.randf_range(0.5,3.0))
	$HoodlessTimer.start(rng.randf_range(0.5,3.0))
	$TaxiTimer.start(rng.randf_range(0.5,3.0))
	$BridgeTimer.start()

func _on_player_hit() -> void:
	lives -= 1
	print(lives)
	$Player.start($StartPosition.position)
	pass # Replace with function body.

func _on_start_timer_timeout() -> void:
	pass # Replace with function body.

func spawn_car(spawn_point,speed):
	var car = preload("res://car.tscn").instantiate()
	add_child(car)
	car.position = spawn_point  # Adjust spawn position.
	car.linear_velocity = speed
	car.sleeping = false  # Prevent the body from sleeping.
	car.process_mode = Node2D.PROCESS_MODE_ALWAYS  
func spawn_hoodless():
	var hoodless_car = preload("res://hoodless.tscn").instantiate()
	add_child(hoodless_car)
	hoodless_car.position = $HoodlessStartPosition.position  # Adjust spawn position.
	hoodless_car.linear_velocity = Vector2i(-125,0)
	hoodless_car.sleeping = false  # Prevent the body from sleeping.
	hoodless_car.process_mode = Node2D.PROCESS_MODE_ALWAYS  
func spawn_taxi():
	var taxi = preload("res://taxi.tscn").instantiate()
	add_child(taxi)
	taxi.position = $TaxiStartPosition.position  # Adjust spawn position.
	taxi.linear_velocity = Vector2i(-150,0)
	taxi.sleeping = false  # Prevent the body from sleeping.
	taxi.process_mode = Node2D.PROCESS_MODE_ALWAYS  

func spawn_bridge(spawn_point):
	var bridge = preload("res://bridge.tscn").instantiate()
	add_child(bridge)
	bridge.position = spawn_point  # Adjust spawn position.
	bridge.linear_velocity = Vector2i(-100,0)
	bridge.sleeping = false  # Prevent the body from sleeping.
	bridge.process_mode = Node2D.PROCESS_MODE_ALWAYS  


func _on_car_timer_timeout() -> void:
	$CarTimer.stop()
	var rand_num = rng.randf_range(1,3)
	$CarTimer.start(rand_num)
	spawn_car($CarStartPosition1.position,Vector2i(rng.randi_range(-100,-100),0))
	spawn_car($CarStartPosition2.position,Vector2i(rng.randi_range(-150,-150),0))
	pass # Replace with function body.

func _on_hoodless_timer_timeout() -> void:
	$HoodlessTimer.stop()
	var rand_num = rng.randf_range(1,3)
	$HoodlessTimer.start(rand_num)
	spawn_hoodless()
	pass # Replace with function body.

func _on_taxi_timer_timeout() -> void:
	$TaxiTimer.stop()
	var rand_num = rng.randf_range(1,3)
	$TaxiTimer.start(rand_num)
	spawn_taxi()
	pass # Replace with function body.


func _on_bridge_timer_timeout() -> void:
	spawn_bridge($BridgeStartPosition1.position)
	pass # Replace with function body.
