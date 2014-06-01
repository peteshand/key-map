package blaze.service.keyboard 
{
	import flash.display.Sprite;
	import flash.display.Stage;
	import flash.events.KeyboardEvent;
	import flash.utils.Dictionary;
	/**
	 * @author Tom Byrne
	 * @author P.J.Shand
	 */
	public class KeyboardMap extends Sprite
	{
		private static var stage:Stage;
		private static var _keyLookup:Dictionary;
		private static var _charLookup:Dictionary;
		private static var _shortcuts:Vector.<Shortcut>;
		
		public static const ACTION_DOWN:String = 'keyDown';
		public static const ACTION_UP:String = 'keyUp';
		
		public static function init(stage:Stage):void 
		{
			KeyboardMap.stage = stage;
			_shortcuts = new Vector.<Shortcut>();
			_keyLookup = new Dictionary();
			_charLookup = new Dictionary();
			
			stage.addEventListener(KeyboardEvent.KEY_DOWN, OnKeyDown);
			stage.addEventListener(KeyboardEvent.KEY_UP, OnKeyUp);
		}
		
		private static function OnKeyDown(e:KeyboardEvent):void 
		{
			executeList(_keyLookup[e.keyCode], e);
			executeList(_charLookup[String.fromCharCode(e.charCode).toLowerCase()], e);
		}
		
		private static function OnKeyUp(e:KeyboardEvent):void 
		{
			executeList(_keyLookup[e.keyCode], e);
			executeList(_charLookup[String.fromCharCode(e.charCode).toLowerCase()], e);
		}
		
		public static function map(callback:Function, charOrKeycode:*, options:Object = null):void 
		{
			if (!KeyboardMap.stage) throw new Error('KeyboardMap.init(stage) much be called first');
			if (charOrKeycode is String) addCharShortcut(callback, String(charOrKeycode), options);
			else if (charOrKeycode is int) addKeyShortcut(callback, int(charOrKeycode), options);
			else {
				throw new Error("unknown charOrKeycode type, should be String or int");
			}
		}
		
		private static function addCharShortcut(callback:Function, char:String, options:Object = null):void
		{
			addShortcut(callback, [char], [], options);
		}
		
		private static function addKeyShortcut(callback:Function, key:int, options:Object = null):void
		{
			addShortcut(callback, [], [key], options);
		}
		
		private static function addShortcut(callback:Function, chars:Array, keys:Array, options:Object = null):void 
		{	
			var ctrl:Boolean = false;
			var alt:Boolean = false;
			var shift:Boolean = false;
			var action:String = KeyboardMap.ACTION_UP;
			var params:Array;
			
			if (options) {
				if (options['ctrl']) ctrl = options['ctrl'];
				if (options['alt']) alt = options['alt'];
				if (options['shift']) shift = options['shift'];
				if (options['action']) action = options['action'];
				if (options['params']) params = options['params'];
			}
			
			var shortcut:Shortcut = new Shortcut(callback, Vector.<String>(chars), Vector.<int>(keys), ctrl, alt, shift, action, params);
			for each(var char:String in chars) {
				addToList(_charLookup, char, shortcut);
			}
			for each(var key:int in keys) {
				addToList(_keyLookup, key, shortcut);
			}
		}
		
		private static function executeList(shortcuts:Vector.<Shortcut>, e:KeyboardEvent):void 
		{
			if (!shortcuts) return;
			
			for each(var shortcut:Shortcut in shortcuts) {
				if(shortcut.ctrl==e.ctrlKey && shortcut.shift==e.shiftKey && shortcut.alt==e.altKey && shortcut.action==e.type){
					if (shortcut.params) shortcut.callback(shortcut.params);
					else shortcut.callback();
				}
			}
		}
		
		private static function addToList(lookup:Dictionary, key:*, shortcut:Shortcut):void 
		{
			var list:Vector.<Shortcut> = lookup[key];
			if (!list) {
				list = new Vector.<Shortcut>();
				lookup[key] = list;
			}
			list.push(shortcut);
		}
	}
}

class Shortcut {
	
	public var callback:Function;
	
	public var ctrl:Boolean;
	public var shift:Boolean;
	public var alt:Boolean;
	public var action:String;
	public var params:Array;
	
	public var chars:Vector.<String>;
	public var keys:Vector.<int>;
	
	public function Shortcut(callback:Function, chars:Vector.<String>, keys:Vector.<int>, ctrl:Boolean, alt:Boolean, shift:Boolean, action:String, params:Array) {
		this.callback = callback;
		this.chars = chars;
		this.keys = keys;
		this.ctrl = ctrl;
		this.alt = alt;
		this.shift = shift;
		this.action = action;
		this.params = params;
	}
}