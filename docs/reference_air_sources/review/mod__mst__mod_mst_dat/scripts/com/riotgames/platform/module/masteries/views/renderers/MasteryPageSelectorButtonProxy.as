package com.riotgames.platform.module.masteries.views.renderers
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.tooltip.ToolTipHandler;
   import blix.components.tooltip.assignToolTip;
   import blix.context.Context;
   import blix.context.IContext;
   import com.riotgames.platform.masteries.objects.MasteryPage;
   import com.riotgames.platform.masteries.utilities.MasteriesUtils;
   import com.riotgames.platform.module.masteries.views.renderers.tooltips.MasteryPageToolTip;
   import com.riotgames.platform.module.masteries.views.renderers.tooltips.MasteryPageToolTipModel;
   
   public class MasteryPageSelectorButtonProxy extends ButtonX
   {
      
      private var _labelField:TextFieldProxy;
      
      private var _page:MasteryPage;
      
      private var _index:int;
      
      private var pageToolTiphandler:ToolTipHandler;
      
      public function MasteryPageSelectorButtonProxy(param1:IContext)
      {
         super(param1);
         setLinkage("PageSelectionButton");
         this._labelField = new TextFieldProxy(this);
         this.setTimelineChildByName("pageLabelText",this._labelField);
      }
      
      public function set associatedPage(param1:MasteryPage) : void
      {
         this._page = param1;
         this.updateTooltip();
      }
      
      public function set pageIndex(param1:int) : void
      {
         this._index = param1;
         this._labelField.setText((param1 + 1).toString());
         this.updateTooltip();
      }
      
      public function get associatedPage() : MasteryPage
      {
         return this._page;
      }
      
      public function updateTooltip() : void
      {
         var _loc1_:MasteryPageToolTipModel = null;
         var _loc2_:MasteryPageToolTip = null;
         if(this._page != null)
         {
            _loc1_ = new MasteryPageToolTipModel(MasteriesUtils.getLocalizedPageName(this._page.name,this._index),MasteriesUtils.getSpentPointsInGroup(this._page,1).toString(),MasteriesUtils.getSpentPointsInGroup(this._page,2).toString(),MasteriesUtils.getSpentPointsInGroup(this._page,3).toString());
            if(this.pageToolTiphandler == null)
            {
               _loc2_ = new MasteryPageToolTip(this.getParentContext() as Context);
               this.pageToolTiphandler = new ToolTipHandler();
               this.pageToolTiphandler.setView(_loc2_);
               this.pageToolTiphandler.showDelay = 0;
            }
            assignToolTip(this,_loc1_,this.pageToolTiphandler);
         }
      }
   }
}

