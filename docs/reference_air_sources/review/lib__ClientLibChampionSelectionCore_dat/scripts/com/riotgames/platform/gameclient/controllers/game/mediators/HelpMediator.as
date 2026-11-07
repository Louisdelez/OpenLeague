package com.riotgames.platform.gameclient.controllers.game.mediators
{
   import com.riotgames.platform.common.provider.ISoundProvider;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertController;
   import com.riotgames.platform.gameclient.controllers.game.ArrowedAlertParameters;
   import com.riotgames.platform.gameclient.controllers.game.EventQueue;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentController;
   import com.riotgames.platform.gameclient.controllers.game.GlowComponentParameters;
   import flash.events.Event;
   import flash.events.EventDispatcher;
   import mx.resources.ResourceManager;
   
   public class HelpMediator extends EventDispatcher
   {
      
      public static const COLOR_HIGHLIGHT_TEXT:String = "#ff9900";
      
      public static const COLOR_ACTION_TEXT:String = "#0099ff";
      
      private var lastPlayedVoiceOverKey:String = "";
      
      private var arrowedAlertController:ArrowedAlertController;
      
      private var eventQueue:EventQueue;
      
      private var soundManager:ISoundProvider;
      
      private var glowComponentController:GlowComponentController;
      
      public function HelpMediator(param1:EventQueue, param2:ISoundProvider, param3:ArrowedAlertController, param4:GlowComponentController)
      {
         super();
         this.eventQueue = param1;
         this.soundManager = param2;
         this.arrowedAlertController = param3;
         this.glowComponentController = param4;
         param1.addEventListener(EventQueue.EVENT_NEW_STATE_ENTERED,this.onNewState,false,0,true);
      }
      
      public function showTipDialog(param1:String, param2:Number, param3:Number, param4:String, param5:Boolean = false) : void
      {
         this.showDialog(param1,param2,param3,param4,param5,false);
      }
      
      public function pushNewState(param1:Function, param2:Function) : void
      {
         this.eventQueue.pushNewState(param1,param2);
      }
      
      public function clear() : void
      {
         this.eventQueue.clear();
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
      
      private function onNewState(param1:Event) : void
      {
         dispatchEvent(new Event(EventQueue.EVENT_NEW_STATE_ENTERED));
      }
      
      public function skipToEnd() : void
      {
         this.eventQueue.skipToEnd();
      }
      
      private function onConfirmationDialogConfirmed() : void
      {
         this.eventQueue.advanceState();
      }
      
      public function cleanup() : void
      {
         this.clear();
         this.eventQueue.removeEventListener(EventQueue.EVENT_NEW_STATE_ENTERED,this.onNewState);
         this.turnOffAllGlows();
         this.hideTipDialog();
         this.hideConfirmationDialog();
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
      
      private function hideTipDialog() : void
      {
      }
      
      public function advanceState() : void
      {
         this.eventQueue.advanceState();
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

