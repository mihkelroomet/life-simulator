extends Resource

@export var curve : Curve

func _init(points_array : Array = []):
	curve = Curve.new()
	curve.min_value = -1.0
	for point : Vector2 in points_array:
		curve.add_point(point)

func sample(offset : float) -> float:
	return curve.sample(offset)
