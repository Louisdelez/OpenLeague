package com.riotgames.platform.common.utils
{
   import flash.xml.XMLDocument;
   import mx.rpc.Fault;
   
   public class ServiceLogger
   {
      
      private static var targets:Array = [];
      
      public function ServiceLogger()
      {
         super();
      }
      
      public static function requestMaestro(param1:String, param2:Array = null) : void
      {
         if(available)
         {
            log(ServiceInvocation.MAESTRO_REQUEST,"maestroSocket",param1,param2);
         }
      }
      
      public static function response(param1:String, param2:String, param3:Object) : void
      {
         if(available)
         {
            log(ServiceInvocation.RESPONSE,param1,param2,[param3]);
         }
      }
      
      public static function requestREST(param1:String, param2:String, param3:String, param4:Array = null) : void
      {
         if(available)
         {
            log(ServiceInvocation.REST_REQUEST,param1 + "[" + param2 + "]",param3,param4);
         }
      }
      
      public static function asyncBroadcast(param1:String, param2:String, param3:Array = null) : void
      {
         if(available)
         {
            log(ServiceInvocation.ASYNC_BROADCAST,param1,param2,param3);
         }
      }
      
      public static function info(param1:String, param2:String, param3:Array = null) : void
      {
         if(available)
         {
            log(ServiceInvocation.INFO,param1,param2,param3);
         }
      }
      
      public static function asyncClient(param1:String, param2:String, param3:Array = null) : void
      {
         if(available)
         {
            log(ServiceInvocation.ASYNC_CLIENT,param1,param2,param3);
         }
      }
      
      public static function XMPPOutgoing(param1:String) : void
      {
         var xml:XML = null;
         var nodeName:String = null;
         var emsg:String = null;
         var raw:String = param1;
         if(available)
         {
            try
            {
               if(raw == null || raw.length < 3)
               {
                  return;
               }
               if(raw.indexOf("<stream:stream") != -1)
               {
                  log(ServiceInvocation.OUTGOING_XMPP,"stream","opening",[raw]);
                  return;
               }
               if(raw.indexOf("<stream:features") != -1)
               {
                  log(ServiceInvocation.OUTGOING_XMPP,"stream","features",[raw]);
                  return;
               }
               if(raw.indexOf("</stream:stream") != -1)
               {
                  log(ServiceInvocation.OUTGOING_XMPP,"stream","closing",[raw]);
                  return;
               }
               xml = new XML(raw);
               nodeName = xml.name();
               switch(nodeName)
               {
                  case "presence":
                     if(xml.@to.length() > 0)
                     {
                        log(ServiceInvocation.OUTGOING_XMPP,"presence","directed",[raw]);
                     }
                     else
                     {
                        log(ServiceInvocation.OUTGOING_XMPP,"presence","general",[raw]);
                     }
                     break;
                  case "iq":
                     log(ServiceInvocation.OUTGOING_XMPP,"iq",xml.@type,[raw]);
                     break;
                  case "message":
                     log(ServiceInvocation.OUTGOING_XMPP,"message",xml.@type,[raw]);
                     break;
                  case "urn:ietf:params:xml:ns:xmpp-sasl::auth":
                     log(ServiceInvocation.OUTGOING_XMPP,"auth","auth",[raw]);
                     break;
                  default:
                     log(ServiceInvocation.OUTGOING_XMPP,"unknown",nodeName,[raw]);
               }
            }
            catch(e:Error)
            {
               emsg = "outgoing " + e.message;
               trace(emsg);
            }
         }
      }
      
      public static function fault(param1:String, param2:String, param3:Fault) : void
      {
         if(available)
         {
            log(ServiceInvocation.FAULT,param1,param2,[param3]);
         }
      }
      
      private static function log(param1:String, param2:String, param3:String, param4:Array) : void
      {
         var _loc5_:IServiceLogger = null;
         for each(_loc5_ in targets)
         {
            _loc5_.addInvocation(param1,param2,param3,param4);
         }
      }
      
      public static function asyncGame(param1:String, param2:String, param3:Array = null) : void
      {
         if(available)
         {
            log(ServiceInvocation.ASYNC_GAME,param1,param2,param3);
         }
      }
      
      public static function request(param1:String, param2:String, param3:Array = null) : void
      {
         if(available)
         {
            log(ServiceInvocation.LCDS_REQUEST,param1,param2,param3);
         }
      }
      
      private static function get available() : Boolean
      {
         return targets.length > 0;
      }
      
      public static function addTarget(param1:IServiceLogger) : void
      {
         removeTarget(param1);
         targets.push(param1);
      }
      
      public static function responseREST(param1:String, param2:String, param3:String) : void
      {
         if(available)
         {
            log(ServiceInvocation.REST_RESPONSE,param1 + "[" + param2 + "]","(void)",[param3]);
         }
      }
      
      public static function faultREST(param1:String, param2:String, param3:Fault) : void
      {
         if(available)
         {
            log(ServiceInvocation.REST_FAULT,param1 + "[" + param2 + "]","(void)",[param3]);
         }
      }
      
      public static function XMPPIncoming(param1:XMLDocument) : void
      {
         var raw:String = null;
         var xml:XML = null;
         var nodeName:String = null;
         var emsg:String = null;
         var data:XMLDocument = param1;
         if(available)
         {
            try
            {
               raw = data.toString();
               if(raw == null || raw.length < 3)
               {
                  return;
               }
               if(raw.indexOf("<stream:stream") != -1)
               {
                  log(ServiceInvocation.INCOMING_XMPP,"stream","opening",[raw]);
                  return;
               }
               if(raw.indexOf("<stream:features") != -1)
               {
                  log(ServiceInvocation.INCOMING_XMPP,"stream","features",[raw]);
                  return;
               }
               if(raw.indexOf("<stream:error") != -1)
               {
                  log(ServiceInvocation.INCOMING_XMPP,"stream","error",[raw]);
                  return;
               }
               if(raw.indexOf("</stream:stream") != -1)
               {
                  log(ServiceInvocation.INCOMING_XMPP,"stream","closing",[raw]);
                  return;
               }
               xml = new XML(raw);
               nodeName = xml.name();
               switch(nodeName)
               {
                  case "presence":
                     log(ServiceInvocation.INCOMING_XMPP,"presence","receive",[raw]);
                     break;
                  case "iq":
                     log(ServiceInvocation.INCOMING_XMPP,"iq",xml.@type,[raw]);
                     break;
                  case "message":
                     log(ServiceInvocation.INCOMING_XMPP,"message",xml.@type,[raw]);
                     break;
                  case "urn:ietf:params:xml:ns:xmpp-sasl::success":
                     log(ServiceInvocation.INCOMING_XMPP,"auth","success",[raw]);
                     break;
                  default:
                     log(ServiceInvocation.INCOMING_XMPP,"unknown",nodeName,[raw]);
               }
            }
            catch(e:Error)
            {
               emsg = "incoming " + e.message;
               trace(emsg);
            }
         }
      }
      
      public static function removeTarget(param1:IServiceLogger) : void
      {
         var _loc2_:int = targets.indexOf(param1);
         if(_loc2_ >= 0)
         {
            targets.splice(_loc2_,1);
         }
      }
      
      public static function responseMaestro(param1:String, param2:Object) : void
      {
         if(available)
         {
            log(ServiceInvocation.MAESTRO_RESPONSE,"maestroSocket",param1,[param2]);
         }
      }
   }
}

