package com.riotgames.championDetail
{
   import blix.assets.proxy.DisplayAdapter;
   import blix.view.behaviors.ScalingTransformBehavior;
   import com.riotgames.championdetails.Main;
   import com.riotgames.platform.common.provider.IChampionDetailProvider;
   import com.riotgames.platform.common.utils.app.ApplicationUtil;
   import com.riotgames.platform.gameclient.domain.Champion;
   import flash.display.DisplayObject;
   import flash.events.KeyboardEvent;
   import flash.geom.Point;
   import flash.ui.Keyboard;
   import mx.core.UIComponent;
   import mx.managers.PopUpManager;
   
   public class ChampionDetailProvider implements IChampionDetailProvider
   {
      
      private const CDP_WIDTH:int = 1215;
      
      private const CDP_HEIGHT:int = 717;
      
      private var championDetailView:Main;
      
      private var container:UIComponent;
      
      public function ChampionDetailProvider()
      {
         super();
      }
      
      public function displayChampionDetailView(param1:String, param2:Champion, param3:int = 0, param4:Boolean = false) : void
      {
         var _loc9_:DisplayAdapter = null;
         if(!this.championDetailView)
         {
            this.championDetailView = new Main();
            this.championDetailView.getCloseRequested().add(this.close);
            this.championDetailView.setTransformBehavior(new ScalingTransformBehavior());
            this.container = new UIComponent();
            _loc9_ = new DisplayAdapter(this.container);
            _loc9_.addChild(this.championDetailView);
         }
         var _loc5_:DisplayObject = ApplicationUtil.application as DisplayObject;
         PopUpManager.addPopUp(this.container,_loc5_,true);
         var _loc6_:Point = this.championDetailView.setExplicitSize(this.CDP_WIDTH * _loc5_.scaleX,this.CDP_HEIGHT * _loc5_.scaleY);
         this.championDetailView.show(param2,param3,param1,param4);
         var _loc7_:int = Math.round((_loc5_.width - _loc6_.x) / 2);
         var _loc8_:int = Math.round((_loc5_.height - _loc6_.y) / 2);
         this.container.move(_loc7_,_loc8_);
         _loc5_.stage.addEventListener(KeyboardEvent.KEY_UP,this.cancelPopup);
      }
      
      private function cancelPopup(param1:KeyboardEvent) : void
      {
         if(param1.keyCode == Keyboard.ESCAPE)
         {
            this.close();
         }
      }
      
      public function close() : void
      {
         if(this.championDetailView != null && Boolean(this.championDetailView.getVisible()))
         {
            this.championDetailView.hide();
            PopUpManager.removePopUp(this.container);
         }
      }
   }
}

