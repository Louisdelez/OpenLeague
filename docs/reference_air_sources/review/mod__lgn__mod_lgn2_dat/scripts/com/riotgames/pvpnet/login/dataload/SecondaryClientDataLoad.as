package com.riotgames.pvpnet.login.dataload
{
   import blix.action.SequenceAction;
   import com.riotgames.pvpnet.system.dataload.ClientDataLoad;
   
   public class SecondaryClientDataLoad extends ClientDataLoad
   {
      
      public function SecondaryClientDataLoad()
      {
         super();
      }
      
      override protected function customizeBootSequence(param1:SequenceAction) : void
      {
      }
   }
}

