package com.riotgames.pvpnet.cap.renderers.dropdown
{
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.RecommendedRoleResolver;
   
   public class CapRoleDropdownItemRenderer extends CapDropdownRenderer
   {
      
      private var _model:CapModel;
      
      private var _role:CapRole;
      
      private var _recommendedRoleResolver:RecommendedRoleResolver;
      
      private var _recommendedIndicator:StatefulView;
      
      public function CapRoleDropdownItemRenderer(param1:IContext, param2:String = "CapDropDownItemRenderer", param3:String = "name", param4:Class = null)
      {
         super(param1,param2,param3,param4);
         this._model.localPlayerSelection.championChanged.add(this.updateRecommendedIndicator);
      }
      
      override public function setCurrentState(param1:String) : void
      {
         super.setCurrentState(param1);
         this._recommendedIndicator.setCurrentState(getCurrentState());
      }
      
      override public function destroy() : void
      {
         this._model.localPlayerSelection.championChanged.remove(this.updateRecommendedIndicator);
         super.destroy();
      }
      
      override public function setData(param1:*) : void
      {
         if(this._role == param1)
         {
            return;
         }
         this._role = param1;
         this.updateRecommendedIndicator();
         super.setData(this._role);
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._recommendedRoleResolver = getDependency(RecommendedRoleResolver);
         this._model = getDependency(CapModel);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._recommendedIndicator = new StatefulView(this);
         this._recommendedIndicator.setVisible(false);
         setTimelineChildByName("recommendedIndicator",this._recommendedIndicator);
      }
      
      private function updateRecommendedIndicator() : void
      {
         var _loc1_:Champion = this._model.localPlayerSelection.champion;
         var _loc2_:uint = this._recommendedRoleResolver.getRecommendation(_loc1_,this._role);
         this._recommendedIndicator.setVisible(Boolean(_loc2_));
      }
   }
}

