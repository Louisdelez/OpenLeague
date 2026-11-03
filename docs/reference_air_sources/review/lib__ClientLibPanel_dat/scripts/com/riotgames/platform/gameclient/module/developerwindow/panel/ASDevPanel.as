package com.riotgames.platform.gameclient.module.developerwindow.panel
{
   import flash.display.Sprite;
   import flash.events.Event;
   
   public class ASDevPanel extends Sprite
   {
      
      protected var _width:Number = 0;
      
      protected var _height:Number = 0;
      
      public function ASDevPanel()
      {
         super();
      }
      
      override public function get width() : Number
      {
         return this._width;
      }
      
      override public function set width(param1:Number) : void
      {
         this._width = param1;
         dispatchEvent(new Event(Event.RESIZE));
         this.updateLayout();
      }
      
      override public function get height() : Number
      {
         return this._height;
      }
      
      override public function set height(param1:Number) : void
      {
         this._height = param1;
         dispatchEvent(new Event(Event.RESIZE));
         this.updateLayout();
      }
      
      protected function updateLayout() : void
      {
      }
   }
}

