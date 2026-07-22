extends GutTest

var _event_bus: EventBus
var _received_events: Array[Dictionary] = []


func before_each() -> void:
	_event_bus = EventBus.new()
	_received_events.clear()


func after_each() -> void:
	_event_bus.free()


func _on_event_received(payload: Dictionary) -> void:
	_received_events.append(payload)


func test_subscribe_and_emit() -> void:
	_event_bus.subscribe(&"player_damaged", _on_event_received)
	_event_bus.emit_event(&"player_damaged", {"damage": 10})

	assert_eq(_received_events.size(), 1, "Should have received 1 event")
	assert_eq(_received_events[0]["damage"], 10, "Payload damage should match 10")


func test_unsubscribe() -> void:
	_event_bus.subscribe(&"player_damaged", _on_event_received)
	_event_bus.unsubscribe(&"player_damaged", _on_event_received)
	_event_bus.emit_event(&"player_damaged", {"damage": 10})

	assert_eq(_received_events.size(), 0, "Unsubscribed listener should not receive event")


func test_command_queue_and_flush() -> void:
	_event_bus.subscribe(&"move_command", _on_event_received)
	_event_bus.enqueue_command(&"move_command", {"x": 5, "y": 10})

	assert_eq(_received_events.size(), 0, "Queued command should not emit immediately")

	var flushed: Array[Dictionary] = _event_bus.flush_commands()
	assert_eq(flushed.size(), 1, "Should have flushed 1 command")
	assert_eq(_received_events.size(), 1, "Listener should receive event after flush")
	assert_eq(_received_events[0]["x"], 5, "Flushed payload data should match")
