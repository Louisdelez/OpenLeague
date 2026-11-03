package com.riotgames.platform.gameclient.components.effects
{
   import flash.filters.ColorMatrixFilter;
   import mx.effects.Tween;
   import mx.effects.effectClasses.TweenEffectInstance;
   
   public class BrightnessEffectInstance extends TweenEffectInstance
   {
      
      public var brightnessFrom:Number;
      
      public var brightnessTo:Number;
      
      public function BrightnessEffectInstance(param1:Object)
      {
         super(param1);
      }
      
      private static function createBrightnessFilter(param1:Number) : ColorMatrixFilter
      {
         return new ColorMatrixFilter([1,0,0,0,param1,0,1,0,0,param1,0,0,1,0,param1,0,0,0,1,0]);
      }
      
      override public function play() : void
      {
         super.play();
         var _loc1_:Tween = createTween(this,this.brightnessFrom,this.brightnessTo,duration);
      }
      
      override public function onTweenUpdate(param1:Object) : void
      {
         var _loc2_:Array = target.filters;
         var _loc3_:int = int(_loc2_.length);
         var _loc4_:int = 0;
         while(_loc4_ < _loc3_)
         {
            if(_loc2_[_loc4_] is ColorMatrixFilter)
            {
               _loc2_.splice(_loc4_,1);
            }
            _loc4_++;
         }
         _loc2_.push(createBrightnessFilter(param1 as Number));
         target.filters = _loc2_;
      }
      
      override public function onTweenEnd(param1:Object) : void
      {
         super.onTweenEnd(param1);
      }
   }
}

