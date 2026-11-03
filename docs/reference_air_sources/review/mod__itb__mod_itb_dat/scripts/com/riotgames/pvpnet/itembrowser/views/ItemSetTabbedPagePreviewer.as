package com.riotgames.pvpnet.itembrowser.views
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSet;
   import com.riotgames.pvpnet.itembrowser.sets.model.ItemSetsModel;
   import flash.display.MovieClip;
   
   public class ItemSetTabbedPagePreviewer extends StatefulView
   {
      
      private static const STATE_PAGE_BUILD:String = "pageBuild";
      
      private static const STATE_NO_ITEM_SETS:String = "noItemSet";
      
      private var _model:ItemSetsModel;
      
      private var _currentItemSet:ItemSet;
      
      private var _pageTitle:TextFieldProxy;
      
      private var _pageBuildView:ItemSetPageBuildPreview;
      
      public function ItemSetTabbedPagePreviewer(param1:IContext, param2:MovieClip = null)
      {
         super(param1,param2);
      }
      
      public function setModel(param1:ItemSetsModel) : void
      {
         this._model = param1;
         this._pageBuildView.setModel(this._model);
      }
      
      override protected function createChildren() : void
      {
         setCurrentState(STATE_NO_ITEM_SETS);
         this._pageBuildView = new ItemSetPageBuildPreview(this);
         setTimelineChildByName("pageBuildView",this._pageBuildView);
         this._pageTitle = new TextFieldProxy(this);
         setTimelineChildByName("pageTitle",this._pageTitle);
         super.createChildren();
      }
      
      public function setItemSet(param1:ItemSet) : void
      {
         this._currentItemSet = param1;
         this._pageBuildView.setCurrentItemSet(param1);
         if(this._currentItemSet)
         {
            this._pageTitle.setText(this._currentItemSet.title);
            setCurrentState(STATE_PAGE_BUILD);
         }
         else
         {
            setCurrentState(STATE_NO_ITEM_SETS);
            this._pageTitle.setText("");
         }
      }
   }
}

