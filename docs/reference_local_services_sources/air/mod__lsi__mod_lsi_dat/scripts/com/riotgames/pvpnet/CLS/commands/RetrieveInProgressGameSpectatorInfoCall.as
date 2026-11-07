package com.riotgames.pvpnet.CLS.commands
{
   import com.riotgames.platform.common.provider.ISpectatorProvider;
   import com.riotgames.platform.common.services.lcdsproxy.ILcdsProxyServiceMessenger;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.platform.common.utils.encode.IEncode;
   import com.riotgames.platform.gameclient.domain.game.GameType;
   import com.riotgames.platform.provider.ProviderLookup;
   
   public class RetrieveInProgressGameSpectatorInfoCall extends SpectatorProxyServiceCall
   {
      
      private static const METHOD_NAME:String = "retrieveInProgressSpectatorGameInfo";
      
      private var _teamIdOrSummonerName:String = "";
      
      private var _deserializedObject:Object;
      
      public function RetrieveInProgressGameSpectatorInfoCall(param1:ILcdsProxyServiceMessenger, param2:IEncode, param3:IDecode, param4:String)
      {
         super(param1,METHOD_NAME,param2,param3);
         this._teamIdOrSummonerName = param4;
      }
      
      override public function getRequestPayload(param1:Object = null) : Object
      {
         param1 = super.getRequestPayload(param1);
         param1.teamOrSummonerId = this._teamIdOrSummonerName;
         return param1;
      }
      
      private function onSpectatorProvider(param1:ISpectatorProvider) : void
      {
         param1.spectateFeaturedGame(this._deserializedObject["gameKey"]["gameId"],this._deserializedObject["gameKey"]["platformId"],this._deserializedObject["spectatorEncryptionKey"],1,GameType.RANKED_GAME_SOLO);
      }
      
      override protected function doDecode(param1:Object) : void
      {
         this._deserializedObject = param1;
         ProviderLookup.getProvider(ISpectatorProvider,this.onSpectatorProvider);
      }
   }
}

