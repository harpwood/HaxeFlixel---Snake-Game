package;

import flixel.FlxG;
import flixel.FlxState;
import flixel.group.FlxSpriteGroup;
import flixel.math.FlxPoint;
import flixel.text.FlxText;
import flixel.util.FlxColor;

class PlayState extends FlxState
{
	private inline static final TOTAL_TILES_PER_WIDTH:Int = 20;
	private inline static final TOTAL_TILES_PER_HEIGHT:Int = 15;
	private inline static final TILE_SIZE:Int = 40;

	private var snakePart:SnakePart;
	private var snake:FlxSpriteGroup;
	private var snakeDirection:Int;
	private var time:Float = 0;
	private var steps:Int = 0;
	private var stepsModifier = 1;
	private var fruit:Fruit;
	private var grow:Int = 0;
	private var totalFruits:Int = 0;
	private var lastDirection:Int = 0;
	private var isDead:Bool = false;
	private var headPoint:FlxPoint;
	private var scoreText:FlxText;
	private var score:Int = 0;

	override public function create()
	{
		super.create();

		snake = new FlxSpriteGroup();

		placeSnake();
		placeFruit();

		scoreText = new FlxText(5, 5, 100, "", 24);
		add(scoreText);
	}

	override public function update(elapsed:Float)
	{
		scoreText.text = Std.string(score);
		time += elapsed;

		// user input
		if (FlxG.keys.justPressed.R)
			FlxG.resetGame();

		if (FlxG.keys.justPressed.LEFT && snakeDirection != 2)
		{
			var snakeHead:SnakePart = cast(snake.members[0], SnakePart);
			if (snakeHead.y > 0 && snakeHead.y < FlxG.height)
				lastDirection = 0;
		}
		if (FlxG.keys.justPressed.UP && snakeDirection != 3)
		{
			var snakeHead:SnakePart = cast(snake.members[0], SnakePart);
			if (snakeHead.x > 0 && snakeHead.x < FlxG.width)
				lastDirection = 1;
		}
		if (FlxG.keys.justPressed.RIGHT && snakeDirection != 0)
		{
			var snakeHead:SnakePart = cast(snake.members[0], SnakePart);
			if (snakeHead.y > 0 && snakeHead.y < FlxG.height)
				lastDirection = 2;
		}

		if (FlxG.keys.justPressed.DOWN && snakeDirection != 1)
		{
			var snakeHead:SnakePart = cast(snake.members[0], SnakePart);
			if (snakeHead.x > 0 && snakeHead.x < FlxG.width)
				lastDirection = 3;
		}

		// Update snake
		if (!isDead && (time > 1 / (3 + (totalFruits / 10) + (stepsModifier / 20))))
		{
			snakeDirection = lastDirection;
			time = 0;
			steps++;
			score++;
			if (steps == 60 * stepsModifier)
			{
				steps = 0;
				stepsModifier++;
			}
			var snakeHead:SnakePart = cast(snake.members[0], SnakePart);

			var newPart:SnakePart = new SnakePart(snakeHead.x, snakeHead.y);

			snake.group.insert(1, newPart);

			var oldPart:SnakePart = cast(snake.members[2], SnakePart);
			var p:Int = snake.length;
			var lastPart:SnakePart = cast(snake.members[p - 1], SnakePart);

			snakeHead.moveHead(snakeDirection, TILE_SIZE);

			// change snake tile according to its position compared to the next to it snake tile
			if ((is_up(newPart, snakeHead) && is_down(newPart, oldPart)) || (is_down(newPart, snakeHead) && is_up(newPart, oldPart)))
				newPart.setFrame(4);

			if ((is_left(newPart, snakeHead) && is_right(newPart, oldPart)) || (is_right(newPart, snakeHead) && is_left(newPart, oldPart)))
				newPart.setFrame(5);

			if ((is_left(newPart, snakeHead) && is_up(newPart, oldPart)) || (is_up(newPart, snakeHead) && is_left(newPart, oldPart)))
				newPart.setFrame(6);

			if ((is_up(newPart, snakeHead) && is_right(newPart, oldPart)) || (is_right(newPart, snakeHead) && is_up(newPart, oldPart)))
				newPart.setFrame(7);

			if ((is_right(newPart, snakeHead) && is_down(newPart, oldPart)) || (is_down(newPart, snakeHead) && is_right(newPart, oldPart)))
				newPart.setFrame(8);

			if ((is_left(newPart, snakeHead) && is_down(newPart, oldPart)) || (is_down(newPart, snakeHead) && is_left(newPart, oldPart)))
				newPart.setFrame(9);

			for (i in 0...snake.length)
			{
				if (snake.members[i].x < 0)
					snake.members[i].x = FlxG.width - TILE_SIZE;

				if (snake.members[i].x > FlxG.width)
					snake.members[i].x = 0;

				if (snake.members[i].y < 0)
					snake.members[i].y = FlxG.height - TILE_SIZE;

				if (snake.members[i].y > FlxG.height)
					snake.members[i].y = 0;

				headPoint = snakeHead.getGraphicMidpoint();
				for (i in 1...snake.length)
				{
					if (snake.members[i].overlapsPoint(headPoint))
						isDead = true;
				}
			}

			if (FlxG.collide(snakeHead, fruit))
			{
				remove(fruit);
				grow = 1;
				placeFruit();
				totalFruits++;
				score += 10 * stepsModifier;
			}

			if (grow == 0)
			{
				snake.remove(lastPart, true);
			}
			else
			{
				grow--;
			}
		}

		super.update(elapsed);
	}

