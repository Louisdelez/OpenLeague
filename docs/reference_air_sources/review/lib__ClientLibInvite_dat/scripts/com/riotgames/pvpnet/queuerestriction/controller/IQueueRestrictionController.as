package com.riotgames.pvpnet.queuerestriction.controller
{
   import org.igniterealtime.xiff.data.im.RosterItemVO;
   
   public interface IQueueRestrictionController
   {
      
      function checkIsEligibleQueuePartner(param1:RosterItemVO, param2:Function) : void;
   }
}

