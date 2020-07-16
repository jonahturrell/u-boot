function love.load()
	--screen size
	screen = {}
	screen.x = 800
	screen.y = 600
	love.window.setMode(screen.x, screen.y)
	

	--colors
	colors = {}
	colors.red = {255, 0, 0}
	colors.green = {0, 255, 0}
	colors.blue = {0, 0, 255}
	colors.lightBlue = {0, 50, 255}
	colors.black = {255, 255, 255}
	
	love.graphics.setBackgroundColor (colors.lightBlue) 

	--crosshair
	crosshair = {}
	

	crosshair.pos = {}
	crosshair.pos.x = screen.x/2
	crosshair.pos.y = screen.y/2

	crosshair.moveSpeed = 500
	crosshair.rotation = 0
	crosshair.rotationSpeed = 2.5

	crosshair.sprite = {}
	crosshair.sprite.image = love.graphics.newImage("assets/crosshair.png")
	crosshair.sprite.height = 32
	crosshair.sprite.width = 32
	
	--missile
	missile = {}

	missile.pos = {}
	missile.pos.x = 300
	missile.pos.y = 300
	
	missile.moveSpeed = 100
	missile.rotation = 0

	missile.target = {}
	missile.target.x = 0
	missile.target.y = 0

	missile.sprite = {}
	missile.sprite.image = love.graphics.newImage("assets/ball.png")
	missile.spriteSize = 32

	--mouse
	mouse = {}
	mouse.pos = {}
	
	--gui
	gui = {}

	gui.pos = {}
	gui.pos.y = screen.y * .8
	gui.pos.x = 0

	gui.size = {}
	gui.size.y = screen.y * .2
	gui.size.x = screen.x

	--ground
	ground = {}

	ground.pos = {}
	ground.pos.y = screen.y * .5
	ground.pos.x = 0

	ground.size = {}
	ground.size.y = screen.y * .5
	ground.size.x = screen.x

end

function love.update(dt)
	--crosshair movement
	mouse.pos.x, mouse.pos.y = love.mouse.getPosition()

	if (crosshair.pos.x > mouse.pos.x) then crosshair.pos.x = crosshair.pos.x - crosshair.moveSpeed * dt end
	if (crosshair.pos.x < mouse.pos.x) then crosshair.pos.x = crosshair.pos.x + crosshair.moveSpeed * dt end
	if (crosshair.pos.y > mouse.pos.y) then crosshair.pos.y = crosshair.pos.y - crosshair.moveSpeed * dt end
	if (crosshair.pos.y < mouse.pos.y) then crosshair.pos.y = crosshair.pos.y + crosshair.moveSpeed * dt end

	--crosshair rotation
	crosshair.rotation = crosshair.rotation - crosshair.rotationSpeed * dt
	
	--crosshair scaling
	crosshairScale = 0.25 + (crosshair.pos.y * .0025) 

	--crosshair enable/disable
	if (crosshair.pos.y >= gui.pos.y) then love.mouse.setVisible(true) end
	if (crosshair.pos.y < gui.pos.y) then love.mouse.setVisible(false) end



	--missile launch
	if (love.mouse.isDown(1) and crosshair.pos.y < gui.pos.y)  then
		--set targets
		missile.target.x = crosshair.pos.x
		missile.target.y = crosshair.pos.y
		--move missile to air
		if (missile.pos.x > missile.target.x) then missile.pos.x = missile.pos.x - missile.moveSpeed * dt end
		if (missile.pos.x <= missile.target.x) then missile.pos.x = missile.pos.x + missile.moveSpeed * dt end
		if (missile.pos.y > missile.target.y - screen.y/3) then missile.pos.y = missile.pos.y - missile.moveSpeed * dt end
		--once missile is above target, drop
		if ((missile.pos.y <= missile.target.y - screen.y/3) and (missile.pos.x == missile.target.x)) then
			missile.rotation = 180
			if (missile.pos.y < missile.target) then missile.pos.y = missile.pos.y - missile.moveSpeed * dt
			else missile.pos.y = 50
			end
		end
	end
end

function love.draw()

	--draw ground
	love.graphics.setColor(colors.green)
	love.graphics.rectangle("fill", ground.pos.x, ground.pos.y, ground.size.x, ground.size.y)

	--draw crosshair
	love.graphics.setColor(colors.black)
	love.graphics.draw(crosshair.sprite.image, crosshair.pos.x, crosshair.pos.y, crosshair.rotation, crosshairScale, crosshairScale, 16, 16 )

	--draw missile
	love.graphics.setColor(colors.red)
	love.graphics.draw(missile.sprite.image, missile.pos.x, missile.pos.y, missile.rotation, missileScale, missileScale, 16, 16)

	--draw gui
	love.graphics.setColor(colors.blue)
	love.graphics.rectangle("fill", gui.pos.x, gui.pos.y, gui.size.x, gui.size.y)
end
