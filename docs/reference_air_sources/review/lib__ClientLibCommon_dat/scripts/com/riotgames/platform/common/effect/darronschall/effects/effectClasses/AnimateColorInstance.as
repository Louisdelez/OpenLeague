package com.riotgames.platform.common.effect.darronschall.effects.effectClasses
{
   import com.riotgames.platform.common.effect.darronschall.util.ColorUtil;
   import mx.effects.effectClasses.AnimatePropertyInstance;
   
   public class AnimateColorInstance extends AnimatePropertyInstance
   {
      
      protected var startValues:Object;
      
      protected var delta:Object;
      
      public function AnimateColorInstance(param1:Object)
      {
         super(param1);
      }
      
      override public function onTweenUpdate(param1:Object) : void
      {
         if(this.delta == null)
         {
            return;
         }
         var _loc2_:int = int(this.playheadTime);
         if(_loc2_ > duration)
         {
            _loc2_ = int(duration);
         }
         var _loc3_:int = (this.startValues.r - _loc2_ * this.delta.r << 16) + (this.startValues.g - _loc2_ * this.delta.g << 8) + (this.startValues.b - _loc2_ * this.delta.b);
         if(!isStyle)
         {
            target[property] = _loc3_;
         }
         else
         {
            target.setStyle(property,_loc3_);
         }
      }
      
      override public function play() : void
      {
         super.play();
         this.startValues = ColorUtil.intToRgb(fromValue);
         var _loc1_:Object = ColorUtil.intToRgb(toValue);
         this.delta = {
            "r":(this.startValues.r - _loc1_.r) / duration,
            "g":(this.startValues.g - _loc1_.g) / duration,
            "b":(this.startValues.b - _loc1_.b) / duration
         };
      }
   }
}

