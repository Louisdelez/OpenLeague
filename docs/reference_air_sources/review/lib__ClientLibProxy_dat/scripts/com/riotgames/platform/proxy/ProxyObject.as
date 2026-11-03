package com.riotgames.platform.proxy
{
   public class ProxyObject implements IProxyObject
   {
      
      private var _pendingActions:Vector.<IPendingAction>;
      
      private var _target:Object;
      
      public function ProxyObject()
      {
         super();
         this._pendingActions = new Vector.<IPendingAction>();
      }
      
      public function __setTarget(param1:Object) : void
      {
         var _loc2_:IPendingAction = null;
         this._target = param1;
         if(this._target != null)
         {
            for each(_loc2_ in this._pendingActions)
            {
               _loc2_.invoke(this._target);
            }
            this._pendingActions.length = 0;
         }
      }
      
      public function __methodInvoke(param1:String, param2:Array, param3:IProxyObject = null) : *
      {
         var _loc4_:PendingMethodCall = new PendingMethodCall(param1,param2,param3);
         if(this._target != null)
         {
            return _loc4_.invoke(this._target);
         }
         this._pendingActions[this._pendingActions.length] = _loc4_;
         return param3;
      }
      
      public function __setInvoke(param1:String, param2:*) : void
      {
         var _loc3_:PendingSetCall = new PendingSetCall(param1,param2);
         if(this._target != null)
         {
            _loc3_.invoke(this._target);
         }
         else
         {
            this._pendingActions[this._pendingActions.length] = _loc3_;
         }
      }
      
      public function __getInvoke(param1:String, param2:IProxyObject = null) : *
      {
         var _loc3_:PendingGetCall = new PendingGetCall(param1,param2);
         if(this._target != null)
         {
            return _loc3_.invoke(this._target);
         }
         this._pendingActions[this._pendingActions.length] = _loc3_;
         return param2;
      }
   }
}

import com.riotgames.platform.proxy.IProxyObject;

interface IPendingAction
{
   
   function invoke(param1:Object) : *;
}

class PendingMethodCall implements IPendingAction
{
   
   private var methodName:String;
   
   private var args:Array;
   
   private var returnProxy:IProxyObject;
   
   public function PendingMethodCall(param1:String, param2:Array, param3:IProxyObject = null)
   {
      super();
      this.methodName = param1;
      this.args = param2;
      this.returnProxy = param3;
   }
   
   public function invoke(param1:Object) : *
   {
      var _loc2_:Function = param1[this.methodName];
      var _loc3_:* = _loc2_.apply(null,this.args);
      if(this.returnProxy != null)
      {
         this.returnProxy.__setTarget(_loc3_);
      }
      return _loc3_;
   }
}

class PendingSetCall implements IPendingAction
{
   
   private var setterName:String;
   
   private var value:*;
   
   public function PendingSetCall(param1:String, param2:Array)
   {
      super();
      this.setterName = param1;
      this.value = param2;
   }
   
   public function invoke(param1:Object) : *
   {
      param1[this.setterName] = this.value;
   }
}

class PendingGetCall implements IPendingAction
{
   
   private var getterName:String;
   
   private var returnProxy:IProxyObject;
   
   public function PendingGetCall(param1:String, param2:IProxyObject = null)
   {
      super();
      this.getterName = param1;
      this.returnProxy = param2;
   }
   
   public function invoke(param1:Object) : *
   {
      var _loc2_:* = param1[this.getterName];
      if(this.returnProxy != null)
      {
         this.returnProxy.__setTarget(_loc2_);
      }
      return _loc2_;
   }
}
