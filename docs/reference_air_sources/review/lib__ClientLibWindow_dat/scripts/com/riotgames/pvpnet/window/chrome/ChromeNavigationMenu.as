package com.riotgames.pvpnet.window.chrome
{
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.button.LabelButtonX;
   import blix.components.timeline.StatefulView;
   import blix.context.IContext;
   import blix.layout.LayoutContainerView;
   import blix.layout.algorithms.VerticalLayout;
   import com.riotgames.pvpnet.navigation.NavigationManager;
   import com.riotgames.pvpnet.system.product.NavigationMenuListItem;
   import com.riotgames.util.logging.getLogger;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.utils.clearTimeout;
   import flash.utils.setTimeout;
   
   public class ChromeNavigationMenu extends StatefulView
   {
      
      private static const SHOW_TIMEOUT_MS:int = 600;
      
      private static const HIDE_TIMEOUT_MS:int = 300;
      
      private var menuButton:ButtonX;
      
      private var globalMenuItems:Vector.<NavigationMenuListItem>;
      
      private var productMenuItems:Vector.<NavigationMenuListItem>;
      
      private var globalMenuItemContainer:LayoutContainerView;
      
      private var productMenuItemContainer:LayoutContainerView;
      
      private var productLabel:TextFieldProxy;
      
      private var over:Boolean = false;
      
      private var showTimeout:uint;
      
      private var hideTimeout:uint;
      
      private var shown:Boolean = false;
      
      private var rendererLinkage:String;
      
      public function ChromeNavigationMenu(param1:IContext, param2:ButtonX, param3:String, param4:Vector.<NavigationMenuListItem>, param5:Vector.<NavigationMenuListItem>)
      {
         this.menuButton = param2;
         this.rendererLinkage = param3;
         this.globalMenuItems = param4;
         this.productMenuItems = param5;
         super(param1);
         this.setupButtonListeners();
      }
      
      public function setProductLabel(param1:String) : void
      {
         this.productLabel.setText(param1);
      }
      
      override protected function createChildren() : void
      {
         var verticalLayout:VerticalLayout;
         var menuItem:NavigationMenuListItem = null;
         var menuItemRenderer:LabelButtonX = null;
         this.productLabel = new TextFieldProxy(this);
         setTimelineChildByName("productLabel",this.productLabel);
         verticalLayout = new VerticalLayout();
         verticalLayout.setGap(0);
         this.globalMenuItemContainer = new LayoutContainerView(this);
         setTimelineChildByName("globalMenuItemContainer",this.globalMenuItemContainer);
         this.globalMenuItemContainer.setLayoutAlgorithm(verticalLayout);
         this.productMenuItemContainer = new LayoutContainerView(this);
         setTimelineChildByName("productMenuItemContainer",this.productMenuItemContainer);
         this.productMenuItemContainer.setLayoutAlgorithm(verticalLayout);
         for each(menuItem in this.globalMenuItems)
         {
            menuItemRenderer = new ChromeNavigationItemRenderer(this,menuItem);
            menuItemRenderer.setLinkage(this.rendererLinkage);
            menuItemRenderer.addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               NavigationManager.navigate((param1.target as ChromeNavigationItemRenderer).menuItem.navigationPath);
            });
            this.globalMenuItemContainer.addElement(menuItemRenderer);
         }
         for each(menuItem in this.productMenuItems)
         {
            menuItemRenderer = new ChromeNavigationItemRenderer(this,menuItem);
            menuItemRenderer.setLinkage(this.rendererLinkage);
            menuItemRenderer.addEventListener(MouseEvent.CLICK,function(param1:Event):void
            {
               NavigationManager.navigate((param1.target as ChromeNavigationItemRenderer).menuItem.navigationPath);
            });
            this.productMenuItemContainer.addElement(menuItemRenderer);
         }
      }
      
      private function setupButtonListeners() : void
      {
         if(this.menuButton != null)
         {
            this.menuButton.addEventListener(MouseEvent.CLICK,this.menuButtonClicked);
            this.menuButton.addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            this.menuButton.addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
            addEventListener(MouseEvent.ROLL_OVER,this.overHandler);
            addEventListener(MouseEvent.ROLL_OUT,this.outHandler);
         }
         else
         {
            getLogger(this).error("Menu button was null, cannot initialize chrome navigation menu.");
         }
      }
      
      private function menuButtonClicked(param1:MouseEvent) : void
      {
         this.show();
      }
      
      private function overHandler(param1:MouseEvent) : void
      {
         this.clearTimers();
         if(!this.shown)
         {
            this.showTimeout = setTimeout(this.show,SHOW_TIMEOUT_MS);
         }
      }
      
      private function outHandler(param1:MouseEvent) : void
      {
         this.clearTimers();
         if(this.shown && !getMouseIsOver() && !this.menuButton.getMouseIsOver())
         {
            this.hideTimeout = setTimeout(this.hide,HIDE_TIMEOUT_MS);
         }
      }
      
      private function clearTimers() : void
      {
         if(!isNaN(this.hideTimeout))
         {
            clearTimeout(this.hideTimeout);
            this.hideTimeout = NaN;
         }
         if(!isNaN(this.showTimeout))
         {
            clearTimeout(this.showTimeout);
            this.showTimeout = NaN;
         }
      }
      
      private function show() : void
      {
         if(!this.shown)
         {
            this.shown = true;
            setCurrentState("show");
         }
      }
      
      private function hide() : void
      {
         if(this.shown)
         {
            this.shown = false;
            setCurrentState("hide");
         }
      }
   }
}

import blix.components.button.LabelButtonX;
import blix.context.IContext;
import com.riotgames.pvpnet.system.product.NavigationMenuListItem;

class ChromeNavigationItemRenderer extends LabelButtonX
{
   
   public var menuItem:NavigationMenuListItem;
   
   public function ChromeNavigationItemRenderer(param1:IContext, param2:NavigationMenuListItem)
   {
      super(param1);
      this.menuItem = param2;
      this.setText(param2.label);
   }
}
