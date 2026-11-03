package com.riotgames.platform.module.masteries.views.renderers.tooltips
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.Context;
   import com.riotgames.platform.masteries.objects.MasteryPage;
   import com.riotgames.platform.masteries.utilities.MasteriesUtils;
   import mx.events.PropertyChangeEvent;
   
   public class MasteryPageToolTip extends SpriteProxy implements IDataRenderer
   {
      
      private var titleText:TextFieldProxy;
      
      private var offenseText:TextFieldProxy;
      
      private var defenseText:TextFieldProxy;
      
      private var utilityText:TextFieldProxy;
      
      private var _model:MasteryPageToolTipModel;
      
      public function MasteryPageToolTip(param1:Context)
      {
         super(param1);
         setLinkage("MasteryPageTooltip");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.titleText = new TextFieldProxy(this);
         this.offenseText = new TextFieldProxy(this);
         this.defenseText = new TextFieldProxy(this);
         this.utilityText = new TextFieldProxy(this);
         this.setTimelineChildByName("pageNameDisplay",this.titleText);
         this.setTimelineChildByName("offensePointTotal",this.offenseText);
         this.setTimelineChildByName("defensePointTotal",this.defenseText);
         this.setTimelineChildByName("utilityPointTotal",this.utilityText);
      }
      
      public function setDataBasedOnPage(param1:MasteryPage, param2:int) : void
      {
         var _loc3_:MasteryPageToolTipModel = new MasteryPageToolTipModel(MasteriesUtils.getLocalizedPageName(param1.name,param2),MasteriesUtils.getSpentPointsInGroup(param1,1).toString(),MasteriesUtils.getSpentPointsInGroup(param1,2).toString(),MasteriesUtils.getSpentPointsInGroup(param1,3).toString());
         this.setData(_loc3_);
      }
      
      public function getData() : *
      {
         return this._model;
      }
      
      public function setData(param1:*) : void
      {
         if(param1 == null)
         {
            return;
         }
         if(!(param1 is MasteryPageToolTipModel))
         {
            throw new ArgumentError("data property must be of type MasteriesPageToolTipModel");
         }
         this._model = param1;
         this.updateDisplayFields();
      }
      
      private function updateDisplayFields() : void
      {
         this.titleText.setText(this._model.title);
         this.offenseText.setText(this._model.offenseValue);
         this.defenseText.setText(this._model.defenseValue);
         this.utilityText.setText(this._model.utilityValue);
      }
      
      private function onModelPropertyChanged(param1:PropertyChangeEvent) : void
      {
         this.updateDisplayFields();
      }
   }
}

