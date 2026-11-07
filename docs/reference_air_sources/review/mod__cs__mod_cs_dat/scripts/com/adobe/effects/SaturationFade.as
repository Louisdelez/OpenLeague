package com.adobe.effects
{
   import mx.effects.IEffectInstance;
   import mx.effects.TweenEffect;
   
   public class SaturationFade extends TweenEffect
   {
      
      private static var AFFECTED_PROPERTIES:Array = ["filters"];
      
      public var saturationFrom:Number;
      
      public var saturationTo:Number;
      
      public function SaturationFade(param1:Object = null)
      {
         super(param1);
         instanceClass = SaturationFadeInstance;
      }
      
      override public function getAffectedProperties() : Array
      {
         return AFFECTED_PROPERTIES;
      }
      
      override protected function initInstance(param1:IEffectInstance) : void
      {
         super.initInstance(param1);
         var _loc2_:SaturationFadeInstance = SaturationFadeInstance(param1);
         _loc2_.saturationFrom = saturationFrom;
         _loc2_.saturationTo = saturationTo;
      }
   }
}

