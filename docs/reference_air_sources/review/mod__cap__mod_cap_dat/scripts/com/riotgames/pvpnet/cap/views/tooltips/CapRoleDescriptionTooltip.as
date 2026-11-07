package com.riotgames.pvpnet.cap.views.tooltips
{
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.platform.gameclient.domain.Champion;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.pvpnet.cap.util.RecommendedRoleResolver;
   
   public class CapRoleDescriptionTooltip extends CapSummaryTooltip implements IDataRenderer
   {
      
      private static const RECOMMENDED_SUBTEXT:String = CapLocaleUtil.getResourceString("gf_role_recommended_subtitle","RECOMMENDED");
      
      private var _model:CapModel;
      
      private var _role:CapRole;
      
      private var _recommendedRoleResolver:RecommendedRoleResolver;
      
      private var _recommended:Boolean = false;
      
      public function CapRoleDescriptionTooltip(param1:IContext)
      {
         super(param1);
         this._model.localPlayerSelection.championChanged.add(this.updateRecommended);
      }
      
      public function getData() : *
      {
         return this._role;
      }
      
      override public function destroy() : void
      {
         this._model.localPlayerSelection.championChanged.remove(this.updateRecommended);
         super.destroy();
      }
      
      private function handleChampionChanged() : void
      {
         this.updateRecommended();
         this.updateText();
      }
      
      private function setRole(param1:CapRole) : void
      {
         this._role = param1;
         this.updateRecommended();
         this.updateText();
      }
      
      private function getTitleSubText() : String
      {
         if(this._recommended)
         {
            return RECOMMENDED_SUBTEXT;
         }
         return "";
      }
      
      public function setData(param1:*) : void
      {
         this.setRole(param1);
      }
      
      private function getTitleText() : String
      {
         if(this._role)
         {
            return this._role.name;
         }
         return "";
      }
      
      private function updateRecommended() : void
      {
         var _loc1_:Champion = this._model.localPlayerSelection.champion;
         var _loc2_:uint = this._recommendedRoleResolver.getRecommendation(_loc1_,this._role);
         this._recommended = Boolean(_loc2_);
      }
      
      private function updateText() : void
      {
         titleText.setText(this.getTitleText());
         titleSubText.setText(this.getTitleSubText());
         descriptionText.setText(this.getDescriptionText());
      }
      
      override protected function initializeDependencies() : void
      {
         super.initializeDependencies();
         this._recommendedRoleResolver = getDependency(RecommendedRoleResolver);
         this._model = getDependency(CapModel);
      }
      
      private function getDescriptionText() : String
      {
         if(this._role)
         {
            return this._role.description;
         }
         return "";
      }
   }
}

