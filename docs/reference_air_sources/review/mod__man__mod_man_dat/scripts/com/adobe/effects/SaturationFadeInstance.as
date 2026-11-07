package com.adobe.effects
{
   import flash.filters.ColorMatrixFilter;
   import mx.core.mx_internal;
   import mx.effects.effectClasses.PropertyChanges;
   import mx.effects.effectClasses.TweenEffectInstance;
   
   use namespace mx_internal;
   
   public class SaturationFadeInstance extends TweenEffectInstance
   {
      
      public static const IDENTITY_MATRIX:Array = [1,0,0,0,0,0,1,0,0,0,0,0,1,0,0,0,0,0,1,0];
      
      private static const R_LUM:Number = 0.212671;
      
      private static const G_LUM:Number = 0.71516;
      
      private static const B_LUM:Number = 0.072169;
      
      private var originalFilters:Array;
      
      public var saturationFrom:Number;
      
      public var saturationTo:Number;
      
      public function SaturationFadeInstance(param1:Object)
      {
         super(param1);
      }
      
      private function buildColorMatrixFilter(param1:Number) : ColorMatrixFilter
      {
         var _loc10_:Number = NaN;
         var _loc2_:Number = 1 - param1;
         var _loc3_:Number = _loc2_ * R_LUM;
         var _loc4_:Number = _loc2_ * G_LUM;
         var _loc5_:Number = _loc2_ * B_LUM;
         var _loc6_:Array = [_loc3_ + param1,_loc4_,_loc5_,0,0,_loc3_,_loc4_ + param1,_loc5_,0,0,_loc3_,_loc4_,_loc5_ + param1,0,0,0,0,0,1,0];
         var _loc7_:Array = new Array();
         var _loc8_:Number = 0;
         var _loc9_:Number = 0;
         while(_loc9_ < 4)
         {
            _loc10_ = 0;
            while(_loc10_ < 5)
            {
               _loc7_[_loc8_ + _loc10_] = _loc6_[_loc8_] * IDENTITY_MATRIX[_loc10_] + _loc6_[_loc8_ + 1] * IDENTITY_MATRIX[_loc10_ + 5] + _loc6_[_loc8_ + 2] * IDENTITY_MATRIX[_loc10_ + 10] + _loc6_[_loc8_ + 3] * IDENTITY_MATRIX[_loc10_ + 15] + (_loc10_ == 4 ? _loc6_[_loc8_ + 4] : 0);
               _loc10_++;
            }
            _loc8_ += 5;
            _loc9_++;
         }
         return new ColorMatrixFilter(_loc7_);
      }
      
      override public function onTweenUpdate(param1:Object) : void
      {
         applyColorMatrixFilter(Number(param1));
      }
      
      override public function play() : void
      {
         super.play();
         originalFilters = target.filters;
         var _loc1_:PropertyChanges = propertyChanges;
         if(isNaN(saturationFrom))
         {
            if(saturationTo > 0)
            {
               saturationFrom = 0;
            }
            else
            {
               saturationFrom = 1;
            }
         }
         if(isNaN(saturationTo))
         {
            if(saturationFrom > 0)
            {
               saturationTo = 0;
            }
            else
            {
               saturationTo = 1;
            }
         }
         tween = createTween(this,saturationFrom,saturationTo,duration);
         applyColorMatrixFilter(Number(tween.mx_internal::getCurrentValue(0)));
      }
      
      private function applyColorMatrixFilter(param1:Number) : void
      {
         var _loc2_:Array = new Array();
         var _loc3_:uint = 0;
         while(_loc3_ < originalFilters.length)
         {
            if(originalFilters[_loc3_] is ColorMatrixFilter == false)
            {
               _loc2_.push(originalFilters[_loc3_]);
            }
            _loc3_++;
         }
         _loc2_.push(buildColorMatrixFilter(param1));
         target.filters = _loc2_;
      }
   }
}

