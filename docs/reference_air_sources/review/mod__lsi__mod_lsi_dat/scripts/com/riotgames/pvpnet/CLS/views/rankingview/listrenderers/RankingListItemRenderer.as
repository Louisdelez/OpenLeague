package com.riotgames.pvpnet.CLS.views.rankingview.listrenderers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import com.riotgames.pvpnet.CLS.models.ListItemObjectModel;
   import com.riotgames.pvpnet.CLS.models.RankRowTitleModel;
   import flash.display.Sprite;
   import flash.geom.Rectangle;
   
   public class RankingListItemRenderer extends SpriteProxy implements IDataRenderer
   {
      
      private var normalItemRenderer:RankingListNormalItemRenderer;
      
      private var titleItemRenderer:RankingListTitleItemRenderer;
      
      private var _data:*;
      
      public function RankingListItemRenderer(param1:IContext)
      {
         super(param1,new Sprite());
         setExplicitSize(793,31);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.normalItemRenderer = new RankingListNormalItemRenderer(this,"RankingListNormalItemRenderer");
         this.titleItemRenderer = new RankingListTitleItemRenderer(this);
      }
      
      public function setData(param1:*) : void
      {
         this._data = param1;
         setMouseIsOver(false);
         this.removeAllChildren();
         if(param1 is ListItemObjectModel)
         {
            this.normalItemRenderer.setData(param1);
            addChild(this.normalItemRenderer);
         }
         else if(param1 is RankRowTitleModel)
         {
            this.titleItemRenderer.setData(param1);
            addChild(this.titleItemRenderer);
         }
      }
      
      public function getData() : *
      {
         return this._data;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         return new Rectangle(0,0,793,31);
      }
   }
}

