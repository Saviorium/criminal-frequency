local EM = {}

EM.current_cursor = {x=0,
  				     y=0}

function EM.update()
	EM.current_cursor.x = (love.mouse.getX()) and love.mouse.getX() or 0
	EM.current_cursor.y = (love.mouse.getY()) and love.mouse.getY() or 0
	for _, object in pairs(objects_on_table) do
		if object:get_collision( EM.current_cursor.x, EM.current_cursor.y ) then
			object:mouse_enter_event() 
			object:set_status( 'active' )
	    else
			object:mouse_exit_event() 
			object:set_status( 'inactive' )
	    end
	end
end

function EM.mouse_click()
	for _, object in pairs(objects_on_table) do
		if object:get_status() == 'active' then
			object:on_mouse_click() 
	    end
	end
end

return EM