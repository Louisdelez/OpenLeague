package com.riotgames.platform.gameclient.controllers.game.controllers
{
   import com.greensock.TweenLite;
   import flash.display.DisplayObject;
   
   public class ZoomEffect
   {
      
      public var scaleXTo:Number = 1;
      
      public var scaleYTo:Number = 1;
      
      public var target:DisplayObject;
      
      public var scaleXFrom:Number = 1;
      
      public var scaleYFrom:Number = 1;
      
      public var duration:Number = 1000;
      
      protected var _animating:Boolean = false;
      
      public function ZoomEffect()
      {
         super();
      }
      
      public function play() : void
      {
         if(!this.target)
         {
            return;
         }
         this.target.scaleX = this.scaleXFrom;
         this.target.scaleY = this.scaleYFrom;
         TweenLite.to(this.target,this.duration / 1000,{
            "scaleX":this.scaleXTo,
            "scaleY":this.scaleYTo,
            "onComplete":this.handleComplete
         });
         this._animating = true;
      }
      
      public function get animating() : Boolean
      {
         return this._animating;
      }
      
      protected function handleComplete() : void
      {
         trace("COMPLETED");
         this._animating = false;
      }
   }
}

