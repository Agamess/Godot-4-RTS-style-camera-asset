extends Camera3D


func _process(delta):
	if Input.is_action_just_pressed("LMB"):
		var mouse_pos = get_viewport().get_mouse_position()
		var ray_lenght = 2000
		var from = project_ray_origin(mouse_pos)
		var to = from + project_ray_normal(mouse_pos) * ray_lenght
		var space = get_world_3d().direct_space_state
		var ray_query = PhysicsRayQueryParameters3D.new()
		ray_query.from = from
		ray_query.to = to
		var raycast_result = space.intersect_ray(ray_query)
		#print(raycast_result)
		if !raycast_result.is_empty():
			$"../..".mouse_pos = raycast_result["position"]
