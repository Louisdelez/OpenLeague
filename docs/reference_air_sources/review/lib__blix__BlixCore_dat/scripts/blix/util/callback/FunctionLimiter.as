package blix.util.callback
{
   import flash.utils.setTimeout;
   
   public class FunctionLimiter
   {
      
      public var func:Function;
      
      public var args:Array;
      
      public var delay:int;
      
      public var callBeforeDelay:Boolean = true;
      
      public var callAfterDelay:Boolean;
      
      protected var callIsPending:Boolean;
      
      protected var _enabled:Boolean = true;
      
      public function FunctionLimiter()
      {
         super();
      }
      
      public function call(... rest) : void
      {
         if(!this._enabled)
         {
            if(this.callAfterDelay)
            {
               this.callIsPending = true;
            }
            return;
         }
         if(this.callBeforeDelay || this.delay <= 0)
         {
            this.doCall.apply(null,rest);
         }
         if(this.delay > 0)
         {
            this._enabled = false;
            setTimeout.apply(null,[this.enable,this.delay].concat(rest));
         }
      }
      
      private function enable(... rest) : void
      {
         this._enabled = true;
         if(this.callIsPending)
         {
            this.doCall.apply(null,rest);
         }
      }
      
      public function getEnabled() : Boolean
      {
         return this._enabled;
      }
      
      private function doCall(... rest) : void
      {
         if(this.args != null)
         {
            this.func.apply(null,rest.concat(this.args));
         }
         else
         {
            this.func.apply(null,rest);
         }
      }
   }
}

