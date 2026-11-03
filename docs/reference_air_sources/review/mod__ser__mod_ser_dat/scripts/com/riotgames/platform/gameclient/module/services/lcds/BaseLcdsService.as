package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.RiotServiceConfig;
   import com.riotgames.platform.common.services.IRemoteExceptionFactory;
   import com.riotgames.platform.common.services.InterruptibleRemoteService;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.platform.gameclient.module.services.RemoteObjectGenerator;
   import com.riotgames.platform.gameclient.module.services.utils.ServicesPersistenceUtils;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import flash.utils.setTimeout;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.ChannelSet;
   import mx.rpc.AbstractOperation;
   import mx.rpc.AsyncToken;
   import mx.rpc.remoting.RemoteObject;
   
   public class BaseLcdsService implements InterruptibleRemoteService, IBaseLcdsService
   {
      
      private var remoteExceptionFactory:IRemoteExceptionFactory = null;
      
      public var config:RiotServiceConfig;
      
      public var remoteObjectGenerator:RemoteObjectGenerator;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session;
      
      public function BaseLcdsService()
      {
         super();
      }
      
      public function setRemoteExceptionFactory(param1:IRemoteExceptionFactory) : void
      {
         this.remoteExceptionFactory = param1;
      }
      
      protected function prepareChannelSet() : ChannelSet
      {
         return this.remoteObjectGenerator.defaultChannelSet;
      }
      
      private function performInvoke(param1:ChannelSet, param2:String, param3:String, param4:Array, param5:Function, param6:Function, param7:Dictionary = null, param8:Object = null, param9:Boolean = true, param10:Boolean = true, param11:Boolean = true) : void
      {
         var remoteMethod:String;
         var callCount:Number;
         var retToken:AsyncToken;
         var operation:AbstractOperation;
         var callDate:Date;
         var debugArgString:String;
         var ro:RemoteObject;
         var callback:Function = null;
         var channelSet:ChannelSet = param1;
         var destination:String = param2;
         var method:String = param3;
         var args:Array = param4;
         var onSuccess:Function = param5;
         var onComplete:Function = param6;
         var errorMap:Dictionary = param7;
         var asyncObject:Object = param8;
         var logCall:Boolean = param9;
         var logResponse:Boolean = param10;
         var logFault:Boolean = param11;
         if(Boolean(this.remoteExceptionFactory) && Boolean(this.remoteExceptionFactory.shouldInterruptServiceCall(destination,method,args)))
         {
            callback = function():void
            {
               var _loc1_:Object = remoteExceptionFactory.generateSimulatedRemoteServiceError(destination,method,args);
               if(onComplete != null)
               {
                  onComplete(_loc1_);
               }
               var _loc2_:Function = errorMap[_loc1_.constructor];
               if(_loc2_ != null)
               {
                  _loc2_(_loc1_);
               }
            };
            setTimeout(callback,100);
            return;
         }
         debugArgString = "null";
         remoteMethod = destination + "." + method;
         callCount = this.remoteObjectGenerator.getCallCount(remoteMethod);
         if(args != null)
         {
            debugArgString = args.toString();
         }
         ro = this.remoteObjectGenerator.createRemoteObject(channelSet,destination,onComplete,ServicesPersistenceUtils.onSuccessWrapper(remoteMethod,this.config,onSuccess),errorMap,logResponse,logFault);
         operation = ro.getOperation(method);
         callDate = new Date();
         operation.arguments = args;
         retToken = operation.send();
         retToken.remoteMethod = remoteMethod;
         retToken.argString = debugArgString;
         retToken.args = args;
         retToken.callDate = callDate;
         retToken.callCount = callCount;
         if(asyncObject != null)
         {
            retToken.asyncObject = asyncObject;
         }
         if(logCall)
         {
            ServiceLogger.request(destination,method,args);
         }
      }
      
      public function invokeServiceWithoutSession(param1:String, param2:String, param3:Array, param4:Function, param5:Function = null, param6:Dictionary = null, param7:Object = null, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : void
      {
         var _loc11_:ChannelSet = this.prepareChannelSet();
         this.performInvoke(_loc11_,param1,param2,param3,param4,param5,param6,param7,param8,param9,param10);
      }
      
      public function invokeServiceWithSession(param1:String, param2:String, param3:Array, param4:Function, param5:Function = null, param6:Dictionary = null, param7:Object = null, param8:Boolean = true, param9:Boolean = true, param10:Boolean = true) : void
      {
         var _loc11_:Array = [this.session.token].concat(param3);
         var _loc12_:ChannelSet = this.prepareChannelSet();
         this.performInvoke(_loc12_,param1,param2,_loc11_,param4,param5,param6,param7,param8,param9,param10);
      }
   }
}

