package com.riotgames.binding
{
   public dynamic class BindingAsyncToken
   {
      
      private var _id:uint;
      
      private var _successCallback:Function;
      
      private var _failureCallback:Function;
      
      private var _cancellationCallback:Function;
      
      public function BindingAsyncToken(param1:uint)
      {
         super();
      }
      
      public function get Id() : uint
      {
         return this._id;
      }
      
      public function get SuccessCallback() : Function
      {
         return this._successCallback;
      }
      
      public function set SuccessCallback(param1:Function) : void
      {
         this._successCallback = param1;
      }
      
      public function get FailureCallback() : Function
      {
         return this._failureCallback;
      }
      
      public function set FailureCallback(param1:Function) : void
      {
         this._failureCallback = param1;
      }
      
      public function get CancellationCallback() : Function
      {
         return this._cancellationCallback;
      }
      
      public function set CancellationCallback(param1:Function) : void
      {
         this._cancellationCallback = param1;
      }
      
      internal function NotifySuccess(param1:Object) : void
      {
         if(this._successCallback != null)
         {
            this._successCallback(this,param1);
         }
      }
      
      internal function NotifyFailure(param1:String) : void
      {
         if(this._failureCallback != null)
         {
            this._failureCallback(this,param1);
         }
      }
      
      internal function NotifyCancellation() : void
      {
         if(this._cancellationCallback != null)
         {
            this._cancellationCallback(this);
         }
      }
   }
}

