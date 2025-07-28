package;

import haxe.Json;
import flixel.util.FlxColor;
import flixel.FlxState;
import flixel.FlxSprite;
import flixel.FlxG;
import flixel.util.FlxTimer;
import flixel.text.FlxText;

typedef RoundFlags = {

	var p1Win:Bool;
	var oppWin:Bool;
	var draw:Bool;
	var p1Miss:Bool;

}

class PlayState extends FlxState
{
	var player1:Player1;
	var opponent:Opponent;
	var hud:HUD;

	public static var stageNumber:Int = 1; // Current stage number, updates by +1 or rests to 1
	public static var levelDifficult:Int = 1; // Current level of difficulty, updates by +1 or rests to 1
	public static var p1_Misses:Int = 0; // Player 1 misses counter

	private var fireTimer:FlxTimer; // Timer for waiting before allowing shooting creates tension tee hee hee 
	public static var time:Int; // Timer for when the player and opponent can shoot
	public static var roundOver:Bool; // boolean to check if the round is over
	public static var holdFire:Bool; // boolean that acts for the timer to wait and a boolean to check if the player can shoot or not

	private var flags:RoundFlags; // Flags to check the state of the round

	private var results_displayed:Bool; // boolean to check if the results have been displayed maybe removed or changed later at some point


	override public function create()
	{
		super.create();


		// Initialize the player
		player1 = new Player1(FlxG.width/4,FlxG.height/2);
		player1.canShoot = false; 
		player1.shotFirst = false;
		add(player1);

		// Initialize the opponent
		opponent = new Opponent(FlxG.width*3/4,FlxG.height/2);
		opponent.canShoot = false;
		opponent.shotFirst = false;
		setOpponentReactionTime();
		add(opponent);

		// Initialize the HUD
		hud = new HUD();
		add(hud);

		flags = {
			p1Win: false,
			oppWin: false,
			draw: false,
			p1Miss: false
		};

		time = 0;

		roundOver = false;
		holdFire = true;
		results_displayed = false;

		fireTimer = new FlxTimer();
		fireTimer.start(5, onFireTimer, 0);

	}

	override public function update(elapsed:Float)
	{
		super.update(elapsed);

		// condition to start timer
		if(roundOver != true && !holdFire)
		{
			updateTime();
		}
		// condition if player shoots before timer starts
		if(player1.shotFirst && holdFire)
		{
			updateMisses();

		}
		//condition if player or opponent shoots or times runs out
		if(player1.shotFirst || opponent.shotFirst || time >= 99 && !results_displayed)
		{
			Roundover();
		}
		// condition to see results and set next stage
		if(roundOver && results_displayed)
		{
			setStage();
		}
	}
	/**
	 * sets the reaction time for the opponent based on the current stage and difficulty level.
	 * It reads a JSON file that contains the reaction times for different levels of difficulty.
	 */
	public function setOpponentReactionTime()
	{
		
		var jsonString:String = FlxG.assets.getText("assets/data/stage" + stageNumber + ".json");
		var data: Dynamic = Json.parse(jsonString);

		switch(levelDifficult)
		{
			case 1:
				opponent.setReactionTime(data.level_1);
			case 2:
				opponent.setReactionTime(data.level_2);
			case 3:
				opponent.setReactionTime(data.level_3);
			default:
				opponent.setReactionTime(data.level_1);
		}

	}
	/**
	 * Updates the timer and the HUD display.
	 * Increments the time variable and updates the timer text in the HUD.
	 */
	public function updateTime()
	{
		time++;
		hud.updateTimer(Std.int(time));
	}
	/**
	 * Updates the misses counter for Player 1 and updates the HUD display.
	 * Increments the p1_Misses variable and updates the misses text in the HUD.
	 */
	public function updateMisses()
	{
		if (flags.p1Miss)
			return;

		flags.p1Miss = true;
		p1_Misses++;

		hud.updateMisses(p1_Misses);
	}
	/**
	 * Callback function for the fire timer.
	 * This function acts as a way to determine when the player and opponent can shoot. 
	 * using a random number to determine when the player and opponent can shoot.
	 */
	public function onFireTimer(fireTimer:FlxTimer)
	{
		if(!roundOver && holdFire)
		{
			if(FlxG.random.bool(35))
			{
				holdFire = false;
				player1.canShoot = true;
				opponent.canShoot = true;

				hud.updateMessage("FIRE!");

				FlxG.log.add("FIRE NOW");

				if(fireTimer != null) fireTimer.cancel();
			}else{
				FlxG.log.add("WAIT");
			}

		}
	}
	/**
	 * Determines the outcome of the round based on who shot first and whether Player 1 missed.
	 * Updates the HUD with the result and sets the flags accordingly.
	 */
	public function Roundover()
	{
		if (roundOver)
			return;

		roundOver = true;

		if (player1.shotFirst && opponent.shotFirst)
		{
				
			FlxG.log.add("It's a Draw!");
			hud.updateMessage("It's a Draw!");
		}
		else if (player1.shotFirst && !flags.p1Miss)
		{
			
			FlxG.log.add("Player 1 Wins!");
			hud.updateMessage("Player 1 Wins!");
			flags.p1Win = true;

		}
		else if (opponent.shotFirst)
		{
			
			FlxG.log.add("Opponent Wins!");
			hud.updateMessage("Opponent Wins!");
			flags.oppWin = true;
		}
		else if (flags.p1Miss)
		{
			
			FlxG.log.add("Player 1 Missed!");
			hud.updateMessage("Player 1 Missed!");
		}
		else
		{
			
			FlxG.log.add("Time's Up!");
			hud.updateMessage("Times Up!");

		}
		
		results_displayed = true;
	}
	/**
	 * Sets the stage for the next round based on the outcome of the current round.
	 * If Player 1 wins and the stage number is not 3, it increments the stage number.
	 * Otherwise, it resets the stage number to 1.
	 * After a delay, it switches to a new instance of PlayState.
	 */
	public function setStage()
	{
		var timer = new FlxTimer();

		if(flags.p1Win && stageNumber != 3)
		{
			timer.start(4, function(timer:FlxTimer){
				FlxG.log.add("Next Stage...");
				stageNumber++;
				FlxG.switchState(()-> new PlayState());
			}, 1);
		}
		else
		{
			timer.start(4, function(timer:FlxTimer){
				FlxG.log.add("Resetting round...");
				stageNumber = 1;
				FlxG.switchState(()-> new PlayState());
			}, 1);
		}
		
	}
}
