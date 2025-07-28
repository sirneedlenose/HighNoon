package;

import flixel.FlxSprite;
import flixel.util.FlxColor;
import flixel.FlxG;

class Opponent extends FlxSprite
{
    public var shotFirst:Bool;
    public var canShoot:Bool;
    private var reactionTime:Int;

    public function new(x:Float, y:Float)
    {
        super(x, y);
        makeGraphic(64, 64, FlxColor.RED);
    }

    override public function update(elapsed:Float)
    {
        super.update(elapsed);

        if(canShoot && PlayState.time == reactionTime && PlayState.roundOver == false)
        {
            shoot();
        }
    }
    /**
     * Sets the reaction time for the opponent based on the current stage and difficulty level.
     * It reads a JSON file that contains the reaction times for different levels of difficulty.
     */
    public function setReactionTime(time:Int)
    {
        reactionTime = time-1;
    }
    /**
     * Handles the shooting logic for the opponent.
     * If the opponent shoots, then shotFirst is set to true
     */
    public function shoot()
    {
        trace("Opponent shoots!");
        FlxG.camera.flash(FlxColor.WHITE, 0.2);

        shotFirst = true;
    }
}