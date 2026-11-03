package com.riotgames.platform.gameclient.components
{
   import com.riotgames.platform.gameclient.utils.PieClockGraphicsUtil;
   import mx.containers.Canvas;
   
   public class PieClockDisplay extends Canvas
   {
      
      private static const RADIAN_STEP_SIZE:Number = 0.2;
      
      private var _foregroundColor:uint = 16777215;
      
      private var _borderThickness:Number = 1;
      
      private var _progress:Number = 0;
      
      private var _backgroundColor:uint = 0;
      
      public function PieClockDisplay()
      {
         super();
      }
      
      public function get foregroundColor() : uint
      {
         return this._foregroundColor;
      }
      
      public function set foregroundColor(param1:uint) : void
      {
         this._foregroundColor = param1;
         this.drawTime();
      }
      
      public function get borderThickness() : Number
      {
         return this._borderThickness;
      }
      
      public function set backgroundColor(param1:uint) : void
      {
         this._backgroundColor = param1;
         this.drawTime();
      }
      
      public function get progress() : Number
      {
         return this._progress;
      }
      
      public function set borderThickness(param1:Number) : void
      {
         this._borderThickness = param1;
         this.drawTime();
      }
      
      public function drawTime() : void
      {
         PieClockGraphicsUtil.drawPieClockGraphic(this.graphics,this._progress,15,this.backgroundColor,this.foregroundColor,this.borderThickness);
      }
      
      public function get backgroundColor() : uint
      {
         return this._backgroundColor;
      }
      
      public function set progress(param1:Number) : void
      {
         this._progress = param1;
         this.drawTime();
      }
   }
}

