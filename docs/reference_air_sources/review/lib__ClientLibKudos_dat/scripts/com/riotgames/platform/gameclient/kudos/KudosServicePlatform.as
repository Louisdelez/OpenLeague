package com.riotgames.platform.gameclient.kudos
{
   import com.riotgames.platform.common.error.ServerError;
   import com.riotgames.platform.common.utils.ClientErrorCodes;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.kudos.PendingKudos;
   import com.riotgames.platform.gameclient.services.IBaseLcdsService;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   import com.riotgames.util.json.jsonDecode;
   import com.riotgames.util.json.jsonEncode;
   import flash.events.EventDispatcher;
   import flash.utils.Dictionary;
   import flash.utils.getQualifiedClassName;
   import mx.rpc.events.ResultEvent;
   
   public class KudosServicePlatform extends EventDispatcher implements IKudosService
   {
      
      public static var SERVICE_NAME:String = "clientFacadeService";
      
      public static var REMOTE_CALL_METHOD_NAME:String = "callKudos";
      
      public static var MESSAGE_CALL_METHOD_NAME:String = "sendKudosMessage";
      
      public static var GIVE_COMMAND:String = "GIVE";
      
      public static var TOTALS_COMMAND:String = "TOTALS";
      
      public static var PENDING_KUDOS_COMMAND:String = "POP_PENDING_KUDOS_COUNTS";
      
      public static var ACKNOLWEDGE_KUDOS_COMMAND:String = "ACK_HONOR_NOTIFICATION";
      
      private var lcdsService:IBaseLcdsService;
      
      public var errorMap:Dictionary;
      
      public function KudosServicePlatform(param1:IBaseLcdsService)
      {
         super();
         this.lcdsService = param1;
         this.buildErrorThingy();
      }
      
      private function traceArgs(param1:Object) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = "";
         for(_loc3_ in param1)
         {
            _loc2_ += _loc3_ + ": " + param1[_loc3_] + ", ";
         }
         trace(_loc2_);
      }
      
      public function sendKudosAcknowledgement(param1:PendingKudos, param2:Function) : void
      {
         var _loc3_:Object = {"commandName":ACKNOLWEDGE_KUDOS_COMMAND};
         if(Boolean(param1))
         {
            _loc3_["notificationsShown"] = param1.getKudosCountsArray();
         }
         this.invokeService(_loc3_,KudosServicePlatform.MESSAGE_CALL_METHOD_NAME,param2);
      }
      
      public function getTotals(param1:Number, param2:Function) : void
      {
         this.invokeService({
            "summonerId":param1,
            "commandName":TOTALS_COMMAND
         },KudosServicePlatform.REMOTE_CALL_METHOD_NAME,param2);
      }
      
      public function giveKudo(param1:Number, param2:Number, param3:Number, param4:Number) : void
      {
         this.invokeService({
            "giverId":param1,
            "receiverId":param2,
            "gameId":param3,
            "kudosType":param4,
            "commandName":GIVE_COMMAND
         },KudosServicePlatform.REMOTE_CALL_METHOD_NAME,this.onGiveKudoSuccess);
      }
      
      private function buildErrorThingy() : void
      {
         this.errorMap = new Dictionary();
         this.errorMap[ServerError.UNEXPECTED_SERVICE_EXCEPTION] = this.onFailure;
         this.errorMap[ClientErrorCodes.REQUEST_TIMEOUT] = this.onFailure;
         this.errorMap[ClientErrorCodes.MESSAGE_SEND] = this.onFailure;
         this.errorMap[ClientErrorCodes.CONNECT_FAILED] = this.onFailure;
      }
      
      private function onFailure(param1:ServerError) : void
      {
         trace("Platform Connection error Result type : " + getQualifiedClassName(param1) + " " + param1.errorCode + " : " + param1.faultEvent.fault.rootCause);
      }
      
      public function getPendingKudos(param1:Function) : void
      {
         this.invokeService({"commandName":PENDING_KUDOS_COMMAND},KudosServicePlatform.REMOTE_CALL_METHOD_NAME,param1);
      }
      
      public function onGiveKudoSuccess(param1:ResultEvent) : void
      {
         var _loc3_:Object = null;
         var _loc4_:AlertAction = null;
         var _loc2_:LcdsResponseString = param1.result as LcdsResponseString;
         if(Boolean(_loc2_) && Boolean(_loc2_.value))
         {
            _loc3_ = jsonDecode(_loc2_.value);
            if(_loc3_["returnCode"] == "JUST_RAN_OUT")
            {
               _loc4_ = new AlertAction(RiotResourceLoader.getString("kudosEndOfGameNoKudosAlertTitle"),RiotResourceLoader.getString("kudosEndOfGameNoKudosAlert"));
               _loc4_.add();
               dispatchEvent(new KudosEvent(KudosEvent.OUT_OF_KUDOS,NaN,NaN,NaN));
            }
         }
      }
      
      private function invokeService(param1:Object, param2:String, param3:Function) : void
      {
         var _loc4_:String = jsonEncode(param1);
         this.traceArgs(param1);
         var _loc5_:Array = [_loc4_];
         this.lcdsService.invokeServiceWithoutSession(KudosServicePlatform.SERVICE_NAME,param2,_loc5_,param3,null,this.errorMap);
      }
   }
}

