package;

import flixel.FlxSprite;
import flixel.system.FlxAssets.FlxGraphicAsset;

class Fruit extends FlxSprite
{
	public function new(?X:Float = 0, ?Y:Float = 0, ?SimpleGraphic:FlxGraphicAsset)
	{
		super(X, Y, SimpleGraphic);

		loadGraphic("assets/images/fruits.png", true, 32, 32);

		animation.add("Fruit", [Math.round(Math.random() * 9)], 1);

		animation.play("Fruit");
	}
}
