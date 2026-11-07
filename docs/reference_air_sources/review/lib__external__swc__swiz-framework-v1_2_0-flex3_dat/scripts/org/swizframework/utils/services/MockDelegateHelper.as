package org.swizframework.utils.services
{
   import flash.events.TimerEvent;
   import flash.utils.Dictionary;
   import flash.utils.Timer;
   import mx.core.mx_internal;
   import mx.managers.CursorManager;
   import mx.rpc.AsyncToken;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   public class MockDelegateHelper
   {
      
      public var calls:Dictionary;
      
      public var fault:Fault;
      
      public var showBusyCursor:Boolean;
      
      public function MockDelegateHelper(showBusyCursor:Boolean = false)
      {
         super();
         this.showBusyCursor = showBusyCursor;
         this.calls = new Dictionary();
      }
      
      public function createMockResult(mockData:Object, delay:int = 10) : AsyncToken
      {
         var token:AsyncToken = new AsyncToken();
         token.data = mockData;
         var timer:Timer = new Timer(delay,1);
         timer.addEventListener(TimerEvent.TIMER,this.sendMockResult);
         timer.start();
         this.calls[timer] = token;
         if(this.showBusyCursor)
         {
            CursorManager.setBusyCursor();
         }
         return token;
      }
      
      protected function sendMockResult(event:TimerEvent) : void
      {
         var token:AsyncToken = null;
         var mockData:Object = null;
         if(this.showBusyCursor)
         {
            CursorManager.removeBusyCursor();
         }
         var timer:Timer = Timer(event.target);
         timer.removeEventListener(TimerEvent.TIMER,this.sendMockResult);
         if(this.calls[timer] is AsyncToken)
         {
            token = AsyncToken(this.calls[timer]);
            delete this.calls[timer];
            mockData = Boolean(token.data) ? token.data : new Object();
            token.mx_internal::applyResult(ResultEvent.createEvent(mockData,token));
         }
         timer = null;
      }
      
      public function createMockFault(fault:Fault = null, delay:int = 10) : AsyncToken
      {
         var token:AsyncToken = new AsyncToken();
         token.data = fault;
         var timer:Timer = new Timer(delay,1);
         timer.addEventListener(TimerEvent.TIMER,this.sendMockFault);
         timer.start();
         this.calls[timer] = token;
         if(this.showBusyCursor)
         {
            CursorManager.setBusyCursor();
         }
         return token;
      }
      
      protected function sendMockFault(event:TimerEvent) : void
      {
         var token:AsyncToken = null;
         var fault:Fault = null;
         if(this.showBusyCursor)
         {
            CursorManager.removeBusyCursor();
         }
         var timer:Timer = Timer(event.target);
         timer.removeEventListener(TimerEvent.TIMER,this.sendMockFault);
         if(this.calls[timer] is AsyncToken)
         {
            token = this.calls[timer];
            delete this.calls[timer];
            fault = Boolean(token.data) ? token.data : null;
            token.mx_internal::applyFault(FaultEvent.createEvent(fault,token));
         }
         timer = null;
      }
   }
}

