extends GutTest

var _registry: Registry
var _entity: Node2D
var _health_component: HealthComponent


func before_each() -> void:
	_registry = Registry.new()
	_entity = Node2D.new()
	_health_component = HealthComponent.new()
	add_child_autofree(_entity)


func after_each() -> void:
	if is_instance_valid(_health_component) and not _health_component.is_queued_for_deletion():
		_health_component.free()
	_registry.free()


func test_component_attachment() -> void:
	_entity.add_child(_health_component)
	assert_eq(_health_component.entity, _entity, "Component entity reference should set to parent")


func test_health_component_damage_and_heal() -> void:
	_entity.add_child(_health_component)
	_health_component.max_health = 100

	_health_component.take_damage(30)
	assert_eq(_health_component.current_health, 70, "Health should decrease by 30")
	assert_false(_health_component.is_dead(), "Entity should not be dead")

	_health_component.take_damage(70)
	assert_eq(_health_component.current_health, 0, "Health should reach 0")
	assert_true(_health_component.is_dead(), "Entity should be dead")

	_health_component.heal(50)
	assert_eq(_health_component.current_health, 0, "Dead entity should not heal above 0")


func test_registry_query() -> void:
	_registry.register_component(&"HealthComponent", _entity)

	var results: Array[Node] = _registry.get_entities_with_component(&"HealthComponent")
	assert_eq(results.size(), 1, "Registry should find 1 entity with HealthComponent")
	assert_eq(results[0], _entity, "Found entity should match original node")

	_registry.unregister_component(&"HealthComponent", _entity)
	results = _registry.get_entities_with_component(&"HealthComponent")
	assert_eq(results.size(), 0, "Registry should return empty array after unregistering")
