extends Window

signal close(bit: int, button_size: int, scale: float)

var setting: Dictionary = {
	'bit': 8, 
	'size': 64,
	'scale': 1
}

func _on_close_requested() -> void:
	self.close.emit(
		$ScrollContainer/SettingList/Bit/BitSet.value, 
		$ScrollContainer/SettingList/Size/SizeSet.value,
		$ScrollContainer/SettingList/Scale/ScaleSet.value
	)
	self.hide()

func _on_visibility_changed() -> void:
	if self.visible:
		$ScrollContainer/SettingList/Bit/BitSet.value = self.setting['bit']
		$ScrollContainer/SettingList/Size/SizeSet.value = self.setting['size']
		$ScrollContainer/SettingList/Scale/ScaleSet.value = self.setting['scale']
