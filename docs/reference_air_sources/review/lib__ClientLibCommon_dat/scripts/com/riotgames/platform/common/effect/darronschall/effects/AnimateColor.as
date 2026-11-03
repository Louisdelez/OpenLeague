package com.riotgames.platform.common.effect.darronschall.effects
{
   import com.riotgames.platform.common.effect.darronschall.effects.effectClasses.AnimateColorInstance;
   import mx.effects.AnimateProperty;
   import mx.effects.IEffectInstance;
   
   public class AnimateColor extends AnimateProperty
   {
      
      public function AnimateColor(param1:Object = null)
      {
         super(param1);
         instanceClass = AnimateColorInstance;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         super.initInstance(param1);
         var _loc2_:AnimateColorInstance = AnimateColorInstance(param1);
         _loc2_.fromValue = fromValue;
         _loc2_.toValue = toValue;
         _loc2_.property = property;
         _loc2_.isStyle = isStyle;
         _loc2_.roundValue = roundValue;
      }
   }
}

