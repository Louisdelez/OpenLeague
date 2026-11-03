package blix.action
{
   public class CallAction extends BasicAction
   {
      
      private var _func:Function;
      
      private var _args:Array;
      
      private var _dontWait:Boolean = false;
      
      public function CallAction(param1:Function = null, param2:Array = null, param3:Boolean = false, param4:Boolean = false)
      {
         super(param4);
         this._func = param1;
         this._args = param2;
         this._dontWait = param3;
      }
      
      override protected function doInvocation() : void
      {
         if(this._func != null)
         {
            this._func.apply(null,this._args);
         }
         if(this._dontWait)
         {
            complete();
         }
      }
      
      public function getDontWait() : Boolean
      {
         return this._dontWait;
      }
      
      public function setDontWait(param1:Boolean) : void
      {
         this._dontWait = param1;
      }
   }
}

