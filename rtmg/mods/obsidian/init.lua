-- Obsidian mod, originally made by <???>
-- modifed by rtmmp-team

minetest.register_node("obsidian:obsidian_block", {
	description="Obsidian",
	tile_images = {"obsidian_block.png"},
	inventory_image = minetest.inventorycube("obsidian_block.png"),
	is_ground_content = true,
	is_ground_content = true,
	groups = {fastness = 1, level = 3},
	sounds = default.node_sound_stone_defaults(),
	drop = {
		max_items = 1,
		items = {
			{
				 items = {"obsidian:obsidian_block"},
				 tools = {"default:pick_mese"},
			}
		 }
	}
})

local function check_water(pos, dx, dy, dz)
	local n = minetest.env:get_node({x = pos.x + dx, y = pos.y + dy, z = pos.z + dz}) 
	return n.name == "default:water_flowing" or n.name == "default:water_source"
end

local function find_water(pos)
	return check_water(pos, -1, 0, 0) or check_water(pos, 1, 0, 0)
		or check_water(pos, 0, -1, 0) or check_water(pos, 0, 1, 0)
		or check_water(pos, 0, 0, -1) or check_water(pos, 0, 0, 1)
end

local function replace(pos, dx, dy, dz)
	if check_water(pos, dx, dy, dz) then
		minetest.env:remove_node({x = pos.x + dx, y = pos.y + dy, z = pos.z + dz})
	end
end

local function replace_water(pos)
	replace(pos, -1, 0, 0)
	replace(pos, 1, 0, 0)
	replace(pos, 0, -1, 0)
	replace(pos, 0, 1, 0)
	replace(pos, 0, 0, -1)
	replace(pos, 0, 0, 1)
end

minetest.register_abm({
	nodenames = {"default:lava_flowing"},
	neighbors = {"default:water_source", "default:water_flowing"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		if find_water(pos) then
			replace_water(pos)
			minetest.env:add_node(pos, {name="default:cobble"})
		end
	end
})

minetest.register_abm({
	nodenames = {"default:lava_source"},
	neighbors = {"default:water_source", "default:water_flowing"},
	interval = 1,
	chance = 1,
	action = function(pos, node)
		if find_water(pos) then
			replace_water(pos)
			minetest.env:add_node(pos, {name="obsidian:obsidian_block"})
		end
	end
})