	private function placeSnake():Void
	{
		add(snake);

		var col:Int = Math.floor(Math.random() * (TOTAL_TILES_PER_WIDTH - 10)) + 5;
		var row:Int = Math.floor(Math.random() * (TOTAL_TILES_PER_HEIGHT - 10)) + 5;
		var tmpCol, tmpRow, evenDir:Int;

		snakeDirection = Math.floor(Math.random() * 3);
		lastDirection = snakeDirection;
		for (i in 0...3)
		{
			evenDir = snakeDirection % 2;
			tmpCol = i == 0 ? col : col + i * (1 - evenDir) * (1 - snakeDirection);
			tmpRow = i == 0 ? row : row + i * (2 - snakeDirection) * evenDir;
			snakePart = new SnakePart(tmpCol * TILE_SIZE, tmpRow * TILE_SIZE);
			snakePart.setFrame(i == 0 ? snakeDirection : 5 - evenDir);
			snake.add(snakePart);
		}
	}

	private function is_up(from:SnakePart, to:SnakePart):Bool
	{
		if (!isWraparound(to, from))
			return to.y < from.y && from.x == to.x;
		else
			return to.y > from.y && from.x == to.x;
	}

	private function is_down(from:SnakePart, to:SnakePart):Bool
	{
		if (!isWraparound(to, from))
			return to.y > from.y && from.x == to.x;
		else
			return to.y < from.y && from.x == to.x;
	}

	private function is_left(from:SnakePart, to:SnakePart):Bool
	{
		if (!isWraparound(to, from))
			return to.x < from.x && from.y == to.y;
		else
			return to.x > from.x && from.y == to.y;
	}

	private function is_right(from:SnakePart, to:SnakePart):Bool
	{
		if (!isWraparound(to, from))
			return to.x > from.x && from.y == to.y;
		else
			return to.x < from.x && from.y == to.y;
	}

	// For more info about Wraparound check : https://en.wikipedia.org/wiki/Wraparound_(video_games)
	private function isWraparound(from:SnakePart, to:SnakePart):Bool
	{
		if ((Math.abs(to.x - from.x) >= FlxG.width - TILE_SIZE * 2) || (Math.abs(to.y - from.y) >= FlxG.height - TILE_SIZE * 2))
			return true;
		else
			return false;
	}

	private function placeFruit():Void
	{
		var fruitIsPlaced:Bool = false;
		var col:Int = 0;
		var row:Int = 0;
		var pointToPlaceFruit:FlxPoint;

		while (!fruitIsPlaced)
		{
			col = Math.floor(Math.random() * TOTAL_TILES_PER_WIDTH) * TILE_SIZE;
			row = Math.floor(Math.random() * TOTAL_TILES_PER_HEIGHT) * TILE_SIZE;
			pointToPlaceFruit = new FlxPoint(col, row);

			for (i in 0...snake.length)
			{
				// check if the pointToPlaceFruit is not on any part of the snake
				if (!snake.members[i].overlapsPoint(pointToPlaceFruit))
				{
					fruitIsPlaced = true;
				}
				else
				{
					fruitIsPlaced = false;
					break;
				}
			}
		}
		fruit = new Fruit();
		fruit.x = col;
		fruit.y = row;
		add(fruit);
	}
}
