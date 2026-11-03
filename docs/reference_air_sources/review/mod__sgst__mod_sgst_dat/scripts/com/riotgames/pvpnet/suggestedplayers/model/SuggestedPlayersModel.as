package com.riotgames.pvpnet.suggestedplayers.model
{
   import flash.utils.Dictionary;
   
   public class SuggestedPlayersModel
   {
      
      public var maxNumVisibleSuggestedPlayers:int = 0;
      
      public var maxNumReplacements:int = 0;
      
      public var maxNumOnlineFriends:int = 0;
      
      public var maxNumVictoriousComrades:int = 0;
      
      public var maxNumHonoredPlayers:int = 0;
      
      public var maxNumPreviousPremades:int = 0;
      
      public var maxNumFriendsOfFriends:int = 0;
      
      public var previousPremadeNames:Vector.<String> = new Vector.<String>();
      
      public var victoriousComradeNames:Vector.<String> = new Vector.<String>();
      
      public var honoredNames:Vector.<String> = new Vector.<String>();
      
      public var friendsOfFriends:Vector.<FriendOfFriendEntry> = new Vector.<FriendOfFriendEntry>();
      
      public var declinedNamesDictionary:Dictionary = new Dictionary();
      
      public var reportedPlayerNames:Vector.<String> = new Vector.<String>();
      
      public function SuggestedPlayersModel()
      {
         super();
      }
   }
}

