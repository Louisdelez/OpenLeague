package com.riotgames.platform.gameclient.controllers.game.utils
{
   import com.riotgames.platform.common.provider.IInventory;
   import com.riotgames.platform.gameclient.chat.ChatController;
   import com.riotgames.platform.gameclient.controllers.game.model.ChampionSelectionModel;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.GameParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerChampionSelectionDTO;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.platform.gameclient.domain.game.GameState;
   import org.igniterealtime.xiff.core.EscapedJID;
   import org.igniterealtime.xiff.core.UnescapedJID;
   import org.igniterealtime.xiff.core.XMPPSocketConnection;
   
   public class TradeUtils
   {
      
      public function TradeUtils()
      {
         super();
      }
      
      public static function allowedToTrade(param1:Champion, param2:Spell, param3:Spell, param4:PlayerParticipant, param5:Boolean) : Boolean
      {
         var _loc6_:Boolean = false;
         if(!param1)
         {
            return false;
         }
         _loc6_ = Boolean(param1.isAvailable(param5));
         if(Boolean(param2) && Boolean(param3))
         {
            _loc6_ = _loc6_ && param2.minLevel <= param4.summonerLevel && param3.minLevel <= param4.summonerLevel;
         }
         return _loc6_;
      }
      
      public static function areTradesAllowed(param1:ChampionSelectionModel) : Boolean
      {
         if(!param1.currentGame)
         {
            return false;
         }
         if(param1.championSelectionState != GameState.POST_CHAMPION_SELECTION)
         {
            return false;
         }
         if(!param1.gameTypeConfig)
         {
            return false;
         }
         return param1.gameTypeConfig.allowTrades;
      }
      
      public static function getJIDFromParticipant(param1:PlayerParticipant, param2:XMPPSocketConnection) : UnescapedJID
      {
         var _loc3_:String = param2.resource;
         var _loc4_:EscapedJID = new EscapedJID(ChatController.jidFromSummonerId(param1.summonerId) + "/" + _loc3_);
         return _loc4_.unescaped;
      }
      
      public static function canInitiateTradeWithPlayer(param1:GameParticipant, param2:GameParticipant, param3:Array, param4:GameDTO, param5:IInventory, param6:Boolean, param7:Boolean) : Boolean
      {
         if(!param4)
         {
            return false;
         }
         if(!param1)
         {
            return false;
         }
         if(param1.isMe)
         {
            return false;
         }
         if(!TradeUtils.isOnSameTeam(param1,param2,param4))
         {
            return false;
         }
         if(TradeUtils.rejectedTradePreviously(param1,param3))
         {
            return false;
         }
         var _loc8_:PlayerChampionSelectionDTO = param4.getSelectionForSummonerName(param2.summonerInternalName);
         if(!_loc8_)
         {
            return false;
         }
         _loc8_ = param4.getSelectionForSummonerName(param1.summonerInternalName);
         if(!_loc8_)
         {
            return false;
         }
         var _loc9_:Champion = param5.championIdMapping[_loc8_.championId];
         var _loc10_:Spell = null;
         var _loc11_:Spell = null;
         if(param7)
         {
            _loc10_ = param5.spellDictionary[_loc8_.spell1Id];
            _loc11_ = param5.spellDictionary[_loc8_.spell2Id];
         }
         return TradeUtils.allowedToTrade(_loc9_,_loc10_,_loc11_,param2 as PlayerParticipant,param6);
      }
      
      public static function rejectedTradePreviously(param1:GameParticipant, param2:Array) : Boolean
      {
         var _loc3_:String = null;
         for each(_loc3_ in param2)
         {
            if(param1.summonerInternalName == _loc3_)
            {
               return true;
            }
         }
         return false;
      }
      
      public static function isOnSameTeam(param1:GameParticipant, param2:GameParticipant, param3:GameDTO) : Boolean
      {
         var _loc4_:int = int(param3.getTeamForPlayer(param1.summonerName));
         var _loc5_:int = int(param3.getTeamForPlayer(param2.summonerName));
         return _loc4_ == _loc5_;
      }
   }
}

