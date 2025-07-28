package;

import flixel.text.FlxText;
import flixel.group.FlxGroup.FlxTypedGroup;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxColor;

class HUD extends FlxTypedGroup<FlxSprite>
{
    var message:FlxText;
    var timer:FlxText;
    var p1MissesDisplay:FlxText;

    public function new() 
    {
        super();
        timer = new FlxText(FlxG.width/2,100,0,"0",70);
        add(timer);

        message = new FlxText(50,50,0,"Stage: " + PlayState.stageNumber,50);
        add(message);

        p1MissesDisplay = new FlxText(50, FlxG.height-50, 0, "Misses:" + PlayState.p1_Misses, 50);
        p1MissesDisplay.color= FlxColor.RED;
        add(p1MissesDisplay);

    }
    /**
     * function to update the message displayed in the HUD.
     * @param msg The message to be displayed in the HUD.
     */
    public function updateMessage(msg:String)
    {
        message.text = msg;

    }
    /**
     * Updates the timer display in the HUD.
     * It converts the time to a string and updates the timer text.
     * @param time The current time to be displayed in the HUD.
     */
    public function updateTimer(time:Int)
    {
        timer.text = Std.string(time);
    }
    /**
     * Updates the misses display in the HUD.
     * @param misses The number of misses to be displayed in the HUD.
     */
    public function updateMisses(misses:Int)
    {
        p1MissesDisplay.text = "Misses: " + Std.string(misses);
    }

}