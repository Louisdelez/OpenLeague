package blix.components.timeline
{
   import blix.assets.proxy.MovieClipProxy;
   import blix.context.IContext;
   import blix.customsignals.PreventDefault;
   import blix.signals.ISignal;
   import blix.signals.Signal;
   import flash.display.DisplayObject;
   import flash.display.FrameLabel;
   import flash.display.MovieClip;
   import flash.utils.Dictionary;
   
   public class StatefulView extends MovieClipProxy
   {
      
      protected var _transitionsEnabled:Boolean = true;
      
      protected var _currentStateChanging:Signal = new Signal();
      
      protected var _currentStateChanged:Signal = new Signal();
      
      protected var _currentTimelineAnimationChanged:Signal = new Signal();
      
      protected var timelineAnimations:Dictionary = new Dictionary();
      
      protected var _currentState:String;
      
      protected var _currentTimelineAnimation:TimelineAnimation;
      
      public function StatefulView(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      public function getCurrentStateChanging() : ISignal
      {
         return this._currentStateChanging;
      }
      
      public function getCurrentStateChanged() : ISignal
      {
         return this._currentStateChanged;
      }
      
      public function getCurrentState() : String
      {
         return this._currentState;
      }
      
      public function setCurrentState(param1:String) : void
      {
         var _loc4_:PreventDefault = null;
         var _loc2_:String = this._currentState;
         if(_loc2_ == param1)
         {
            return;
         }
         if(this._currentStateChanging.getHasListeners())
         {
            _loc4_ = new PreventDefault();
            this._currentStateChanging.dispatch(this,_loc2_,param1,_loc4_);
            if(_loc4_.getDefaultPrevented())
            {
               return;
            }
         }
         this._currentState = param1;
         var _loc3_:TimelineAnimation = this.getTransitionAnimation(_loc2_,param1,true);
         this.setCurrentTimelineAnimation(_loc3_);
         this._currentStateChanged.dispatch(this,_loc2_,param1);
      }
      
      override protected function configureAsset(param1:DisplayObject) : void
      {
         super.configureAsset(param1);
         if(_mcAsset != null)
         {
            this.configureTimelineAnimations(_mcAsset);
            if(this._currentTimelineAnimation != null)
            {
               if(this._currentTimelineAnimation.getHasCompleted())
               {
                  if(Boolean(this._currentTimelineAnimation.toFrame))
                  {
                     gotoAndStop(this._currentTimelineAnimation.toFrame);
                  }
               }
               else if(!this._currentTimelineAnimation.getHasBeenInvoked())
               {
                  this._currentTimelineAnimation.invoke();
               }
            }
         }
      }
      
      protected function configureTimelineAnimations(param1:MovieClip) : void
      {
         var _loc3_:FrameLabel = null;
         var _loc4_:Array = null;
         var _loc2_:TimelineAnimation = null;
         for each(_loc3_ in param1.currentLabels)
         {
            if(_loc2_ != null)
            {
               _loc2_.toFrame = _loc3_.frame - 1;
               _loc2_ = null;
            }
            if(_loc3_.name.indexOf(":") == -1)
            {
               _loc2_ = this.getStateAnimation(_loc3_.name,true);
            }
            else
            {
               _loc4_ = _loc3_.name.split(":");
               _loc2_ = this.getTransitionAnimation(_loc4_[0],_loc4_[1],true);
            }
            _loc2_.fromFrame = _loc3_.frame;
         }
         if(_loc2_ != null)
         {
            _loc2_.toFrame = param1.totalFrames;
         }
      }
      
      public function getCurrentTimelineAnimationChanged() : ISignal
      {
         return this._currentTimelineAnimationChanged;
      }
      
      public function getCurrentTimelineAnimation() : TimelineAnimation
      {
         return this._currentTimelineAnimation;
      }
      
      public function setCurrentTimelineAnimation(param1:TimelineAnimation) : void
      {
         var _loc2_:TimelineAnimation = this._currentTimelineAnimation;
         if(Boolean(_loc2_))
         {
            if(!this._currentTimelineAnimation.getIsFinished())
            {
               this._currentTimelineAnimation.abort();
            }
         }
         var _loc3_:TimelineAnimation = param1;
         this._currentTimelineAnimation = param1;
         if(_loc2_ != _loc3_)
         {
            this._currentTimelineAnimationChanged.dispatch(this,_loc2_,_loc3_);
         }
         if(_loc3_ != null)
         {
            _loc3_.reset();
            if(_asset != null)
            {
               _loc3_.invoke();
            }
            if(!this.getTransitionsEnabled())
            {
               _loc3_.complete();
            }
         }
      }
      
      public function getStateAnimation(param1:String, param2:Boolean = true) : TimelineAnimation
      {
         var _loc3_:TimelineAnimation = null;
         if(!param1)
         {
            return null;
         }
         if(param1 in this.timelineAnimations)
         {
            return this.timelineAnimations[param1];
         }
         if(param2)
         {
            _loc3_ = new TimelineAnimation(this,param1);
            this.timelineAnimations[param1] = _loc3_;
            return _loc3_;
         }
         return null;
      }
      
      public function getTransitionAnimation(param1:String, param2:String, param3:Boolean = true) : TimelineAnimation
      {
         var _loc4_:String = null;
         var _loc5_:TimelineAnimation = null;
         if(param1 == null)
         {
            param1 = "";
         }
         if(param2 == null)
         {
            param2 = "";
         }
         _loc4_ = param1 + ":" + param2;
         if(_loc4_ in this.timelineAnimations)
         {
            return this.timelineAnimations[_loc4_];
         }
         if(param3)
         {
            _loc4_ = param1 + ":" + param2;
            _loc5_ = new TimelineAnimation(this,_loc4_);
            _loc5_.getCompleted().add(this.stateAnimationCompletedHandler);
            this.timelineAnimations[_loc4_] = _loc5_;
            return _loc5_;
         }
         return null;
      }
      
      protected function stateAnimationCompletedHandler(param1:TimelineAnimation) : void
      {
         var _loc2_:TimelineAnimation = this.getStateAnimation(this.getCurrentState());
         this.setCurrentTimelineAnimation(_loc2_);
      }
      
      public function getTransitionsEnabled() : Boolean
      {
         return this._transitionsEnabled;
      }
      
      public function setTransitionsEnabled(param1:Boolean) : void
      {
         this._transitionsEnabled = param1;
         if(!this._transitionsEnabled)
         {
            if(Boolean(this._currentTimelineAnimation) && !this._currentTimelineAnimation.getHasCompleted())
            {
               this._currentTimelineAnimation.complete();
            }
         }
      }
      
      override public function destroy() : void
      {
         var _loc1_:String = null;
         this._currentStateChanging.removeAll();
         this._currentStateChanged.removeAll();
         this._currentTimelineAnimationChanged.removeAll();
         for(_loc1_ in this.timelineAnimations)
         {
            TimelineAnimation(this.timelineAnimations[_loc1_]).destroy();
         }
         this._currentTimelineAnimation = null;
         super.destroy();
      }
   }
}

