extends Container

var selector = preload("res://scenes/selector.tscn")

signal changed

@export var button_size: int = 64:
	set(new_size):
		button_size = new_size
		$BitLine.button_size = new_size
		for child in $Control.get_children():
			child.button_size = new_size
@export var num: int = 8:
	set(new_num):
		num = new_num
		$BitLine.num = new_num
		for child in $Control.get_children():
			child.num = new_num

var code: Array:
	get:
		return $BitLine.bits
	set(new_code):
		$BitLine.bits = new_code

func _ready() -> void:
	$BitLine.num = num
	$BitLine.button_size = button_size

func _on_sort_children() -> void:
	$BitLine.size = $BitLine.custom_minimum_size
	$Control.size = Vector2(8 + $BitLine.size.x, 44.5)
	$BitLine.position.x = 4
	$BitLine.position.y = $Control.size.y
	self.custom_minimum_size.x = $Control.size.x
	self.custom_minimum_size.y = $BitLine.position.y + $BitLine.size.y
	$Background.size = self.size

func _on_bit_line_changed() -> void:
	self.changed.emit()

func add_name(code_name: String, select: Array) -> void:
	var child = self.selector.instantiate()
	$Control.add_child(child)
	child.use = false
	child.num = self.num
	child.start = select[0]
	child.end = select[1]
	child.code_name = code_name
	child.button_size = self.button_size
	child.rendering()

func clean() -> void:
	for child in $Control.get_children():
		$Control.remove_child(child)
		child.queue_free()
