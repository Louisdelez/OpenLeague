package com.riotgames.platform.gameclient.chat.domain
{
   import com.riotgames.platform.gameclient.domain.SummonerSummary;
   import org.igniterealtime.xiff.core.UnescapedJID;
   
   public class BuddySubscriptionRequestData
   {
      
      private var _subscriptionRequestJID:UnescapedJID;
      
      private var _summonerSummary:SummonerSummary;
      
      public function BuddySubscriptionRequestData()
      {
         super();
      }
      
      public function set summonerSummary(param1:SummonerSummary) : void
      {
         this._summonerSummary = param1;
      }
      
      public function set subscriptionRequestJID(param1:UnescapedJID) : void
      {
         this._subscriptionRequestJID = param1;
      }
      
      public function get summonerSummary() : SummonerSummary
      {
         return this._summonerSummary;
      }
      
      public function get subscriptionRequestJID() : UnescapedJID
      {
         return this._subscriptionRequestJID;
      }
   }
}

