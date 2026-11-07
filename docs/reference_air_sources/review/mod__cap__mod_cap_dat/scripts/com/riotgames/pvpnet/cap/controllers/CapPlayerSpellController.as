package com.riotgames.pvpnet.cap.controllers
{
   import blix.action.IAction;
   import com.riotgames.platform.gameclient.domain.Spell;
   import com.riotgames.pvpnet.cap.factory.ICapActionFactory;
   import com.riotgames.pvpnet.cap.model.IPlayerSpellModel;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapFlowUtil;
   
   public class CapPlayerSpellController extends PlayerSpellController
   {
      
      private var _capActionFactory:ICapActionFactory;
      
      private var _model:CapModel;
      
      public function CapPlayerSpellController(param1:IPlayerSpellModel, param2:ICapActionFactory, param3:CapModel)
      {
         this._capActionFactory = param2;
         this._model = param3;
         super(param1);
      }
      
      override protected function doSelectSpells(param1:Spell, param2:Spell) : void
      {
         var _loc5_:IAction = null;
         var _loc3_:Boolean = Boolean(param1) && Boolean(param2);
         var _loc4_:Boolean = CapFlowUtil.isInAGroup(this._model) && _loc3_;
         if(_loc4_)
         {
            _loc5_ = this._capActionFactory.getSelectSpellsAction(param1,param2);
            _loc5_.getErred().add(this.onSpellSelectError);
            _loc5_.invoke();
         }
         else
         {
            super.doSelectSpells(param1,param2);
         }
      }
      
      private function onSpellSelectError(param1:Object = null) : void
      {
         throw new Error("Unable to update spell");
      }
   }
}

