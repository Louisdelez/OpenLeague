package spark.components.mediaClasses
{
   import flash.events.MouseEvent;
   import mx.events.FlexEvent;
   import spark.components.Button;
   
   [Event(name="mutedChange",type="mx.events.FlexEvent")]
   public class MuteButton extends Button
   {
      
      private static var _skinParts:Object = {
         "iconDisplay":false,
         "labelDisplay":false
      };
      
      private var _muted:Boolean = false;
      
      private var _volume:Number = 1;
      
      public function MuteButton()
      {
         super();
      }
      
      [Bindable("mutedChanged")]
      public function get muted() : Boolean
      {
         return this._muted;
      }
      
      public function set muted(value:Boolean) : void
      {
         if(this._muted == value)
         {
            return;
         }
         this._muted = value;
         dispatchEvent(new FlexEvent(FlexEvent.MUTED_CHANGE));
      }
      
      [Bindable(event="valueCommit")]
      public function get volume() : Number
      {
         return this._volume;
      }
      
      public function set volume(value:Number) : void
      {
         if(this._volume == value)
         {
            return;
         }
         this._volume = value;
         dispatchEvent(new FlexEvent(FlexEvent.VALUE_COMMIT));
      }
      
      override protected function clickHandler(event:MouseEvent) : void
      {
         super.clickHandler(event);
         this.muted = !this.muted;
         dispatchEvent(new FlexEvent(FlexEvent.MUTED_CHANGE));
      }
   }
}

