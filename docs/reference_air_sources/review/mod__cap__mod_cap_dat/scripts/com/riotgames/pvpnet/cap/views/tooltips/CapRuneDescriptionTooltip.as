package com.riotgames.pvpnet.cap.views.tooltips
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.list.DataGroup;
   import blix.components.list.RendererFactory;
   import blix.components.renderer.IDataRenderer;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.platform.gameclient.domain.SpellBookPageDTO;
   import com.riotgames.pvpnet.cap.renderers.CapRuneTooltipAttributeRenderer;
   import com.riotgames.pvpnet.cap.util.CapLocaleUtil;
   import com.riotgames.rust.data.ListAdapter;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import mx.collections.ArrayCollection;
   
   public class CapRuneDescriptionTooltip extends SpriteProxy implements IDataRenderer
   {
      
      private var rendererFactory:RendererFactory;
      
      private var _runePage:SpellBookPageDTO;
      
      private var arrow:SpriteProxy;
      
      private var attributeList:DataGroup;
      
      private var _emptyText:TextFieldProxy;
      
      private var stats:ArrayCollection = new ArrayCollection();
      
      private var titleText:TextFieldProxy;
      
      private var background:SpriteProxy;
      
      private var infoContainer:LayoutContainerView;
      
      public function CapRuneDescriptionTooltip(param1:IContext)
      {
         super(param1);
         setLinkage("RuneDescriptionTooltip");
      }
      
      override public function destroy() : void
      {
         if(this.rendererFactory)
         {
            this.rendererFactory.destroy();
            this.rendererFactory = null;
         }
         super.destroy();
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         var _loc3_:Point = this.infoContainer.setExplicitSize(NaN,NaN);
         this.background.setHeight(Math.max(_loc3_.y + 12,85));
         this.arrow.setExplicitPosition(NaN,this.background.getY() + this.background.getHeight() / 2 - this.arrow.getHeight() / 2);
         return new Rectangle(0,0,this.background.getX() + this.background.getWidth(),this.background.getY() + this.background.getHeight());
      }
      
      public function getData() : *
      {
         return this._runePage;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this.infoContainer = new LayoutContainerView(this);
         this.infoContainer.setLayoutAlgorithm(new VerticalLayout());
         setTimelineChildByName("infoContainer",this.infoContainer);
         this.titleText = new TextFieldProxy(this);
         this.infoContainer.setTimelineChildByName("nameText",this.titleText);
         this.infoContainer.addElement(this.titleText);
         var _loc1_:ListAdapter = new ListAdapter(this.stats);
         this.rendererFactory = new RendererFactory(CapRuneTooltipAttributeRenderer,[this]);
         this.attributeList = new DataGroup(this,_loc1_,this.rendererFactory);
         this.infoContainer.setTimelineChildByName("list",this.attributeList);
         this.infoContainer.addElement(this.attributeList);
         this.background = new SpriteProxy(this);
         this.background.setTransformBehavior(new ScalingTransformBehavior());
         setTimelineChildByName("background",this.background);
         this._emptyText = new TextFieldProxy(this);
         setTimelineChildByName("emptyText",this._emptyText);
         this._emptyText.setVisible(false);
         this._emptyText.setText(CapLocaleUtil.getResourceString("gf_runes_empty","This rune page is empty"));
         this.arrow = new SpriteProxy(this);
         setTimelineChildByName("arrow",this.arrow);
      }
      
      protected function updateTitleText() : void
      {
         this.titleText.setText(this._runePage.name);
      }
      
      protected function updateChildren() : void
      {
         this.updateTitleText();
      }
      
      private function setRunePage(param1:SpellBookPageDTO) : void
      {
         this._runePage = param1;
         this.updateData();
         this.updateChildren();
      }
      
      protected function updateData() : void
      {
         if(this._runePage)
         {
            this.stats.source = this._runePage.getCombinedStats().source;
            this._emptyText.setVisible(!this.stats.length > 0);
            this.attributeList.setVisible(this.stats.length > 0);
         }
      }
      
      public function setData(param1:*) : void
      {
         this.setRunePage(param1);
      }
   }
}

