package com.riotgames.platform.gameclient.controllers.game.commands
{
   import com.riotgames.platform.common.commands.CommandBase;
   import com.riotgames.platform.common.utils.RiotResourceLoader;
   import com.riotgames.platform.gameclient.domain.BotParticipant;
   import com.riotgames.platform.gameclient.domain.GameDTO;
   import com.riotgames.platform.gameclient.domain.IParticipant;
   import com.riotgames.platform.gameclient.domain.ObfuscatedParticipant;
   import com.riotgames.platform.gameclient.domain.PlayerParticipant;
   import flash.utils.getQualifiedClassName;
   import mx.collections.ArrayCollection;
   import mx.resources.ResourceManager;
   
   public class UpdatePlayerRosterCommand extends CommandBase
   {
      
      private var gameOwnerAccountId:Number;
      
      private var accountId:Number;
      
      private var playerRoster:Array;
      
      private var game:GameDTO;
      
      public function UpdatePlayerRosterCommand(param1:GameDTO, param2:Array, param3:Number, param4:Number)
      {
         super();
         this.game = param1;
         this.playerRoster = param2;
         this.accountId = param3;
         this.gameOwnerAccountId = param4;
      }
      
      private function getSummonerName(param1:ArrayCollection, param2:int) : String
      {
         var _loc5_:ObfuscatedParticipant = null;
         var _loc3_:String = "";
         var _loc4_:int = 0;
         while(_loc4_ < param1.length)
         {
            _loc5_ = param1[_loc4_];
            if(_loc5_.gameUniqueId == param2)
            {
               _loc3_ = RiotResourceLoader.getString("championSelection_player_summoner_anonymous","championSelection_player_summoner_anonymous",[_loc4_ + 1]);
               break;
            }
            _loc4_++;
         }
         return _loc3_;
      }
      
      private function updatePlayerRosterForTeam(param1:ArrayCollection) : Boolean
      {
         var _loc5_:IParticipant = null;
         var _loc6_:String = null;
         var _loc7_:PlayerParticipant = null;
         var _loc8_:PlayerParticipant = null;
         var _loc9_:ObfuscatedParticipant = null;
         var _loc10_:int = 0;
         var _loc2_:Boolean = false;
         var _loc3_:Array = new Array();
         var _loc4_:Array = new Array();
         for each(_loc5_ in param1)
         {
            if(_loc5_ is BotParticipant)
            {
               _loc4_.push(_loc5_);
            }
            else
            {
               _loc6_ = "1";
               if(_loc5_ is PlayerParticipant)
               {
                  _loc8_ = PlayerParticipant(_loc5_);
                  _loc6_ = _loc8_.accountId.toString();
                  _loc7_ = this.playerRoster[_loc6_] as PlayerParticipant;
               }
               else
               {
                  if(!(_loc5_ is ObfuscatedParticipant))
                  {
                     onError("updatePlayerRosterAndChampionSelections(): Handled game participant of unknown type " + getQualifiedClassName(_loc5_));
                     continue;
                  }
                  _loc7_ = new PlayerParticipant();
                  _loc7_.pickMode = _loc5_.getPickMode();
                  _loc9_ = _loc5_ as ObfuscatedParticipant;
                  _loc7_.accountId = _loc9_.gameUniqueId;
                  _loc7_.clientInSynch = _loc9_.clientInSynch;
                  _loc7_.summonerInternalName = ResourceManager.getInstance().getString("resources","championSelection_player_summoner_anonymous",[_loc9_.gameUniqueId]);
                  _loc7_.summonerName = this.getSummonerName(param1,_loc9_.gameUniqueId);
                  _loc7_.badges = _loc9_.badges;
                  _loc6_ = _loc9_.gameUniqueId.toString();
               }
               if(_loc7_ == null)
               {
                  this.playerRoster[_loc6_] = _loc5_;
                  _loc7_ = PlayerParticipant(_loc5_);
               }
               else if(_loc5_ is PlayerParticipant && !_loc7_.equals(_loc5_ as PlayerParticipant))
               {
                  this.playerRoster[_loc6_] = _loc5_;
                  _loc7_ = PlayerParticipant(_loc5_);
               }
               if(_loc7_.summonerName == "")
               {
                  _loc10_ = param1.getItemIndex(_loc5_) + 1;
                  _loc7_.summonerName = ResourceManager.getInstance().getString("resources","championSelection_player_summoner_anonymous",[_loc10_]);
               }
               _loc7_.isGameOwner = this.gameOwnerAccountId == _loc7_.accountId;
               _loc7_.isMe = this.accountId == _loc7_.accountId;
               _loc3_.push(_loc7_);
               if(_loc7_.isMe)
               {
                  _loc2_ = true;
               }
            }
         }
         param1.source = _loc3_.concat(_loc4_);
         param1.refresh();
         return _loc2_;
      }
      
      override public function execute() : void
      {
         super.execute();
         var _loc1_:int = this.updatePlayerRoster(this.game);
         onComplete();
         onResult(_loc1_);
      }
      
      private function updatePlayerRoster(param1:GameDTO) : int
      {
         var _loc2_:int = -1;
         var _loc3_:Boolean = this.updatePlayerRosterForTeam(param1.teamOne);
         if(_loc3_)
         {
            _loc2_ = 1;
            _loc3_ = false;
         }
         _loc3_ = this.updatePlayerRosterForTeam(param1.teamTwo);
         if(_loc3_)
         {
            _loc2_ = 2;
         }
         return _loc2_;
      }
   }
}

