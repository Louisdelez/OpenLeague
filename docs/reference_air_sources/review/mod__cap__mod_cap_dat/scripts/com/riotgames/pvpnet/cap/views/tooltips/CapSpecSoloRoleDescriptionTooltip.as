package com.riotgames.pvpnet.cap.views.tooltips
{
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.pvpnet.cap.model.CapRole;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   
   public class CapSpecSoloRoleDescriptionTooltip extends CapSummaryTooltip implements IDataRenderer
   {
      
      private static const RECOMMENDED_SUBTEXT:String = CapLocaleUtil.getResourceString("gf_role_recommended_subtitle","RECOMMENDED");
      
      private var _role:CapRole;
      
      public function CapSpecSoloRoleDescriptionTooltip(param1:IContext)
      {
         super(param1);
      }
      
      public function getData() : *
      {
         return this._role;
      }
      
      private function handleChampionChanged() : void
      {
         this.updateText();
      }
      
      private function getTitleSubText() : String
      {
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
      
      private function getDescriptionText() : String
      {
         if(this._role)
         {
            return this._role.description;
         }
         return "";
      }
      
      private function updateText() : void
      {
         titleText.setText(this.getTitleText());
         titleSubText.setText(this.getTitleSubText());
         descriptionText.setText(this.getDescriptionText());
      }
      
      private function setRole(param1:CapRole) : void
      {
         this._role = param1;
         this.updateText();
      }
   }
}

