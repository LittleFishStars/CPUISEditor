extends Container

var num: int = 8:
	get:
		return $Show.num
	set(new_num):
		num = new_num
		$ScrollContainer/CodeList.num = new_num
		$Show.num = new_num
		self.changed_show()
		self.file.bit = new_num
var button_size: int = 64:
	set(new_size):
		button_size = new_size
		$Show.button_size = new_size
		$ScrollContainer/CodeList.button_size = new_size

var file: Dictionary:
	get:
		return {
			'version': 1,
			'bit': $Show.num,
			'codes': $ScrollContainer/CodeList.codes
		}
	set(new_file):
		file = new_file
		$ScrollContainer/CodeList.num = new_file.bit
		$Show.num = new_file.bit
		self.changed_show()
		$ScrollContainer/CodeList.codes = new_file.codes

func _on_sort_children() -> void:
	$Show.size = $Show.custom_minimum_size
	$Show.position.x = (self.size.x - $Show.size.x) / 2
	$ScrollContainer.position.y = $Show.size.y
	$ScrollContainer.size.y = self.size.y - $Show.size.y
	$ScrollContainer.size.x = max($ScrollContainer.custom_minimum_size.x, $Show.size.x)
	self.custom_minimum_size.x = max($Show.size.x, $ScrollContainer.size.x)

func changed_show() -> void:
	$Show.clean()
	var this: Array = $Show.code
	for c in self.file.codes:
		var is_match = true
		for i in range(len(c.code)):
			if (c.code[i] >= 0) and (c.code[i] != this[i]):
				is_match = false
				break
		if is_match:
			$Show.add_name(c.name, c.select)

func clean() -> void:
	$ScrollContainer/CodeList.clean()
	self.changed_show()
