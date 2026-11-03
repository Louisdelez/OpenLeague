package com.riotgames.platform.gameclient.components.effects
{
   import mx.effects.IEffectInstance;
   import mx.effects.TweenEffect;
   
   public class BrightnessEffect extends TweenEffect
   {
      
      public var brightnessFrom:Number = 0;
      
      public var brightnessTo:Number = 100;
      
      public function BrightnessEffect(param1:Object = null)
      {
         super(param1);
         this.instanceClass = BrightnessEffectInstance;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         super.initInstance(param1);
         BrightnessEffectInstance(param1).brightnessFrom = this.brightnessFrom;
         BrightnessEffectInstance(param1).brightnessTo = this.brightnessTo;
      }
      
      override public function getAffectedProperties() : Array
      {
         return ["filters"];
      }
   }
}

