package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class SnakePart extends FlxSprite
{
	public static inline final BODY_V = "bodyV";
	public static inline final BODY_H = "bodyH";
	public static inline final BODY_UL = "bodyUL";
	public static inline final BODY_UR = "bodyUR";
	public static inline final BODY_DL = "bodyDL";
	public static inline final BODY_DR = "bodyDR";
	public static inline final HEAD_RIGHT = "headRight";
	public static inline final HEAD_LEFT = "headLeft";
	public static inline final HEAD_DOWN = "headDown";
	public static inline final HEAD_UP = "headUp";

	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);

		loadGraphic("assets/images/snake.png", true, 40, 40);

		animation.add(HEAD_LEFT, [0], 1);
		animation.add(HEAD_UP, [1], 1);
		animation.add(HEAD_RIGHT, [2], 1);
		animation.add(HEAD_DOWN, [3], 1);

		animation.add(BODY_V, [4], 1);
		animation.add(BODY_H, [5], 1);
		animation.add(BODY_UL, [6], 1);
		animation.add(BODY_UR, [7], 1);
		animation.add(BODY_DR, [8], 1);
		animation.add(BODY_DL, [9], 1);
	}

	public function setFrame(frame:Int)
	{
		switch (frame)
		{
			case 0:
				animation.play(HEAD_LEFT);
			case 1:
				animation.play(HEAD_UP);
			case 2:
				animation.play(HEAD_RIGHT);
			case 3:
				animation.play(HEAD_DOWN);
			case 4:
				animation.play(BODY_V);
			case 5:
				animation.play(BODY_H);
			case 6:
				animation.play(BODY_UL);
			case 7:
				animation.play(BODY_UR);
			case 8:
				animation.play(BODY_DR);
			case 9:
				animation.play(BODY_DL);
		}
	}

	public function moveHead(dir:Int, pixels:Int):Void
	{
		switch (dir)
		{
			case 0:
				x -= pixels;

			case 1:
				y -= pixels;

			case 2:
				x += pixels;

			case 3:
				y += pixels;
		}
		setFrame(dir);
	}
}
