package com.riotgames.pvpnet.cap.faults
{
   import com.riotgames.platform.common.services.lcdsproxy.servicecalls.ILcdsProxyServiceCall;
   import com.riotgames.pvpnet.cap.actions.ICapFaultHandler;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   
   public class CapFaults
   {
      
      public static const GROUP_NOT_FOUND:String = "GROUP_NOT_FOUND";
      
      public static const NOT_AUTHORIZED:String = "NOT_AUTHORIZED";
      
      public static const GROUP_FULL:String = "GROUP_FULL";
      
      public static const PLAYER_ALREADY_IN_GROUP:String = "PLAYER_ALREADY_IN_GROUP";
      
      public static const SOLO_SLOT_NOT_FOUND:String = "SOLO_SLOT_NOT_FOUND";
      
      public static const CANDIDATE_NOT_FOUND:String = "CANDIDATE_NOT_FOUND";
      
      public static const SOLO_NOT_ACCEPTED:String = "SOLO_NOT_ACCEPTED";
      
      public static const PLAYER_NOT_IN_GROUP:String = "PLAYER_NOT_IN_GROUP";
      
      public static const INVALID_SPELL_SELECTION:String = "INVALID_SPELL_SELECTION";
      
      public static const GROUP_NOT_FULL:String = "GROUP_NOT_FULL";
      
      public static const MIN_PREMADE_SIZE_NOT_REACHED:String = "MIN_PREMADE_SIZE_NOT_REACHED";
      
      public static const NOT_FULLY_SPECCED:String = "NOT_FULLY_SPECCED";
      
      public static const INVALID_STATE:String = "INVALID_STATE";
      
      public static const NO_NODE_FOR_GROUP_ID:String = "NO_NODE_FOR_GROUP_ID";
      
      public function CapFaults()
      {
         super();
         throw new Error("This is a static utility class.  Do not instantiate");
      }
      
      public static function displayErrorAlert(param1:Error) : void
      {
         var _loc2_:AlertAction = new AlertAction("Error",param1.message);
         _loc2_.add();
      }
      
      public static function handleActionFaulted(param1:ILcdsProxyServiceCall) : void
      {
         var _loc2_:AlertAction = null;
         if(param1 is ICapFaultHandler)
         {
            ICapFaultHandler(param1).handleFault(param1.fault);
         }
         else
         {
            _loc2_ = new AlertAction("Error",param1.fault.faultCode);
            _loc2_.add();
         }
      }
   }
}

