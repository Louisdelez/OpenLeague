package com.riotgames.pvpnet.cap.actions.responses
{
   import com.riotgames.platform.common.services.lcdsproxy.responses.LcdsProxyMessageAction;
   import com.riotgames.platform.common.utils.decode.IDecode;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.system.alerter.AlertAction;
   
   public class CapGatekeeperRestrictedV1Action extends LcdsProxyMessageAction
   {
      
      public static const METHOD_NAME:String = "gatekeeperRestrictedV1";
      
      private var _model:CapModel;
      
      private var _controller:ICapController;
      
      public function CapGatekeeperRestrictedV1Action(param1:CapModel, param2:IDecode, param3:ICapController, param4:String = null)
      {
         this._model = param1;
         this._controller = param3;
         super(METHOD_NAME,param2,param4);
      }
      
      override protected function doDecode(param1:Object) : void
      {
         var _loc2_:Array = param1["gatekeeperRestrictions"];
         if(Boolean(_loc2_) && Boolean(_loc2_.length > 0) && Boolean(_loc2_[0].hasOwnProperty("reason")))
         {
            this.displayDisbandedAlert(String(_loc2_[0]["reason"]).toLowerCase());
         }
         this._controller.hasQuit();
      }
      
      private function displayDisbandedAlert(param1:String) : void
      {
         var _loc3_:String = null;
         var _loc2_:String = CapLocaleUtil.getResourceString("gf_dialog_gatekeeping_title","Error");
         _loc3_ = CapLocaleUtil.getResourceString("gf_dialog_gatekeeping_body_" + param1,"");
         if(_loc3_ == "**")
         {
            _loc3_ = CapLocaleUtil.getResourceString("gf_dialog_gatekeepingDefaultReason","Unable to join game");
         }
         var _loc4_:AlertAction = new AlertAction(_loc2_,_loc3_);
         _loc4_.add();
      }
   }
}

