extends Node


# * Platform related 
@export_group("Platform properties")
@export var platform_scene: PackedScene
var last_platform: Object

signal lower_platform
@export var platformSpeed = 1000

# * MaxMin distance a platform can spawn
@export_group("Spawn Distance Properties")
@export var max_distance_x = 300
@export var min_distance_x = 50

@export var max_distance_y = 100
@export var min_distance_y = 50

@export var bottomOffset = 10

var screenHeight = RenderingServer.get_rendering_device().screen_get_height()


# Called when the node enters the scene tree for the first time.
func _ready():
	pass


# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(is_instance_valid(last_platform)):
		if(last_platform.position.y > randf_range(min_distance_y, max_distance_y)):
			var platform = platform_scene.instantiate()
			var platformSpawn = $TopSpawner/platformSpawn
			platformSpawn.progress_ratio = randf()
			# print(platform.name, "instantiated at ", platform.position)
			platform.position = platformSpawn.position
			last_platform = platform
			connect("lower_platform", platform.on_lower_platform)
			add_child(platform)
	else:
		var platform = platform_scene.instantiate()
		var platformSpawn = $TopSpawner/platformSpawn
		platformSpawn.progress_ratio = randf()
		# print(platform.name, "instantiated at ", platform.position)
		platform.position = platformSpawn.position
		last_platform = platform
		connect("lower_platform", platform.on_lower_platform)
		add_child(platform)

	var speedmod: float = 1

	if($Player): # * Check if player exists

		if($Player.velocity.y < 0):
			
			emit_signal("lower_platform", delta * $Player.velocity.y)


		if($Player.position.y > screenHeight * 1.5):
			print("Player died")
			# $Player.queue_free()

	
