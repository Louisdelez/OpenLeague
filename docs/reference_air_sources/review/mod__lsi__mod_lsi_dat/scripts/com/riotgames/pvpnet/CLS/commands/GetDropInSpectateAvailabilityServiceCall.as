package com.riotgames.pvpnet.CLS.commands
{
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   
   public class GetDropInSpectateAvailabilityServiceCall extends SpectatorProxyServiceCall
   {
      
      private static const METHOD_NAME:String = "getDropInSpectateAvailability";
      
      private var _teamOrSummonerIds:Vector.<String>;
      
      private var _availableForWatching:Array;
      
      public function GetDropInSpectateAvailabilityServiceCall(param1:ILcdsProxyServiceMessenger, param2:IEncode, param3:IDecode, param4:Vector.<String>)
      {
         super(param1,METHOD_NAME,param2,param3);
         this._teamOrSummonerIds = param4;
      }
      
      public function get availableForWatching() : Array
      {
         return this._availableForWatching;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1.teamOrSummonerIds = this._teamOrSummonerIds;
         return param1;
      }
      
      override protected function doDecode(param1:Object) : void
      {
         if(param1.hasOwnProperty("availableForWatching"))
         {
            this._availableForWatching = param1["availableForWatching"];
         }
      }
   }
}

