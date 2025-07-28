package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Player1 extends FlxSprite{

    public var canShoot:Bool;
    public var shotFirst:Bool;
    public static var misses:Int = 0;

    public function new(x:Float, y:Float)
    {
        super(x,y);
        makeGraphic(64,64,FlxColor.BLUE);
        
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(PlayState.roundOver == false){
            shoot();
        }
    }
    /**
     * Handles the shooting logic for Player 1.
     * If the player presses the SPACE key or ENTER key, it triggers a shot.
     * The shotFirst variable is set to true to indicate that Player 1 has shot first.
     */
    public function shoot()
    {
        if(FlxG.keys.pressed.SPACE || FlxG.keys.justPressed.ENTER)
        {
            FlxG.camera.flash(FlxColor.WHITE,0.2);
            trace("Player1 shoots!");

            shotFirst = true;

        }
    }

}
