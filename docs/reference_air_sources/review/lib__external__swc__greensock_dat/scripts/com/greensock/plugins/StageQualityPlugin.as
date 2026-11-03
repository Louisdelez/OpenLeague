package com.greensock.plugins
{
   import com.greensock.*;
   import flash.display.Stage;
   import flash.display.StageQuality;
   
   public class StageQualityPlugin extends TweenPlugin
   {
      
      public static const API:Number = 1;
      
      protected var _during:String;
      
      protected var _tween:TweenLite;
      
      protected var _after:String;
      
      protected var _stage:Stage;
      
      public function StageQualityPlugin()
      {
         super();
         this.propName = "stageQuality";
         this.overwriteProps = ["stageQuality"];
      }
      
      override public function set changeFactor(n:Number) : void
      {
         if(_tween.cachedDuration == _tween.cachedTime || _tween.cachedTime == 0)
         {
            _stage.quality = _after;
         }
         else if(_stage.quality != _during)
         {
            _stage.quality = _during;
         }
      }
      
      override public function onInitTween(target:Object, value:*, tween:TweenLite) : Boolean
      {
         if(!(value.stage is Stage))
         {
            trace("You must define a \'stage\' property for the stageQuality object in your tween.");
            return false;
         }
         _stage = value.stage as Stage;
         _tween = tween;
         _during = "during" in value ? value.during : StageQuality.MEDIUM;
         _after = "after" in value ? value.after : _stage.quality;
         return true;
      }
   }
}

