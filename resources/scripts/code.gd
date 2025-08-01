extends Container

signal changed

@export var button_size: int = 64:
	set(new_size):
		button_size = new_size
		$BitLine.button_size = new_size
		$Selector.button_size = new_size

@export var num: int = 8:
	set(new_num):
		num = new_num
		$BitLine.num = new_num
		$Selector.num = new_num

var code: Dictionary:
	get:
		return {
			'name': $Selector/Name.text,
			'code': $BitLine.bits.map(func(num): return num - 1),
			'select': $Selector.select
		}
	set(new_code):
		$Selector.code_name = new_code.name
		$Selector.select = new_code.select
		$BitLine.bits = new_code.code.map(func(num): return num + 1)

func list_add(list:Array, num: int) -> Array:
	var r = []
	for i in list:
		r.append(i + num)
	return r

func _ready() -> void:
	$BitLine.num = self.num
	$BitLine.button_size = self.button_size
	$Selector.num = self.num
	$Selector.button_size = self.button_size

func _on_sort_children() -> void:
	$BitLine.position.x = $Selector.margin
	$BitLine.position.y = $Selector.size.y
	self.custom_minimum_size = Vector2.ZERO
	self.size.x = $Selector.size.x
	self.size.y = $BitLine.position.y + $BitLine.size.y
	self.custom_minimum_size = self.size

func _on_bit_line_changed() -> void:
	self.changed.emit()
func _on_selector_changed() -> void:
	self.changed.emit()
