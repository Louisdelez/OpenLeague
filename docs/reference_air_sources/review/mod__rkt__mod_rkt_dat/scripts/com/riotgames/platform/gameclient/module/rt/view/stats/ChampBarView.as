package com.riotgames.platform.gameclient.module.rt.view.stats
{
   import blix.assets.proxy.AnimatedChampBar;
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.context.Context;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import com.greensock.data.TweenLiteVars;
   import com.greensock.easing.Quad;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.pvpnet.rankedteams.stats.TeamQueuePlayerChampStats;
   import com.riotgames.rust.context.RustContext;
   import flash.display.Bitmap;
   import flash.events.MouseEvent;
   
   public class ChampBarView extends SpriteProxy
   {
      
      private static const MINIMUM_FINAL_HEIGHT:int = 115;
      
      private var iconHolder:SpriteProxy;
      
      private var champMask:SpriteProxy;
      
      public var index:int = -1;
      
      public var champStats:TeamQueuePlayerChampStats;
      
      public var champAchievementDetail:String;
      
      public var selected:Signal = new Signal();
      
      public var champAchievement:String;
      
      private var iconProxy:DisplayObjectProxy;
      
      private var champNameText:TextFieldProxy;
      
      private var champContent:ButtonX;
      
      public function ChampBarView(param1:Context)
      {
         super(param1,null);
      }
      
      private function onGotIcon(param1:Bitmap) : void
      {
         if(this.iconProxy)
         {
            this.iconHolder.removeChild(this.iconProxy);
         }
         param1.width = this.iconHolder.getWidth();
         param1.height = this.iconHolder.getHeight();
         this.iconProxy = new DisplayObjectProxy(this,param1);
         this.iconHolder.addChild(this.iconProxy);
      }
      
      public function setChampData(param1:TeamQueuePlayerChampStats, param2:String, param3:String, param4:String) : void
      {
         this.champStats = param1;
         this.champAchievement = param3;
         this.champAchievementDetail = param4;
         this.champNameText.setText(param2);
         if(param1)
         {
            RTFacade.instance.rtProvider.getChampIcon(param1.champId,this.onGotIcon);
         }
      }
      
      private function onClicked(param1:MouseEvent) : void
      {
         this.selected.dispatch(this);
      }
      
      override protected function createChildren() : void
      {
         var _loc1_:AnimatedChampBar = new AnimatedChampBar();
         var _loc2_:RustContext = getFirstContext(RustContext);
         this.champContent = _loc2_.viewUtil.wireButton(this,_loc1_.champContent,null);
         this.champMask = _loc1_.champMask.create(this);
         this.champNameText = _loc1_.champContent.championNameText.create(this);
         this.iconHolder = _loc1_.champContent.iconHolder.create(this);
         this.addEventListener(MouseEvent.CLICK,this.onClicked);
      }
      
      public function setSelected(param1:Boolean) : void
      {
         this.champContent.setSelected(param1);
      }
      
      public function animate(param1:Number, param2:int, param3:int) : void
      {
         var _loc4_:Number = NaN;
         var _loc5_:Number = NaN;
         var _loc6_:TweenLiteVars = null;
         this.resetAnimation();
         if(param1 > 0)
         {
            _loc4_ = this.champMask.getHeight() - MINIMUM_FINAL_HEIGHT;
            _loc5_ = (1 - param1) * _loc4_;
            _loc6_ = new TweenLiteVars();
            _loc6_.delay(param2 * 0.001);
            _loc6_.ease(Quad.easeInOut);
            _loc6_.prop("y",_loc5_);
            TweenLite.to(this.champContent.getSetterProxy(),param3 * 0.001,_loc6_);
         }
      }
      
      private function resetAnimation() : void
      {
         TweenLite.killTweensOf(this.champContent);
         this.champContent.setY(this.champMask.getHeight());
      }
   }
}

