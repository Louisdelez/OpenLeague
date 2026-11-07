package com.riotgames.rust.decorator
{
   import blix.components.timeline.StatefulView;
   import blix.customsignals.PreventDefault;
   import blix.decorator.IDecoratable;
   import blix.decorator.IDecorator;
   import flash.display.DisplayObject;
   import flash.utils.Dictionary;
   
   public class AnimationToggleDecorator implements IDecorator
   {
      
      public static const NO_ANIM_ANIMATION_STATE_POSTSCRIPT:String = "_stunned";
      
      private var managedViews:Dictionary = new Dictionary(true);
      
      private var _animationsEnabled:Boolean = false;
      
      private var isChanging:Boolean;
      
      public function AnimationToggleDecorator()
      {
         super();
      }
      
      public function get animationsEnabled() : Boolean
      {
         return this._animationsEnabled;
      }
      
      public function set animationsEnabled(param1:Boolean) : void
      {
         var _loc2_:Object = null;
         var _loc3_:StatefulView = null;
         if(param1 == this._animationsEnabled)
         {
            return;
         }
         this._animationsEnabled = param1;
         for(_loc2_ in this.managedViews)
         {
            _loc3_ = _loc2_ as StatefulView;
            _loc3_.setTransitionsEnabled(this._animationsEnabled);
            if(_loc3_.getCurrentState() != null)
            {
               this.stateChangingHandler(_loc3_,_loc3_.getCurrentState(),_loc3_.getCurrentState(),new PreventDefault());
            }
         }
      }
      
      public function getDecoratedClass() : Class
      {
         return StatefulView;
      }
      
      public function getIsInheritable() : Boolean
      {
         return true;
      }
      
      public function apply(param1:IDecoratable) : void
      {
         var _loc2_:StatefulView = param1 as StatefulView;
         this.managedViews[_loc2_] = _loc2_;
         _loc2_.getCurrentStateChanging().add(this.stateChangingHandler);
         _loc2_.getAssetChanged().add(this.assetChangedHandler);
         _loc2_.setTransitionsEnabled(this._animationsEnabled);
         this.assetChangedHandler(_loc2_,null,_loc2_.getAsset());
      }
      
      private function assetChangedHandler(param1:StatefulView, param2:DisplayObject, param3:DisplayObject) : void
      {
         if(param3 != null && param1.getCurrentState() != null)
         {
            this.stateChangingHandler(param1,param1.getCurrentState(),param1.getCurrentState(),new PreventDefault());
         }
      }
      
      private function stateChangingHandler(param1:StatefulView, param2:String, param3:String, param4:PreventDefault) : void
      {
         var _loc5_:int = 0;
         if(this.isChanging)
         {
            return;
         }
         this.isChanging = true;
         if(this._animationsEnabled)
         {
            _loc5_ = param3.indexOf(NO_ANIM_ANIMATION_STATE_POSTSCRIPT);
            if(_loc5_ >= 0)
            {
               param4.preventDefault();
               param1.setCurrentState(param3.substring(0,_loc5_));
            }
         }
         else
         {
            _loc5_ = param3.indexOf(NO_ANIM_ANIMATION_STATE_POSTSCRIPT);
            if(_loc5_ == -1 && param1.getStateAnimation(param3 + NO_ANIM_ANIMATION_STATE_POSTSCRIPT,false) != null)
            {
               param4.preventDefault();
               param1.setCurrentState(param3 + NO_ANIM_ANIMATION_STATE_POSTSCRIPT);
            }
         }
         this.isChanging = false;
      }
      
      public function unapply(param1:IDecoratable) : void
      {
         var _loc2_:StatefulView = param1 as StatefulView;
         this.managedViews[_loc2_] = null;
         delete this.managedViews[_loc2_];
         _loc2_.getCurrentStateChanging().remove(this.stateChangingHandler);
         _loc2_.getAssetChanged().remove(this.assetChangedHandler);
      }
   }
}

