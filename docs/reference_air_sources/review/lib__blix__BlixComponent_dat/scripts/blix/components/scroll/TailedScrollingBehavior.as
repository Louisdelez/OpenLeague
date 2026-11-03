package blix.components.scroll
{
   import blix.IDestructible;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class TailedScrollingBehavior implements IDestructible
   {
      
      public var affordance:Number = 0.005;
      
      public var positionPercent:Number = 1;
      
      public var timeAfterUserInteraction:uint = 10000;
      
      private var userInteractionTimeoutId:uint = 0;
      
      private var _scrollModel:ScrollModel;
      
      private var _enabled:Boolean = true;
      
      private var isInternalChange:Boolean = false;
      
      private var lastValue:Number;
      
      public function TailedScrollingBehavior(param1:ScrollModel)
      {
         super();
         this._scrollModel = param1;
         this._scrollModel.getChanged().add(this.scrollModelChangedHandler);
         this.lastValue = this._scrollModel.getValue();
      }
      
      private function scrollModelChangedHandler() : void
      {
         var _loc3_:Number = NaN;
         var _loc1_:Boolean = this.lastValue != this._scrollModel.getValue();
         this.lastValue = this._scrollModel.getValue();
         if(!this._enabled || this.isInternalChange)
         {
            return;
         }
         var _loc2_:Number = this._scrollModel.getMax() - this._scrollModel.getMin();
         if(_loc1_)
         {
            clearTimeout(this.userInteractionTimeoutId);
            this.userInteractionTimeoutId = 0;
            _loc3_ = (this._scrollModel.getClampedValue() - this._scrollModel.getMin()) / _loc2_;
            if(Math.abs(_loc3_ - this.positionPercent) > this.affordance)
            {
               this.userInteractionTimeoutId = setTimeout(this.userInteractionTimeoutHandler,this.timeAfterUserInteraction);
            }
         }
         else if(this.userInteractionTimeoutId == 0)
         {
            this.isInternalChange = true;
            this._scrollModel.setValue(_loc2_ * this.positionPercent + this._scrollModel.getMin());
            this.isInternalChange = false;
         }
      }
      
      private function userInteractionTimeoutHandler() : void
      {
         this.userInteractionTimeoutId = 0;
      }
      
      public function getScrollModel() : ScrollModel
      {
         return this._scrollModel;
      }
      
      public function getEnabled() : Boolean
      {
         return this._enabled;
      }
      
      public function setEnabled(param1:Boolean) : void
      {
         this._enabled = param1;
      }
      
      public function destroy() : void
      {
         clearTimeout(this.userInteractionTimeoutId);
         this._scrollModel.getChanged().remove(this.scrollModelChangedHandler);
      }
   }
}

