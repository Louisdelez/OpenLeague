package blix.logger
{
   import blix.signals.ISignal;
   import blix.signals.Signal;
   
   public class ArrayTarget extends LogTarget
   {
      
      public var maxMessages:uint = 100;
      
      private var _changed:Signal = new Signal();
      
      private var messages:Vector.<String> = new Vector.<String>();
      
      public function ArrayTarget(param1:ILoggingManager)
      {
         super(param1);
      }
      
      public function getMessages() : Vector.<String>
      {
         return this.messages;
      }
      
      override protected function logMessage(param1:String, param2:uint) : void
      {
         this.messages[this.messages.length] = LogLevelsEnum.levelToString(param2) + ": " + param1;
         if(this.messages.length > this.maxMessages)
         {
            this.messages.unshift();
         }
         this._changed.dispatch();
      }
      
      public function getChanged() : ISignal
      {
         return this._changed;
      }
   }
}

