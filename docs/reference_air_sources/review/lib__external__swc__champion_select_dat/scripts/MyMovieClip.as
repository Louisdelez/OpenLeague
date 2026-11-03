package
{
   import flash.display.MovieClip;
   import flash.events.Event;
   import flash.events.MouseEvent;
   
   [Event(name="onDisableEvent",type="flash.events.Event")]
   [Event(name="onMouseDownEvent",type="flash.events.Event")]
   [Event(name="onMouseOutEvent",type="flash.events.Event")]
   [Event(name="onMouseOverEvent",type="flash.events.Event")]
   public class MyMovieClip extends MovieClip
   {
      
      public static const STATE_UP:String = "_up";
      
      public static const STATE_OVER:String = "_over";
      
      public static const STATE_DOWN:String = "_down";
      
      public static const STATE_DISABLED:String = "_disabled";
      
      private var _currentState:String;
      
      private var _label:String;
      
      public var idx:int;
      
      public var label_mc:TextFieldMovieClip;
      
      public var frameLabelArr:Array = ["_up","_over","_down","_disabled"];
      
      public function MyMovieClip()
      {
         super();
         this.addEventListener(Event.ADDED_TO_STAGE,this.onAddedToStage);
      }
      
      private function onAddedToStage(evt:Event) : void
      {
         this.init();
      }
      
      public function init() : void
      {
         this.addListeners();
      }
      
      public function addListeners() : void
      {
         this.addEventListener(MouseEvent.MOUSE_OVER,this.onMouseOver);
         this.addEventListener(MouseEvent.MOUSE_OUT,this.onMouseOut);
         this.addEventListener(MouseEvent.CLICK,this.onMouseClick);
      }
      
      private function onMouseOver(evt:MouseEvent) : void
      {
         this.currentState = STATE_OVER;
      }
      
      private function onMouseOut(evt:MouseEvent) : void
      {
         this.currentState = STATE_UP;
      }
      
      private function onMouseClick(evt:MouseEvent) : void
      {
         this.currentState = STATE_DOWN;
      }
      
      public function activate() : void
      {
         this.enabled = true;
         this.currentState = MyMovieClip.STATE_UP;
      }
      
      public function deactivate() : void
      {
         this.enabled = false;
         this.currentState = STATE_DISABLED;
      }
      
      public function set currentState(value:String) : void
      {
         this.gotoAndStop(value);
         switch(value)
         {
            case STATE_UP:
               this.dispatchEvent(new Event("onMouseOutEvent"));
               break;
            case STATE_OVER:
               this.dispatchEvent(new Event("onMouseOverEvent"));
               break;
            case STATE_DOWN:
               this.dispatchEvent(new Event("onMouseDownEvent"));
               break;
            case STATE_DISABLED:
               this.dispatchEvent(new Event("onDisableEvent"));
         }
         this._currentState = value;
      }
      
      public function get currentState() : String
      {
         return this._currentState;
      }
      
      public function set labelName(_label:String) : void
      {
         this._label = _label;
      }
      
      public function get labelName() : String
      {
         return this._label;
      }
   }
}

