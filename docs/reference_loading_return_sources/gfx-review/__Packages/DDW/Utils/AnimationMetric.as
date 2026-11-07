class DDW.Utils.AnimationMetric
{
   var _isComplete;
   var callbackArg;
   var callbackTarget;
   var completionCallback;
   var endMetric;
   var hasCalledBack;
   var inc;
   var startMetric;
   var steps;
   var t;
   var tweenFormula;
   function AnimationMetric(startMetric, endMetric, steps, completionCallback, callbackTarget, callbackArg)
   {
      this.startMetric = startMetric;
      this.endMetric = endMetric;
      this.steps = steps;
      this.completionCallback = completionCallback;
      this.callbackTarget = callbackTarget;
      this.callbackArg = callbackArg;
      this._isComplete = false;
      this.hasCalledBack = false;
      this.inc = 1 / steps;
      this.tweenFormula = this.linearIncrement;
   }
   function start()
   {
      this.t = 0;
      this._isComplete = false;
   }
   function end()
   {
      this.t = 1;
   }
   function revertAnimationInstant()
   {
      this.endMetric = this.startMetric;
      this.t = 1;
      this._isComplete = false;
   }
   function revertAnimationSmooth()
   {
      var _loc2_ = this.getCurrentMetric();
      this.endMetric = this.startMetric;
      this.startMetric = _loc2_;
      this.t = 1 - this.t;
      this._isComplete = false;
   }
   function incrementT()
   {
      this._isComplete = false;
      this.t += this.inc;
      if(this.t > 1)
      {
         this.t = 1;
         this._isComplete = true;
         if(!this.hasCalledBack && this.completionCallback != null)
         {
            if(this.callbackTarget != null)
            {
               this.completionCallback.apply(this.callbackTarget,[this.callbackArg]);
            }
            else
            {
               this.completionCallback(this,this.callbackArg);
            }
            this.hasCalledBack = true;
         }
      }
   }
   function get isComplete()
   {
      return this._isComplete;
   }
   function getCurrentMetric()
   {
      var _loc2_;
      if(this.t == 1)
      {
         _loc2_ = this.endMetric;
      }
      else
      {
         _loc2_ = this.tweenFormula();
      }
      return _loc2_;
   }
   function linearIncrement()
   {
      var _loc2_ = this.endMetric.x != null ? (this.endMetric.x - this.startMetric.x) * this.t + this.startMetric.x : null;
      var _loc3_ = this.endMetric.y != null ? (this.endMetric.y - this.startMetric.y) * this.t + this.startMetric.y : null;
      var _loc4_ = this.endMetric.width != null ? (this.endMetric.width - this.startMetric.width) * this.t + this.startMetric.width : null;
      var _loc5_ = this.endMetric.height != null ? (this.endMetric.height - this.startMetric.height) * this.t + this.startMetric.height : null;
      var _loc6_ = this.endMetric.alpha != null ? (this.endMetric.alpha - this.startMetric.alpha) * this.t + this.startMetric.alpha : null;
      var _loc7_ = this.endMetric.scale != null ? (this.endMetric.scale - this.startMetric.scale) * this.t + this.startMetric.scale : null;
      var _loc8_ = this.endMetric.value != null ? (this.endMetric.value - this.startMetric.value) * this.t + this.startMetric.value : null;
      var _loc9_ = new DDW.Utils.Metrics(_loc2_,_loc3_,_loc4_,_loc5_,_loc6_,_loc7_,this.endMetric.propertyName,_loc8_);
      return _loc9_;
   }
   function toString()
   {
      return "anim: " + this.t + "   st:" + this.startMetric + "   end:" + this.endMetric;
   }
}
