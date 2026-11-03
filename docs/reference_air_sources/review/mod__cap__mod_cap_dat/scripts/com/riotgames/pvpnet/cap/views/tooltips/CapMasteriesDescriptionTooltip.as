package com.riotgames.pvpnet.cap.views.tooltips
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.components.text.Text;
   import blix.context.IContext;
   import com.riotgames.platform.masteries.objects.MasteryPageInfoSummary;
   
   public class CapMasteriesDescriptionTooltip extends SpriteProxy implements IDataRenderer
   {
      
      private var _masteryPage:MasteryPageInfoSummary;
      
      public var defenseText:TextFieldProxy;
      
      public var offenseText:TextFieldProxy;
      
      private var nameText:Text;
      
      public var utilityText:TextFieldProxy;
      
      public function CapMasteriesDescriptionTooltip(param1:IContext)
      {
         super(param1);
         setLinkage("MasteriesDescriptionTooltip");
      }
      
      public function getData() : *
      {
         return this._masteryPage;
      }
      
      public function setMasteryPage(param1:MasteryPageInfoSummary) : void
      {
         this._masteryPage = param1;
         this.updateChildren();
      }
      
      protected function updateChildren() : void
      {
         this.updateOffenseText();
         this.updateDefenseText();
         this.updateUtilityText();
         this.nameText.setText(this._masteryPage.pageName);
      }
      
      protected function updateDefenseText() : void
      {
         this.defenseText.setText(String(this._masteryPage.categoryPointsSpent[1]));
      }
      
      public function setData(param1:*) : void
      {
         this.setMasteryPage(param1);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.offenseText = new TextFieldProxy(this);
         setTimelineChildByName("offenseText",this.offenseText);
         this.defenseText = new TextFieldProxy(this);
         setTimelineChildByName("defenseText",this.defenseText);
         this.utilityText = new TextFieldProxy(this);
         setTimelineChildByName("utilityText",this.utilityText);
         this.nameText = new Text(this);
         setTimelineChildByName("nameText",this.nameText);
         this.nameText.setTruncateToFit(true);
      }
      
      protected function updateOffenseText() : void
      {
         this.offenseText.setText(String(this._masteryPage.categoryPointsSpent[0]));
      }
      
      protected function updateUtilityText() : void
      {
         this.utilityText.setText(String(this._masteryPage.categoryPointsSpent[2]));
      }
   }
}

