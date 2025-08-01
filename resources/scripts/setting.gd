extends Window

signal close(bit: int)

func _on_close_requested() -> void:
	self.close.emit($ScrollContainer/SettingList/Bit/BitSet.value)
	self.hide()
