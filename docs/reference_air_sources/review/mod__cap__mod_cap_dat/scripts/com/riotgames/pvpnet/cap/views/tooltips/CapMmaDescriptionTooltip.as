package com.riotgames.pvpnet.cap.views.tooltips
{
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.pvpnet.cap.model.CapMmaBonus;
   import com.riotgames.pvpnet.cap.model.core.CapModel;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   
   public class CapMmaDescriptionTooltip extends CapSummaryTooltip implements IDataRenderer
   {
      
      private var _bonusActive:Boolean;
      
      private var _model:CapModel;
      
      private var _targetMmaBonus:CapMmaBonus;
      
      public function CapMmaDescriptionTooltip(param1:IContext)
      {
         super(param1);
      }
      
      private function setMmaBonus(param1:CapMmaBonus) : void
      {
         this._targetMmaBonus = param1;
         titleText.setText(this.getTitleText());
         titleSubText.setText(this.getTitleSubText());
         descriptionText.setText(this.getDescriptionText());
      }
      
      public function getData() : *
      {
         return this._targetMmaBonus;
      }
      
      private function getTitleSubText() : String
      {
         var _loc1_:Array = [];
         if(this._targetMmaBonus.championBonusActive)
         {
            _loc1_.push(CapLocaleUtil.getResourceString("gf_mma_tooltip_subtitle_champion_bonus_active","Champion: {0}",[this._model.localPlayerSelection.champion.displayName]));
         }
         if(this._targetMmaBonus.roleBonusActive)
         {
            _loc1_.push(CapLocaleUtil.getResourceString("gf_mma_tooltip_subtitle_role_bonus_active","Role: {0}",[this._model.localPlayerSelection.role.name]));
         }
         return _loc1_.join("\n");
      }
      
      private function getTitleText() : String
      {
         return this._targetMmaBonus.hasBonus() ? CapLocaleUtil.getResourceString("gf_mma_tooltip_title_bonus_active","Matchmaking adjustment: Active") : CapLocaleUtil.getResourceString("gf_mma_tooltip_title_bonus_inactive","Matchmaking adjustment: Inactive");
      }
      
      override protected function initializeDependencies() : void
      {
         this._model = getDependency(CapModel);
         super.initializeDependencies();
      }
      
      private function getDescriptionText() : String
      {
         return this._targetMmaBonus.hasBonus() ? CapLocaleUtil.getResourceString("gf_mma_tooltip_description_bonus_active","When you try a new role or champion, Team Builder adjusts matchmaking automatically. These adjustments decrease as you gain experience.") : CapLocaleUtil.getResourceString("gf_mma_tooltip_description_bonus_inactive","When you try a new role or champion, Team Builder adjusts matchmaking automatically. These adjustments decrease as you gain experience.");
      }
      
      public function setData(param1:*) : void
      {
         this.setMmaBonus(param1);
      }
   }
}

