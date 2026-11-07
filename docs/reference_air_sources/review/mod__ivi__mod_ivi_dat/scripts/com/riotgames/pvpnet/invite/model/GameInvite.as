package com.riotgames.pvpnet.invite.model
{
   import com.riotgames.platform.gameclient.domain.gameinvite.InvitationPlayer;
   import com.riotgames.platform.gameclient.domain.gameinvite.Inviter;
   import mx.resources.ResourceManager;
   
   public class GameInvite
   {
      
      public var gameTypeId:int;
      
      public var teamName:String;
      
      private var inviter:Vector.<Inviter> = new Vector.<Inviter>();
      
      public var queueId:Number;
      
      public var gameDifficulty:String;
      
      public var gameType:String = "NORMAL_GAME";
      
      public var invitationId:String;
      
      public var mapId:int;
      
      public var commonFriendName:String;
      
      public var inviteType:String;
      
      public var teamId:String;
      
      public var gameId:int;
      
      public var owner:InvitationPlayer;
      
      public var gamePassword:String;
      
      public var gameMode:String = "";
      
      public var invitationState:String;
      
      public var groupId:String;
      
      public function GameInvite()
      {
         super();
      }
      
      public function addInviter(param1:Inviter) : Boolean
      {
         var _loc3_:Inviter = null;
         var _loc2_:Boolean = param1 != null;
         for each(_loc3_ in this.inviter)
         {
            if(_loc3_.summonerId == param1.summonerId)
            {
               _loc2_ = false;
               break;
            }
         }
         if(_loc2_ && Boolean(param1))
         {
            this.inviter.push(param1);
         }
         return _loc2_;
      }
      
      public function getFirstInviter() : InvitationPlayer
      {
         if(this.inviter.length > 0)
         {
            return this.inviter[0];
         }
         return this.owner;
      }
      
      public function getInviterName() : String
      {
         var _loc1_:String = null;
         var _loc2_:String = null;
         var _loc3_:int = 0;
         if(this.inviter.length == 0)
         {
            return this.owner.summonerName;
         }
         if(this.inviter.length == 1)
         {
            return this.inviter[0].summonerName;
         }
         if(this.inviter.length > 1)
         {
            _loc1_ = ResourceManager.getInstance().getString("resources","invite_lobby_closed_notification_multi_invite_separator");
            if(!_loc1_)
            {
               _loc1_ = " ";
            }
            _loc2_ = "";
            _loc3_ = 0;
            while(_loc3_ < this.inviter.length)
            {
               _loc2_ += this.inviter[_loc3_].summonerName;
               if(_loc3_ < this.inviter.length - 1)
               {
                  _loc2_ += _loc1_;
               }
               _loc3_++;
            }
         }
         return _loc2_;
      }
   }
}

