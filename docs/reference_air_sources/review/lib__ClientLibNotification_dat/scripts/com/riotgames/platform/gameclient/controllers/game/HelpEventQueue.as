package com.riotgames.platform.gameclient.controllers.game
{
   import com.riotgames.platform.common.provider.ISoundProvider;
   import mx.resources.ResourceManager;
   
   public class HelpEventQueue extends EventQueue
   {
      
      private static const COLOR_HIGHLIGHT_TEXT:String = "#ff9900";
      
      private static const COLOR_ACTION_TEXT:String = "#0099ff";
      
      private var lastPlayedVoiceOverKey:String = "";
      
      public var glowComponentController:GlowComponentController;
      
      public var arrowedAlertController:ArrowedAlertController;
      
      private var soundManager:ISoundProvider;
      
      public function HelpEventQueue(param1:ArrowedAlertController, param2:GlowComponentController, param3:ISoundProvider)
      {
         this.arrowedAlertController = param1;
         this.glowComponentController = param2;
         this.soundManager = param3;
         super();
      }
      
      private function hideTipDialog() : void
      {
      }
      
      private function onConfirmationDialogConfirmed() : void
      {
         this.advanceState();
      }
      
      private function showDialog(param1:String, param2:Number, param3:Number, param4:String, param5:Boolean, param6:Boolean) : void
      {
         var _loc7_:String = ResourceManager.getInstance().getString("resources",param1,["</font>","<font color=\'" + COLOR_HIGHLIGHT_TEXT + "\'>","<font color=\'" + COLOR_ACTION_TEXT + "\'>"]);
         if(!_loc7_)
         {
            _loc7_ = param1;
         }
         var _loc8_:ArrowedAlertParameters = new ArrowedAlertParameters();
         _loc8_.button = param6;
         _loc8_.closeCallback = this.onConfirmationDialogConfirmed;
         _loc8_.message = _loc7_;
         _loc8_.style = param4;
         _loc8_.x = param2;
         _loc8_.y = param3;
         _loc8_.modalParent = param5;
         this.arrowedAlertController.showAlert(_loc8_);
      }
      
      public function showTipDialog(param1:String, param2:Number, param3:Number, param4:String, param5:Boolean = false) : void
      {
         this.showDialog(param1,param2,param3,param4,param5,false);
      }
      
      override protected function cleanUp() : void
      {
         super.cleanUp();
         this.turnOffAllGlows();
         this.hideTipDialog();
         this.hideConfirmationDialog();
      }
      
      public function turnOnComponentGlow(param1:String) : void
      {
         var _loc2_:GlowComponentParameters = new GlowComponentParameters();
         this.glowComponentController.startGlow(param1,_loc2_);
      }
      
      public function playVoiceOver(param1:String) : void
      {
         this.soundManager.stop(this.lastPlayedVoiceOverKey);
         this.soundManager.play(param1);
         this.lastPlayedVoiceOverKey = param1;
      }
      
      private function turnOffAllGlows() : void
      {
         if(Boolean(this.glowComponentController))
         {
            this.glowComponentController.stopGlow();
         }
      }
      
      public function showConfirmationDialog(param1:String, param2:Number, param3:Number, param4:String, param5:Boolean = false) : void
      {
         this.showDialog(param1,param2,param3,param4,param5,true);
      }
      
      private function hideConfirmationDialog() : void
      {
         if(Boolean(this.arrowedAlertController))
         {
            this.arrowedAlertController.hideAlert();
         }
      }
   }
}

