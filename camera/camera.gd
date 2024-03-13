extends Node3D

#movement
@export var speed = 50
@export var move_border = 10
var move_to:Vector3 = Vector3.ZERO

#nodes
@onready var camera = $rotation/Camera3D
@onready var camera_rotation = $rotation

#rotation
@export var max_rotation = 45
@export var min_rotation = 5
@export var rotation_curve:Curve

#zoom
var zoom = 0.8
@export var zoom_curve:Curve
@export var min_zoom = 5
@export var max_zoom = 25
@export var zoom_speed : float = 10.0

#camera smoothing
@export_range(0.02,1) var camera_zoom_smooth:float = 0.4
@export_range(0.02,1) var camera_move_smooth:float = 0.1

#move
@export var move_w_arrows = true
@export var move_w_mouse = true

#Global variabel
var mouse_pos : Vector3

#_____________________________________________________

#set values
func _ready():
	zoom_speed = zoom_speed / 200.0
	max_rotation -= min_rotation


#_____________________________________________________
func _physics_process(delta):
	#arrow movement
	var x : int
	var z : int
	if move_w_arrows:
		x = Input.get_axis("ui_left","ui_right")
		z = Input.get_axis("ui_down","ui_up")
	
	#mouse movement
	if move_w_mouse:
		var m_pos = get_viewport().get_mouse_position()
		if get_viewport().get_visible_rect().size.x - move_border < m_pos.x:
			x = 1
		if get_viewport().get_visible_rect().size.y - move_border < m_pos.y:
			z = -1
		if move_border > m_pos.x:
			x = -1
		if move_border > m_pos.y:
			z = 1
	
	#move
	move_to += Vector3(x,0,z*-1).normalized() * delta * speed * (zoom_curve.sample(zoom)+0.15)
	#var dir = global_position.direction_to(move_to)
	#global_position += dir * 40 * delta * camera_move_smooth
	global_position = lerp(global_position,move_to,camera_move_smooth)
	
	#change zoom
	if Input.is_action_just_released("zoom_out"):
		if zoom + zoom_speed < 1:
			zoom += zoom_speed
		else :
			zoom = 1
	if Input.is_action_just_released("zoom_in"):
		if zoom - zoom_speed > 0:
			zoom -= zoom_speed
		else:
			zoom = 0
	
	
	#apply zoom values
	var c_zoom = zoom_curve.sample(zoom)
	camera.position.y = lerp(camera.position.y, (c_zoom * (max_zoom-min_zoom)) + min_zoom,camera_zoom_smooth)
	
	#rotate camera
	var c_rotation = rotation_curve.sample(zoom)
	camera.rotation.x = lerp_angle(camera.rotation.x,deg_to_rad(-90 + c_rotation * (max_rotation/2)),camera_zoom_smooth)
	camera_rotation.rotation.x = lerp_angle(camera_rotation.rotation.x,deg_to_rad(min_rotation + c_rotation * (max_rotation/2)),camera_zoom_smooth)
	
