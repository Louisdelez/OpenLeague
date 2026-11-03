package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   
   public class CapGameStartFailedV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "gameStartFailedV1";
      
      private var _controller:ICapController;
      
      private var _model:CapModel;
      
      public function CapGameStartFailedV1Action(param1:CapModel, param2:IDecode, param3:ICapController)
      {
         this._model = param1;
         this._controller = param3;
         super(METHOD_NAME,param2);
      }
      
      private function displayGameStartFailedAlert() : void
      {
         var _loc1_:String = CapLocaleUtil.getResourceString("gf_dialog_game_start_error_title","Game Start Error");
         var _loc2_:String = CapLocaleUtil.getResourceString("gf_dialog_game_start_error_body","Sorry, an error occurred when attempting to start your game. Please try again later.");
         var _loc3_:AlertAction = new AlertAction(_loc1_,_loc2_);
         _loc3_.add();
      }
      
      override protected function doInvocation() : void
      {
         this.displayGameStartFailedAlert();
         this._model.hasLaunchedGame = false;
         this._controller.hasQuit();
         super.doInvocation();
      }
   }
}

