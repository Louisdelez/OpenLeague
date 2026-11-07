package com.riotgames.pvpnet.tracking.trackers.loyalty
{
   import com.riotgames.pvpnet.tracker.SessionTimeframedTracker;
   
   public class LoyaltyRewardsTracker extends SessionTimeframedTracker implements ILoyaltyRewardsTracker
   {
      
      public static const REWARDS:String = "rewards";
      
      public static const REWARDS__PREMIUM_TYPE:String = "premium_type";
      
      public static const REWARDS__IP_BOOST:String = "ip_boost";
      
      public static const REWARDS__XP_BOOST:String = "xp_boost";
      
      public static const REWARDS__CHAMPION:String = "champion_ids";
      
      public static const REWARDS__SKIN:String = "skin_ids";
      
      private var rewards:Object = new Object();
      
      private var championIds:Array = [];
      
      private var skinIds:Array = [];
      
      public function LoyaltyRewardsTracker(param1:Boolean = true)
      {
         super("loyalty_rewards",param1);
         this.rewards[REWARDS__CHAMPION] = this.championIds;
         this.rewards[REWARDS__SKIN] = this.skinIds;
         this.forceSend = true;
         start();
      }
      
      public function setIpBoost(param1:Number) : void
      {
         this.rewards[REWARDS__IP_BOOST] = param1;
         setProperty(REWARDS,this.rewards);
      }
      
      public function completeAndSend() : void
      {
         sessionClosed();
      }
      
      public function setXpBoost(param1:Number) : void
      {
         this.rewards[REWARDS__XP_BOOST] = param1;
         setProperty(REWARDS,this.rewards);
      }
      
      public function addChampion(param1:uint) : void
      {
         this.championIds.push(param1);
         this.rewards[REWARDS__CHAMPION] = this.championIds;
         setProperty(REWARDS,this.rewards);
      }
      
      public function addSkin(param1:uint) : void
      {
         this.skinIds.push(param1);
         this.rewards[REWARDS__SKIN] = this.skinIds;
         setProperty(REWARDS,this.rewards);
      }
      
      public function setPremiumType(param1:uint) : void
      {
         this.rewards[REWARDS__PREMIUM_TYPE] = param1;
         setProperty(REWARDS,this.rewards);
      }
   }
}

