extends Node


# * Platform related 
@export_group("Platform properties")
@export var platform_scene: PackedScene
var platform_storage = []
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

	print("Screen Height: ", screenHeight, " | 1/3 = ", screenHeight / 3)

	var platform = platform_scene.instantiate()
	var platformSpawn = $TopSpawner/platformSpawn
	platformSpawn.progress_ratio = randf()
	# print(platform.name, "instantiated at ", platform.position)
	platform.position = platformSpawn.position
	platform_storage.append(platform)
	add_child(platform)



# Called every frame. 'delta' is the elapsed time since the previous frame.
func _process(delta):

	if(platform_storage.back().position.y > randf_range(min_distance_y, max_distance_y)):
		var platform = platform_scene.instantiate()
		var platformSpawn = $TopSpawner/platformSpawn
		platformSpawn.progress_ratio = randf()
		# print(platform.name, "instantiated at ", platform.position)
		platform.position = platformSpawn.position
		platform_storage.append(platform)
		add_child(platform)

	if($Player.position.y < screenHeight - screenHeight / 4):
		# print("Player reached 1/4 of the screen!")
		for x in platform_storage:
			x.position.y += platformSpeed * delta
			# print(x.name, " is going down: ", x.position)
		
