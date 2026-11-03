package com.riotgames.platform.common.commands
{
   public class CompleteMock
   {
      
      private var _resultCalls:int = 0;
      
      public var completeData:Object;
      
      public var resultData:Object;
      
      private var _errorCalls:int = 0;
      
      public var errorData:Object;
      
      private var _completeCalls:int = 0;
      
      public function CompleteMock()
      {
         super();
      }
      
      public function onError(param1:Object) : void
      {
         this.errorData = param1;
         ++this._errorCalls;
      }
      
      public function onResult(param1:Object) : void
      {
         this.resultData = param1;
         ++this._resultCalls;
      }
      
      public function get errorCalls() : int
      {
         return this._errorCalls;
      }
      
      public function onComplete(param1:Object) : void
      {
         this.completeData = param1;
         ++this._completeCalls;
      }
      
      public function get completeCalls() : int
      {
         return this._completeCalls;
      }
      
      public function get resultCalls() : int
      {
         return this._resultCalls;
      }
   }
}

