package com.riotgames.pvpnet.CLS.views.noleagues
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainer;
   import blix.layout.algorithms.VerticalLayout;
   import com.riotgames.pvpnet.CLS.managers.ILeagueSystemModuleNavigation;
   import com.riotgames.pvpnet.CLS.views.enums.QueueTypesEnum;
   import com.riotgames.pvpnet.CLS.views.leagueFAQView.ShowLeagueFAQPopupAction;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import flash.events.MouseEvent;
   import flash.text.TextFieldAutoSize;
   
   public class NoLeaguesView extends StatefulView
   {
      
      private var _leagueSystemModuleNavigation:ILeagueSystemModuleNavigation;
      
      private var _showLeagueFAQPopupAction:ShowLeagueFAQPopupAction;
      
      protected var verticalLayout:VerticalLayout;
      
      protected var verticalLayoutContainer:LayoutContainer;
      
      public function NoLeaguesView(param1:IContext, param2:ShowLeagueFAQPopupAction)
      {
         super(param1);
         this._showLeagueFAQPopupAction = param2;
         setLinkage("NoLeaguesScreen");
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         var _loc1_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("noLeaguesInfoTxt",_loc1_);
         this.verticalLayout = new VerticalLayout();
         this.verticalLayout.setGap(2);
         this.verticalLayoutContainer = new LayoutContainer();
         this.verticalLayoutContainer.setLayoutAlgorithm(this.verticalLayout);
         this.verticalLayoutContainer.getLayoutInvalidated().add(invalidateLayout);
         this.registerTextForLocalization(_loc1_);
         this.localizeMedalNames();
         this.createButtons();
         this._leagueSystemModuleNavigation = getDependency(ILeagueSystemModuleNavigation);
         this._leagueSystemModuleNavigation.getOnNoLeagueScreen().add(this.onToggleVisible);
      }
      
      private function createButtons() : void
      {
         var _loc1_:ButtonX = new ButtonX(this);
         setTimelineChildByName("moreAboutLeaguesSystemButton",_loc1_);
         _loc1_.addEventListener(MouseEvent.CLICK,this.onFAQClick);
         var _loc2_:TextFieldProxy = new TextFieldProxy(this);
         _loc1_.setTimelineChildByName("textField",_loc2_);
         var _loc3_:SpriteProxy = new SpriteProxy(this);
         setTimelineChildByName("noLeaguesScreen",_loc3_);
         var _loc4_:ButtonX = new ButtonX(this);
         _loc4_.addEventListener(MouseEvent.CLICK,this.onNoLeaguesButtonClick);
         setTimelineChildByName("noLeaguesButton",_loc4_);
         var _loc5_:TextFieldProxy = new TextFieldProxy(this);
         _loc4_.setTimelineChildByName("buttonText",_loc5_);
      }
      
      private function registerTextForLocalization(param1:SpriteProxy) : void
      {
         var _loc2_:AutoSizeTextFieldProxy = new AutoSizeTextFieldProxy(this);
         param1.setTimelineChildByName("titleTxt",_loc2_);
         this.verticalLayoutContainer.addElement(_loc2_);
         var _loc3_:TextFieldProxy = new TextFieldProxy(this);
         _loc3_.setAutoSize(TextFieldAutoSize.LEFT);
         param1.setTimelineChildByName("descBigTxt",_loc3_);
         this.verticalLayoutContainer.addElement(_loc3_);
         _loc3_.setMouseEnabled(false);
         _loc3_.setMouseWheelEnabled(false);
         var _loc4_:TextFieldProxy = new TextFieldProxy(this);
         _loc4_.setAutoSize(TextFieldAutoSize.LEFT);
         param1.setTimelineChildByName("descSmallTxt",_loc4_);
         this.verticalLayoutContainer.addElement(_loc4_);
         _loc4_.setMouseEnabled(false);
         _loc4_.setMouseWheelEnabled(false);
         var _loc5_:TextFieldProxy = new TextFieldProxy(this);
         param1.setTimelineChildByName("buttonTxt",_loc5_);
         var _loc6_:SpriteProxy = new SpriteProxy(this);
         param1.setTimelineChildByName("buttonTxt",_loc6_);
      }
      
      private function localizeMedalNames() : void
      {
         var _loc1_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("bronzeRankText",_loc1_);
         var _loc2_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("silverRankText",_loc2_);
         var _loc3_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("goldRankText",_loc3_);
         var _loc4_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("platinumRankText",_loc4_);
         var _loc5_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("diamondRankText",_loc5_);
         var _loc6_:TextFieldProxy = new TextFieldProxy(this);
         setTimelineChildByName("masterRankText",_loc6_);
      }
      
      private function onNoLeaguesButtonClick(param1:MouseEvent) : void
      {
         setVisible(false);
         this._leagueSystemModuleNavigation.dispatchOnChallengerTierSelectionSignal(QueueTypesEnum.QUEUE_TYPE_5V5);
      }
      
      private function onToggleVisible(param1:Boolean) : void
      {
         setVisible(param1);
      }
      
      private function onFAQClick(param1:MouseEvent) : void
      {
         this._showLeagueFAQPopupAction.add(this);
      }
   }
}

