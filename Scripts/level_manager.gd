extends Node


# * Platform related 
@export_group("Platform properties")
@export var platform_scene: PackedScene
var last_platform: Object

signal lower_platform
@export var platformSpeed: float = 1000

# * MaxMin distance a platform can spawn
@export_group("Spawn Distance Properties")
@export var max_distance_x: float = 300
@export var min_distance_x: float = 50


@export var max_distance_y: float = 1000
@export var min_distance_y: float = 50

@export var bottomOffset = 10

@export var clamp_player_y_pos: bool = true
var screenHeight = RenderingServer.get_rendering_device().screen_get_height()

var PlayerAlive: bool
var GameStart: bool
var score: float

var dist_y_modifier: float = 0
var difficulty_level: float = 0
var difficulty_tracker: float = 0

# Called when the node enters the scene tree for the first time.
func _ready():
	PlayerAlive = true
	set_score(0)
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(is_instance_valid(last_platform)):

		# * Check distance from last platform
		# * Randomly creates y values from a range of min to max
		# * When random value is valid, spawns a platform
		if(last_platform.position.y > randf_range(clamp(min_distance_y + dist_y_modifier, min_distance_y, max_distance_y), max_distance_y)):

			# * Instatiate and set random location
			var platform = platform_scene.instantiate()
			var platformSpawn = $TopSpawner/platformSpawn
			platformSpawn.progress_ratio = randf()

			# Todo Clamp X distance spawning to min max distance

			platform.position = platformSpawn.position

			last_platform = platform

			# * Connect signal to instantiated child
			connect("lower_platform", platform.on_lower_platform)

			# * Add child to game node
			$TopSpawner/PlatformContainer.add_child(platform)

	if $Player.is_inside_tree() : # * Check if player exists

		# * Ensure platforms are reachable by player
		if(!GameStart):
			lower_platform.emit((delta * $Player.velocity.y))

		if($Player.position.y < screenHeight - bottomOffset):

			# * Clamp Player Y Position to half the screen size
			if(clamp_player_y_pos && $Player.position.y <= screenHeight / 2 ):
				GameStart = true
				$Player.position.y = screenHeight / 2


			# * Platforms move whenever player rises
			# if($Player.velocity.y < 0):

			# * Platforms move when player is rising AND at least half of screen height
			if(GameStart && $Player.velocity.y < 0 && $Player.position.y <= screenHeight / 2):
				var speed = delta * $Player.velocity.y
				lower_platform.emit(speed)
				add_score(speed)

		# print("Player Position ", $Player.position.y , " ", screenHeight - bottomOffset)

		if($Player.position.y > screenHeight * 1.5 && PlayerAlive):
			print("Player died")
			PlayerAlive = false
			GameStart = false
			$Player.GameStart = PlayerAlive
			$StartScreen/StartButton.visible = true

			# $Player.queue_free()

		if(difficulty_tracker > 1000 && difficulty_level < 5):
			difficulty_tracker = 0
			difficulty_level += 1
			dist_y_modifier = 50 * difficulty_level


func set_score(value: float):
	score = abs(value)

	if(score != 0):
		difficulty_level = floorf(score / 1000)
	$GameUI/score.text = "%.2fm" % score

func add_score(value: float):
	score += abs(value)
	difficulty_tracker += abs(value)
	$GameUI/score.text = "%.2fm" % score
	


func _on_button_pressed():

	despawnPlatforms()

	# * Spawn Initial platform
	var platform = platform_scene.instantiate()
	var platformSpawn = $TopSpawner/platformSpawn
	platformSpawn.progress_ratio = randf()
	# print(platform.name, "instantiated at ", platform.position)
	platform.position = platformSpawn.position
	last_platform = platform
	connect("lower_platform", platform.on_lower_platform)

	$TopSpawner/PlatformContainer.add_child(platform)

	$StartScreen/StartButton.visible = false

	dist_y_modifier = 0

	set_score(0)
	PlayerAlive = true
	pass # Replace with function body.

func despawnPlatforms():
	for child in $TopSpawner/PlatformContainer.get_children():
		child.queue_free()
	pass
