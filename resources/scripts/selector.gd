extends Container

signal changed

@onready var mouse: Dictionary = {
	"button": null, 
	"pos": Vector2(0, 0), 
	"pressed": false
}

@export var use: bool = true:
	set(new_use):
		use = new_use
		$Left.disabled = not new_use
		$Right.disabled = not new_use
		$Name.editable = new_use

@export var margin: int = 4:
	set(new_margin):
		margin = new_margin
		self.sort_children.emit()

@export var button_size: int = 64:
	set(new_size):
		button_size = new_size
		self.rendering()
		self.sort_children.emit()

@export var num: int = 8:
	set(new_num):
		num = new_num
		self.start = min(new_num - 1, self.start)
		self.end = min(new_num, self.end)
		self.sort_children.emit()
var start = 0:
	set(new_start):
		start = max(min(new_start, self.num - 1), 0)
		if self.end <= new_start:
			self.end = new_start + 1
var end = 1:
	set(new_end):
		end = max(min(new_end, self.num), 1)
		if self.start >= new_end:
			self.start = new_end - 1

var code_name: String:
	get:
		return $Name.text
	set(new_name):
		$Name.text = new_name

var select: Array:
	get:
		return [self.start, self.end]
	set(new_select):
		self.start = new_select[0]
		self.end = new_select[1]
		self.rendering()

func standardization() -> void:
	self.start = int($Left.position.x / self.button_size)
	self.end = int(($Right.position.x + $Right.size.x) / self.button_size)

func _process(delta: float) -> void:
	if self.mouse.pressed:
		var offset = get_local_mouse_position().x - self.mouse.pos.x 
		if self.mouse.button == $Right:
			$Right.position.x += offset
		elif self.mouse.button == $Left:
			$Left.position.x += offset
		self.mouse.pos = get_local_mouse_position()
		self.rendering()

func _on_left_button_down() -> void:
	self.mouse = {
		'button': $Left,
		'pos': get_local_mouse_position(),
		'pressed': true
	}

func _on_right_button_down() -> void:
	self.mouse = {
		'button': $Right,
		'pos': get_local_mouse_position(),
		'pressed': true
	}
	
func add_margin() -> void:
	for child in get_children():
		child.position.x += self.margin

func rendering() -> void:
	if not self.mouse.pressed:
		$Left.position.x = self.start * self.button_size
		$Right.position.x = self.end * self.button_size - $Right.size.x
	$Selector.position.x = $Left.position.x
	$Selector.size.x = $Right.position.x + $Right.size.x - $Left.position.x
	$Name.size.x = $Selector.size.x
	$Name.position.x = $Selector.position.x + ($Selector.size.x - $Name.size.x) / 2

func _on_button_up() -> void:
	self.mouse.pressed = false
	self.standardization()
	self.rendering()
	self.add_margin()
	self.changed.emit()

func _on_sort_children() -> void:
	self.rendering()
	$Name.position.y = 0
	$Selector.position.y = $Name.size.y
	$Left.size = Vector2(4, $Selector.size.y)
	$Right.size = $Left.size
	$Left.position.y = $Selector.position.y
	$Right.position.y = $Selector.position.y
	self.add_margin()
	for child in self.get_children():
		child.position.y += self.margin / 2
	self.custom_minimum_size.x = self.num * self.button_size + self.margin * 2
	self.custom_minimum_size.y = $Selector.position.y + $Selector.size.y / 2 + self.margin
