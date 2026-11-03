package com.riotgames.platform.gameclient.module.services.lcds
{
   import com.riotgames.platform.common.domain.AuthenticationCredentials;
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.event.RemoteServiceErrorEvent;
   import com.riotgames.platform.common.exception.PlatformException;
   import com.riotgames.platform.common.exception.UnexpectedServiceException;
   import com.riotgames.platform.common.session.Session;
   import com.riotgames.platform.common.utils.ClientErrorCodes;
   import com.riotgames.platform.common.utils.ServiceLogger;
   import com.riotgames.pvpnet.system.messaging.ShellDispatcher;
   import com.riotgames.util.logging.ErrorUtil;
   import flash.events.Event;
   import flash.net.getClassByAlias;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.logging.ILogger;
   import mx.logging.Log;
   import mx.messaging.events.ChannelFaultEvent;
   import mx.messaging.messages.RemotingMessage;
   import mx.rpc.Fault;
   import mx.rpc.events.FaultEvent;
   import mx.rpc.events.ResultEvent;
   
   public class LcdsErrorHandler
   {
      
      public static const LCDS_SERVICE_RESPONSE:String = "lcdsServiceResponse";
      
      private var _logResponse:Boolean;
      
      private var logger:ILogger = Log.getLogger(getQualifiedClassName(this).replace(/::/,"."));
      
      public var session:Session;
      
      public var shellDispatcher:ShellDispatcher = ShellDispatcher.instance;
      
      private var _logFault:Boolean;
      
      public function LcdsErrorHandler(param1:Boolean, param2:Boolean)
      {
         super();
         this._logResponse = param1;
         this._logFault = param2;
      }
      
      public function createOnSuccessHandlingProxy(param1:Function, param2:Function) : Function
      {
         var onComplete:Function = param1;
         var onSuccess:Function = param2;
         return function(param1:ResultEvent):void
         {
            if(_logResponse)
            {
               logServiceResponse(param1,param1.result);
            }
            shellDispatcher.dispatchEvent(new Event(LCDS_SERVICE_RESPONSE));
            if(onSuccess != null)
            {
               onSuccess.apply(null,[param1]);
            }
            if(onComplete != null)
            {
               onComplete.apply(null,[param1]);
            }
         };
      }
      
      private function cleanseSensitiveData(param1:Object) : void
      {
         var _loc2_:AuthenticationCredentials = null;
         var _loc3_:Object = null;
         if(param1 is AuthenticationCredentials)
         {
            _loc2_ = param1 as AuthenticationCredentials;
         }
         else if(param1 is Array)
         {
            for each(_loc3_ in param1 as Array)
            {
               if(_loc3_ is AuthenticationCredentials)
               {
                  _loc2_ = _loc3_ as AuthenticationCredentials;
                  break;
               }
            }
         }
         if(_loc2_ != null)
         {
            _loc2_.password = _loc2_.password != null ? _loc2_.password.replace(/\w/g,"*") : null;
            _loc2_.oldPassword = _loc2_.oldPassword != null ? _loc2_.oldPassword.replace(/\w/g,"*") : null;
            _loc2_.partnerCredentials = _loc2_.partnerCredentials != null ? _loc2_.partnerCredentials.replace(/\w/g,"*") : null;
         }
      }
      
      private function logServiceFault(param1:FaultEvent, param2:Fault) : void
      {
         var _loc3_:RemotingMessage = null;
         if(param1.token != null && param1.token.message is RemotingMessage)
         {
            _loc3_ = param1.token.message as RemotingMessage;
            ServiceLogger.fault(_loc3_.destination,_loc3_.operation,param2);
         }
         else if(param1.message != null)
         {
            ServiceLogger.fault(param1.message.destination,"unknown",param2);
         }
         else
         {
            ServiceLogger.fault("unknown","unknown",param2);
         }
      }
      
      private function logServiceResponse(param1:ResultEvent, param2:Object) : void
      {
         var _loc3_:RemotingMessage = null;
         if(param1.token != null && param1.token.message is RemotingMessage)
         {
            _loc3_ = param1.token.message as RemotingMessage;
            this.cleanseSensitiveData(_loc3_.body);
            ServiceLogger.response(_loc3_.destination,_loc3_.operation,param2);
         }
         else if(param1.message != null)
         {
            ServiceLogger.response(param1.message.destination,"unknown",param2);
         }
         else
         {
            ServiceLogger.response("unknown","unknown",param2);
         }
      }
      
      public function createOnErrorHandlingProxy(param1:Function, param2:Dictionary) : Function
      {
         var onComplete:Function = param1;
         var errorMap:Dictionary = param2;
         return function(param1:FaultEvent):void
         {
            var rootCauseClassname:* = undefined;
            var remoteServiceErrorEvent:* = undefined;
            var clazz:* = undefined;
            var errorFunction:* = undefined;
            var faultCode:* = undefined;
            var serverError:* = undefined;
            var unexpectedServiceException:* = undefined;
            var platformException:* = undefined;
            var authenticationCredentialsError:* = undefined;
            var faultString:* = undefined;
            var event:FaultEvent = param1;
            var exception:* = event.fault.rootCause;
            var isHandledException:* = false;
            if(errorMap == null)
            {
               errorMap = new Dictionary();
            }
            if(_logFault)
            {
               logServiceFault(event,event.fault);
            }
            if(errorMap != null)
            {
               errorFunction = errorMap[exception] as Function;
               if(errorFunction == null && exception != null && Boolean(exception.hasOwnProperty("rootCauseClassname")))
               {
                  rootCauseClassname = exception["rootCauseClassname"];
                  try
                  {
                     clazz = getClassByAlias(rootCauseClassname);
                     errorFunction = errorMap[clazz] as Function;
                  }
                  catch(e:Error)
                  {
                  }
                  errorFunction = errorFunction == null ? errorMap[rootCauseClassname] as Function : errorFunction;
               }
               else if(errorFunction == null && exception != null && Boolean(exception.hasOwnProperty("faultCode")))
               {
                  faultCode = exception["faultCode"];
                  errorFunction = errorMap[faultCode] as Function;
               }
            }
            if(exception == null)
            {
               errorFunction = errorMap[ServerError.UNEXPECTED_SERVICE_EXCEPTION] as Function;
            }
            isHandledException = errorFunction != null;
            if(Boolean(event.fault) && Boolean(event.fault.faultString))
            {
               logger.error(ErrorUtil.makeErrorMessage(event.fault,"createOnErrorHandlingProxy: exception fault: " + event.fault.faultString));
            }
            else
            {
               logger.error("9002 RemoteObjectGenerator: createOnErrorHandlingProxy: got a handled exception of type: " + event.toString());
            }
            if(isHandledException)
            {
               if(errorFunction != null)
               {
                  serverError = new ServerError(event);
                  errorFunction.apply(null,[serverError]);
               }
            }
            else if(exception is UnexpectedServiceException)
            {
               unexpectedServiceException = UnexpectedServiceException(exception);
               rootCauseClassname = unexpectedServiceException.rootCauseClassname;
               if(rootCauseClassname == ServerError.INVALID_SESSION_ERROR)
               {
                  remoteServiceErrorEvent = new RemoteServiceErrorEvent(RemoteServiceErrorEvent.SESSION_TIMEOUT,event,"Session timeout");
                  shellDispatcher.dispatchEvent(remoteServiceErrorEvent);
                  logger.warn("9003 RemoteObjectGenerator: createOnErrorHandlingProxy: unhandled exception Session timeout");
               }
               else
               {
                  remoteServiceErrorEvent = new RemoteServiceErrorEvent(RemoteServiceErrorEvent.UNHANDLED_REMOTE_SERVICE_ERROR,event,"Unhandled Remote Service Error");
                  shellDispatcher.dispatchEvent(remoteServiceErrorEvent);
                  logger.warn("9004 RemoteObjectGenerator: createOnErrorHandlingProxy: unhandled remove service error");
               }
            }
            else if(exception is ChannelFaultEvent)
            {
               logger.warn("9005 RemoteObjectGenerator: createOnErrorHandlingProxy: unhandled exception ChannelFaultEvent");
               remoteServiceErrorEvent = new RemoteServiceErrorEvent(RemoteServiceErrorEvent.CLIENT_ERROR,event,"Client error");
               shellDispatcher.dispatchEvent(remoteServiceErrorEvent);
            }
            else if(exception is PlatformException)
            {
               platformException = PlatformException(exception);
               logger.warn("9006 Unable to locate error handler function for exception: " + platformException.rootCauseClassname);
               remoteServiceErrorEvent = new RemoteServiceErrorEvent(RemoteServiceErrorEvent.UNHANDLED_REMOTE_SERVICE_ERROR,event,"Unhandled Platform Error");
               shellDispatcher.dispatchEvent(remoteServiceErrorEvent);
            }
            else if(Boolean(event.fault) && event.fault.faultCode == ClientErrorCodes.DELIVERY_IN_DOUBT)
            {
               logger.warn("9007 RemoteObjectGenerator: createOnErrorHandlingProxy: unhandled exception " + ClientErrorCodes.DELIVERY_IN_DOUBT);
               remoteServiceErrorEvent = new RemoteServiceErrorEvent(RemoteServiceErrorEvent.CLIENT_ERROR,event,"Client error");
               shellDispatcher.dispatchEvent(remoteServiceErrorEvent);
            }
            else
            {
               authenticationCredentialsError = false;
               if(event.fault != null)
               {
                  faultString = event.fault.faultString;
                  if(faultString != null)
                  {
                     if(faultString.indexOf("AuthenticationCredentialsNotFoundException") > 0)
                     {
                        if(session.token != null)
                        {
                           authenticationCredentialsError = true;
                        }
                     }
                  }
               }
               if(authenticationCredentialsError)
               {
                  logger.warn("9008 RemoteObjectGenerator: createOnErrorHandlingProxy: unhandled exception Invalid autentication credentials.");
                  remoteServiceErrorEvent = new RemoteServiceErrorEvent(RemoteServiceErrorEvent.AUTHENTICATION_CREDENTIALS_ERROR,event,"Invalid autentication credentials.");
                  shellDispatcher.dispatchEvent(remoteServiceErrorEvent);
               }
               else
               {
                  logger.warn("9009 RemoteObjectGenerator: createOnErrorHandlingProxy: unhandled exception Unknown Remote Service Error.");
                  remoteServiceErrorEvent = new RemoteServiceErrorEvent(RemoteServiceErrorEvent.UNKNOWN_ERROR,event,"Unknown Remote Service Error");
                  shellDispatcher.dispatchEvent(remoteServiceErrorEvent);
               }
            }
            if(onComplete != null)
            {
               onComplete.apply(null,[false]);
            }
         };
      }
   }
}

