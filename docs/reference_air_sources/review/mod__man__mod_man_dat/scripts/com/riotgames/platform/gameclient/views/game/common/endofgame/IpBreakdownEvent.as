package com.riotgames.platform.gameclient.views.game.common.endofgame
{
   import flash.events.Event;
   
   public class IpBreakdownEvent extends Event
   {
      
      public static const IP_TYPE_BASE_WIN:String = "ipBaseWin";
      
      public static const IP_TYPE_BASE_LOST:String = "ipBaseLost";
      
      public static const IP_TYPE_FIRST_WIN_BONUS:String = "ipFirstWinBonus";
      
      public static const IP_TYPE_QUEUE_BONUS:String = "ipQueueBonus";
      
      public static const IP_TYPE_ODIN_BONUS:String = "ipOdinBonus";
      
      public static const IP_TYPE_BOOST:String = "ipBoost";
      
      public static const IP_TYPE_BOOST_DISABLED:String = "ipBoostDisabled";
      
      public static const IP_TYPE_ZERO_EARNED:String = "ipNotEarned";
      
      public static const IP_TYPE_NONE:String = "none";
      
      public static const IP_TYPE_BOOST_LOYALTY:String = "loyaltyBoostIpEarned";
      
      public static const IP_TYPE_BOOST_LOCATION:String = "locationBoostIpEarned";
      
      public var ipType:String;
      
      public function IpBreakdownEvent(param1:String, param2:String, param3:Boolean = false, param4:Boolean = false)
      {
         super(param1,param3,param4);
         this.ipType = param2;
      }
      
      override public function clone() : Event
      {
         return new IpBreakdownEvent(type,this.ipType,this.bubbles,this.cancelable);
      }
   }
}

