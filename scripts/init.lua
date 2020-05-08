window = Window:new(VideoMode:new(800, 600), "SunWhysEngine")
event = Event:new()
gameManager = GameManager:new()

StartMenu = Scenes:new("StartMenu",
 -- Init function
function()
	background = Sprites:new(window, "StartMenuBackground.png", 0, 0)
end,
 -- Render function
function()
	background:draw()
end,
 -- Update function
function()
	while (window:event(event)) do
		if (event.type == EventType.Close or event.key.code == Keyboard.Escape) then
			window:close()
			gameManager:close()
		end
		if (event.type == EventType.KeyPressed) then 
			if (event.key.code == Keyboard.Space) then
				gameManager:goToScene("GamePlay")
			end
		end
	end
end
)

GamePlay = Scenes:new("GamePlay", 
 -- Init function
function ()
	physics = Physics:new()
	ball = Sprites:new(window, "ball.png", 400-49/2, 300-49/2)
	ballTest = Sprites:new(window, "ball.png", 400-49/2, 300-49/2)
	left_racket = Sprites:new(window, "left-racket.png", 30, 300)
	right_racket = Sprites:new(window, "right-racket.png", 770-37, 310)
	LDownPressed = false
	RDownPressed = false
	LUpPressed = false
	RDownPressed = false
	racketSpeed = 5
	-- math.randomseed()
	ballDirection = math.rad(math.random(-10, 10))
	ballSpeed = 3
end,

 -- Render
function ()
	ball:draw()
	left_racket:draw()
	right_racket:draw()
	-- ballTest:draw()
end,

 -- Update
function (dt)
	while (window:event(event)) do
		if (event.type == EventType.Close or event.key.code == Keyboard.Escape) then
			window:close()
			gameManager:close()
		end
		if (event.type == EventType.KeyPressed) then 
			if (event.key.code == Keyboard.S) then
				LDownPressed = true
			elseif (event.key.code == Keyboard.Z) then
				LUpPressed = true
			elseif (event.key.code == Keyboard.K) then
				RDownPressed = true
			elseif (event.key.code == Keyboard.I) then
				RUpPressed = true
			end
		end
		if (event.type == EventType.KeyReleased) then 
			if (event.key.code == Keyboard.S) then
				LDownPressed = false	
			elseif (event.key.code == Keyboard.Z) then
				LUpPressed = false
			elseif (event.key.code == Keyboard.K) then
				RDownPressed = false
			elseif (event.key.code == Keyboard.I) then
				RUpPressed = false
			end
		end
	end
	if (LDownPressed) then
		left_racket.y = left_racket.y+racketSpeed*dt
	elseif (LUpPressed) then
		left_racket.y = left_racket.y-racketSpeed*dt
	end
	if (RDownPressed) then
		right_racket.y = right_racket.y+racketSpeed*dt
	elseif (RUpPressed) then
		right_racket.y = right_racket.y-racketSpeed*dt
	end
	ball.x = ball.x+math.cos(ballDirection)*ballSpeed*dt
	ball.y = ball.y+math.sin(ballDirection)*ballSpeed*dt

	-- Collision detection
	-- 	The top wall
	if (ball.y<0) then
		print (ballDirection)
		ballDirection = math.pi*2-ballDirection
	end
	--	The bottom wall
	if (ball.y+49>600) then
		print (ballDirection)
		ballDirection = math.pi*2-ballDirection
	end

	if (physics:collide(ball, right_racket)) then
		factor = right_racket.y+64-(ball.y+25)
		ballDirection = math.pi+factor*0.01
		ball.x = ball.x+math.cos(ballDirection)*ballSpeed
		ball.y = ball.y+math.sin(ballDirection)*ballSpeed
		
	end	
	if (physics:collide(ball, left_racket)) then
		factor = left_racket.y+64-(ball.y+25)
		ballDirection = factor*-0.01
		ball.x = ball.x+math.cos(ballDirection)*ballSpeed
		ball.y = ball.y+math.sin(ballDirection)*ballSpeed
		
	end	
	while (ballDirection>math.pi*2) do
		ballDirection = ballDirection-math.pi*2
	end
	while (ballDirection<0) do
		ballDirection = ballDirection+math.pi*2
	end


	if (ball.x>800 or ball.x<0) then
		ball.x = 400-49/2
		ball.y = 300-49/2
		ballDirection = 0
	end	
end
)

gameManager:push(GamePlay)
gameManager:push(StartMenu)
gameManager:goToScene("StartMenu")


function startGame()
	while (window:open()) do
		gameManager:update()

		window:clear(Color.Black)
		gameManager:render()
		window:display()
	end
end
