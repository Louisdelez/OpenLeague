package com.riotgames.championdetails.lore
{
   import blix.assets.proxy.ContentScroller;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.scroll.ScrollModel;
   import blix.components.scroll.VScrollBarX;
   import blix.components.text.Text;
   import blix.context.Context;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import blix.layout.data.SizeLayoutData;
   import blix.layout.vo.HorizontalAlign;
   import blix.view.View;
   import com.greensock.TweenLite;
   import com.greensock.TweenMax;
   import com.greensock.easing.Sine;
   import com.riotgames.championdetails.IChampionDetailsContext;
   import com.riotgames.championdetails.IParallaxScreen;
   import com.riotgames.championdetails.ParallaxItem;
   import com.riotgames.championdetails.ScreenSize;
   import com.riotgames.championdetails.model.ChampionInfo;
   import flash.display.DisplayObject;
   import flash.display.Sprite;
   import flash.display.shaders.BlendModeColorDodge;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import flash.geom.Rectangle;
   import flash.text.TextFieldAutoSize;
   
   public class LoreScreen extends SpriteProxy implements IParallaxScreen
   {
      
      private var _parallaxDescriptors:Vector.<ParallaxItem> = new Vector.<ParallaxItem>();
      
      private var contentText:Text;
      
      private var quoteText:TextFieldProxy;
      
      private var quoteAuthorText:TextFieldProxy;
      
      private var loreSoftLight:SpriteProxy;
      
      private var gem:SpriteProxy;
      
      private var cdpContext:IChampionDetailsContext;
      
      private var _championInfo:ChampionInfo;
      
      private var textLayout:LayoutContainer;
      
      private var textMask:SpriteProxy;
      
      private var vScrollBar:VScrollBarX;
      
      private var scrollModel:ScrollModel;
      
      private var spacer:View;
      
      public function LoreScreen(param1:Context, param2:Sprite = null)
      {
         super(param1,param2);
         this.cdpContext = getFirstContext(IChampionDetailsContext);
         addEventListener(MouseEvent.MOUSE_WHEEL,this.mouseWheelHandler);
      }
      
      private function mouseWheelHandler(param1:MouseEvent) : void
      {
         this.scrollModel.setValue(this.scrollModel.getClampedValue() - param1.delta * 2);
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:ContentScroller = new ContentScroller();
         this.gem = _loc1_.gem.create(this);
         this.loreSoftLight = _loc1_.loreSoftLight.create(this);
         this.loreSoftLight.setAlpha(0);
         this.loreSoftLight.setVisible(false);
         this.loreSoftLight.setMouseChildren(false);
         this.loreSoftLight.setMouseEnabled(false);
         var _loc2_:BlendModeColorDodge = new BlendModeColorDodge();
         this.loreSoftLight.setBlendShader(_loc2_);
         this.quoteText = _loc1_.loreText.quoteText.create(this);
         this.quoteText.setVerticalScrollEnabled(false);
         this.quoteText.setAutoSize(TextFieldAutoSize.LEFT);
         this.quoteAuthorText = _loc1_.loreText.quoteAuthorText.create(this);
         this.quoteAuthorText.setAutoSize(TextFieldAutoSize.RIGHT);
         this.quoteAuthorText.setVerticalScrollEnabled(false);
         this.contentText = new Text(this);
         this.contentText.setAutoSize(TextFieldAutoSize.LEFT);
         this.contentText.setVerticalScrollEnabled(false);
         setTimelineChild(_loc1_.loreText.contentText,this.contentText);
         this.contentText.getVerticalScrollModel().setValue(50);
         this.textMask = _loc1_.loreText.textMask.create(this);
         this.vScrollBar = new VScrollBarX(this);
         this.scrollModel = new ScrollModel();
         this.scrollModel.getChanged().add(this.scrollModelChangedHandler);
         this.vScrollBar.setScrollModel(this.scrollModel);
         setTimelineChild(_loc1_.loreText.scrollBar,this.vScrollBar);
         this.textLayout = new LayoutContainer(this);
         this.textLayout.getLayoutInvalidated().add(invalidateLayout);
         var _loc3_:VerticalLayout = new VerticalLayout();
         this.textLayout.setLayoutAlgorithm(_loc3_);
         this.textLayout.addElement(this.quoteText);
         var _loc4_:SizeLayoutData = new SizeLayoutData();
         _loc4_.setHorizontalAlign(HorizontalAlign.RIGHT);
         this.textLayout.addElement(this.quoteAuthorText,_loc4_);
         this.spacer = new View(this);
         var _loc5_:SizeLayoutData = new SizeLayoutData();
         _loc5_.setHeight(6);
         this.textLayout.addElement(this.spacer,_loc5_);
         var _loc6_:SizeLayoutData = new SizeLayoutData();
         this.textLayout.addElement(this.contentText,_loc6_);
         this.addDepth(_loc1_.loreText.create(this),0.7);
      }
      
      private function scrollModelChangedHandler() : void
      {
         invalidateLayout();
      }
      
      private function addDepth(param1:DisplayObjectProxy, param2:Number) : void
      {
         var _loc3_:ParallaxItem = new ParallaxItem(param1);
         _loc3_.setDepth(param2);
         this._parallaxDescriptors[this._parallaxDescriptors.length] = _loc3_;
      }
      
      public function setChampionInfo(param1:ChampionInfo) : void
      {
         if(this._championInfo != null)
         {
            this.contentText.setText("");
            this.quoteAuthorText.setText("");
            this.quoteText.setText("");
            this.spacer.setIncludeInLayout(false);
         }
         this._championInfo = param1;
         if(this._championInfo != null)
         {
            this.contentText.setText(this._championInfo.description);
            this.scrollModel.setValue(0);
            if(this._championInfo.quoteAuthor)
            {
               this.quoteAuthorText.setText("- " + this._championInfo.quoteAuthor);
               this.quoteAuthorText.setIncludeInLayout(true);
            }
            else
            {
               this.quoteAuthorText.setText("");
               this.quoteAuthorText.setIncludeInLayout(false);
            }
            if(this._championInfo.quote)
            {
               this.quoteText.setText("\"" + this._championInfo.quote + "\"");
               this.quoteText.setIncludeInLayout(true);
               this.spacer.setIncludeInLayout(true);
            }
            else
            {
               this.quoteText.setText("");
               this.quoteText.setIncludeInLayout(false);
               this.spacer.setIncludeInLayout(false);
            }
         }
      }
      
      public function getParallaxPosition() : Point
      {
         return new Point(0,ScreenSize.HEIGHT * 2);
      }
      
      public function getParallaxDescriptors() : Vector.<ParallaxItem>
      {
         return this._parallaxDescriptors;
      }
      
      public function buildUp() : void
      {
         this.loreSoftLight.setVisible(true);
         var _loc1_:DisplayObject = this.gem.getAsset();
         if(_loc1_ == null)
         {
            return;
         }
         TweenMax.to(_loc1_,0.7 * this.useTransitions,{
            "colorMatrixFilter":{"saturation":1},
            "delay":0
         });
         TweenLite.to(this,0.7 * this.useTransitions,{
            "lightAlpha":1,
            "ease":Sine.easeIn,
            "delay":0.5 * this.useTransitions
         });
      }
      
      public function tearDown() : void
      {
         var _loc1_:DisplayObject = this.gem.getAsset();
         if(_loc1_ == null)
         {
            return;
         }
         TweenMax.to(_loc1_,0.7 * this.useTransitions,{"colorMatrixFilter":{"saturation":0}});
         TweenLite.to(this,0.7 * this.useTransitions,{
            "lightAlpha":0,
            "ease":Sine.easeOut
         });
      }
      
      public function get lightAlpha() : Number
      {
         return this.loreSoftLight.getAlpha();
      }
      
      public function set lightAlpha(param1:Number) : void
      {
         this.loreSoftLight.setAlpha(param1);
         if(param1 == 0)
         {
            this.loreSoftLight.setVisible(false);
         }
      }
      
      private function get useTransitions() : int
      {
         return this.cdpContext.getConfig().useTransitions ? 1 : 0;
      }
      
      override protected function updateLayout(param1:Number, param2:Number) : Rectangle
      {
         this.vScrollBar.setExplicitSize(NaN,this.textMask.getHeight());
         var _loc3_:Point = this.textLayout.setExplicitSize(NaN,NaN);
         this.textLayout.setExplicitPosition(this.textMask.getX(),this.textMask.getY() - this.scrollModel.getClampedValue());
         this.scrollModel.setMax(_loc3_.y - this.textMask.getHeight());
         return new Rectangle(0,0,ScreenSize.WIDTH,ScreenSize.HEIGHT);
      }
   }
}

