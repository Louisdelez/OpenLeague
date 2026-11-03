package blix.assets.proxy
{
   internal final class PendingCall
   {
      
      public var func:String;
      
      public var args:Array;
      
      public function PendingCall(param1:String, param2:Array)
      {
         super();
         this.func = param1;
         this.args = param2;
      }
      
      internal function execute(param1:*) : void
      {
         var _loc2_:Function = param1[this.func] as Function;
         var _loc3_:uint = this.args == null ? 0 : this.args.length;
         if(_loc3_ == 0)
         {
            _loc2_();
         }
         else if(_loc3_ == 1)
         {
            _loc2_(this.args[0]);
         }
         else if(_loc3_ == 2)
         {
            _loc2_(this.args[0],this.args[1]);
         }
         else
         {
            _loc2_.apply(null,this.args);
         }
      }
      
      public function toString() : String
      {
         return "PendingCall{func=" + String(this.func) + ",args=" + String(this.args) + "}";
      }
   }
}

