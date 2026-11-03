package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   
   public class CapQuitDeniedV1 extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "quitDeniedV1";
      
      private var _model:CapModel;
      
      public function CapQuitDeniedV1(param1:CapModel, param2:IDecode)
      {
         this._model = param1;
         super(METHOD_NAME,param2);
      }
      
      protected function displayCannotQuitAlert() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_dialog_cannot_quit_title","Sorry");
         var _loc2_:String = CapLocaleUtil.getResourceString("gf_dialog_cannot_quit_body","That action is not currently available because matchmaking is in progress.");
         var _loc3_:AlertAction = new AlertAction(_loc1_,_loc2_);
         _loc3_.add();
      }
      
      override protected function doInvocation() : void
      {
         super.doInvocation();
         this._model.localPlayerCausedDisband = false;
         this.displayCannotQuitAlert();
      }
   }
}

