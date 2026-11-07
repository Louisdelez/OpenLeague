package com.riotgames.pvpnet.suggestedplayers.actions
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.AsyncLcdsProxyServiceCall;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   
   public class GetFriendsOfFriendsAction extends AsyncLcdsProxyServiceCall
   {
      
      public static const SERVICE:String = "suggestedPlayers";
      
      public static const METHOD:String = "retrieveOnlineFriendsOfFriends";
      
      private var _jsonDecoder:IDecode;
      
      private var _queueId:int;
      
      public function GetFriendsOfFriendsAction(param1:ILcdsProxyServiceMessenger, param2:int, param3:IEncode, param4:IDecode)
      {
         this._jsonDecoder = param4;
         this._queueId = param2;
         super(param1,SERVICE,METHOD,param3);
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = {};
         param1.queueId = this._queueId;
         return param1;
      }
      
      override public function handleResponse(param1:String = null, param2:String = null) : void
      {
         var _loc3_:Object = this._jsonDecoder.decode(param1);
         _completed.dispatch(_loc3_);
         _erred.removeAll();
      }
      
      override public function handleError(param1:String = null) : void
      {
         super.handleError(param1);
         _completed.removeAll();
      }
   }
}

