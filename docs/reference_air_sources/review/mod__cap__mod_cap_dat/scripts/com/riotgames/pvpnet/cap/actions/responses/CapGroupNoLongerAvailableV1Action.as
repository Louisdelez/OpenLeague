package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   
   public class CapGroupNoLongerAvailableV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "groupNoLongerAvailableV1";
      
      public function CapGroupNoLongerAvailableV1Action(param1:IDecode)
      {
         super(METHOD_NAME,param1);
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
      }
   }
}

