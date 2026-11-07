package blix.time
{
   public class TimedCallback implements ITimeUpdateable
   {
      
      public var duration:int;
      
      public var delay:int;
      
      public var callback:Function;
      
      public var callbackArgs:Array;
      
      private var _registeredTime:uint;
      
      public function TimedCallback()
      {
         super();
      }
      
      public function init(param1:int, param2:int, param3:Function, param4:Array) : void
      {
         this.duration = param1;
         this.delay = param2;
         this.callback = param3;
         this.callbackArgs = param4;
      }
      
      public function setCurrentTime(param1:int, param2:TimeListItem) : void
      {
         if(param1 < this.delay)
         {
            return;
         }
         if(param1 >= this.duration + this.delay)
         {
            param2.remove = true;
            switch(this.callbackArgs.length)
            {
               case 0:
                  this.callback();
                  break;
               case 1:
                  this.callback(this.callbackArgs[0]);
                  break;
               default:
                  this.callback.apply(null,this.callbackArgs);
            }
         }
      }
      
      public function getRegisteredTime() : int
      {
         return this._registeredTime;
      }
      
      public function setRegisteredTime(param1:int) : void
      {
         this._registeredTime = param1;
      }
   }
}

