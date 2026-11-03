package com.riotgames.pvpnet.cap.observers.group
{
   import blix.IDestructible;
   import com.riotgames.pvpnet.cap.controllers.ICapController;
   import com.riotgames.pvpnet.cap.model.CapPlayerSelection;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.CapModelUtil;
   
   public class GroupUnreadyObserver extends BaseGroupObserver implements IDestructible
   {
      
      private var _capController:ICapController;
      
      public function GroupUnreadyObserver(param1:CapModel, param2:ICapController)
      {
         super(param1);
         this._capController = param2;
      }
      
      override protected function onPropertyChange(param1:CapPlayerSelection) : void
      {
         if(_signalHandlers.length == 0)
         {
            return;
         }
         var _loc2_:Boolean = this._capController.unreadyGroup();
         if(_loc2_ && param1.isPopulated)
         {
            this._capController.displayStatusMessage(CapLocaleUtil.getResourceString("gf_status_message_player_property_change_unready",param1.summonerName + " is not ready.",[param1.summonerName]));
         }
      }
      
      override public function setupSignals() : void
      {
         var _loc1_:CapPlayerSelection = null;
         var _loc2_:Array = null;
         for each(_loc1_ in CapModelUtil.getAllAvailablePlayerSelections(_model))
         {
            _loc2_ = [];
            _loc2_.push(_loc1_.isPopulatedChanged);
            _loc2_.push(_loc1_.championChanged);
            _loc2_.push(_loc1_.roleChanged);
            _loc2_.push(_loc1_.positionChanged);
            createSignalHandler(_loc1_,_loc2_);
         }
      }
   }
}

