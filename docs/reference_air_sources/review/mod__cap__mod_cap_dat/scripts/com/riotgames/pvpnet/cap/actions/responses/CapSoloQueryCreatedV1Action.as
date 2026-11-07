package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   
   public class CapSoloQueryCreatedV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "soloQueryCreatedV1";
      
      private var _model:CapModel;
      
      public function CapSoloQueryCreatedV1Action(param1:CapModel, param2:IDecode)
      {
         this._model = param1;
         super(METHOD_NAME,param2);
      }
      
      override protected function doInvocation() : void
      {
         this._model.inSoloQuery = true;
         this._model.creatingSoloQuery = false;
         super.doInvocation();
      }
   }
}

