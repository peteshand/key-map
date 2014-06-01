package 
{
	import blaze.service.keyboard.KeyboardMap;
	import flash.display.Sprite;
	
	/**
	 * ...
	 * @author P.J.Shand
	 */
	public class Main extends Sprite 
	{
		
		public function Main():void 
		{
			KeyboardMap.init(stage);
			
			KeyboardMap.map(OnTkeyPressed, 't', { ctrl:true } );
			KeyboardMap.map(OnTkeyReleased, 84, { action:KeyboardMap.ACTION_DOWN} );
		}
		
		private function OnTkeyPressed():void 
		{
			trace("t key + ctrl released");
		}
		
		private function OnTkeyReleased():void 
		{
			trace("t key pressed");
		}
	}
}