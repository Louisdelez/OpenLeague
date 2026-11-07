package com.riotgames.platform.gameclient.module.rt.view.tab
{
   import blix.assets.proxy.DisplayObjectProxy;
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.assets.proxy.topTab.RankedTeamsTab;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.signals.Signal;
   import com.riotgames.platform.gameclient.domain.rankedTeams.TeamInfo;
   import com.riotgames.platform.gameclient.module.rt.RTFacade;
   import com.riotgames.platform.gameclient.module.rt.resource.RTContext;
   import com.riotgames.rust.components.FlashFlexComponent;
   import flash.display.DisplayObject;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   import mx.controls.List;
   import mx.core.ClassFactory;
   import mx.events.ListEvent;
   import mx.managers.PopUpManager;
   
   public class ProfileTab extends FlashFlexComponent
   {
      
      public var dropDownIndicatorButton:ButtonX;
      
      private var tabSelected:Boolean = false;
      
      public var dropdown:List;
      
      public var teamSelected:Signal;
      
      public var dropdownPosition:DisplayObjectProxy;
      
      public var tabText:TextFieldProxy;
      
      public var isDropdownShowing:Boolean = false;
      
      public var alertIcon:StatefulView;
      
      public var tabStates:StatefulView;
      
      private var buttonState:String = "Up";
      
      public function ProfileTab(param1:RTContext)
      {
         super(param1,"rt.RankedTeamsTab");
         this.teamSelected = new Signal();
         var _loc2_:RankedTeamsTab = new RankedTeamsTab();
         this.dropDownIndicatorButton = param1.viewUtil.wireButton(this.view,_loc2_.dropDownIndicator,null);
         this.tabStates = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.tabStates,this.tabStates);
         this.alertIcon = new StatefulView(this.view);
         this.view.setTimelineChild(_loc2_.tabStates.pendingAlert,this.alertIcon);
         this.dropdownPosition = _loc2_.dropdownMarker.create(this.view);
         this.tabText = _loc2_.tabStates.tabText.create(this.view);
         this.view.addEventListener(MouseEvent.ROLL_OVER,this.onRollOver);
         this.view.addEventListener(MouseEvent.ROLL_OUT,this.onRollOut);
         this.view.addEventListener(MouseEvent.MOUSE_DOWN,this.onMouseDown);
         this.view.addEventListener(MouseEvent.MOUSE_UP,this.onMouseUp);
         this.dropdown = new List();
         this.dropdown.itemRenderer = new ClassFactory(ProfileTabRenderer);
         this.dropdown.rowHeight = 30;
         this.dropdown.styleName = "profileTabDropdown";
         this.dropdown.addEventListener(ListEvent.ITEM_CLICK,this.onTeamSelected);
         RTFacade.instance.registerMediator(new ProfileTabMediator(ProfileTabMediator.NAME,this));
      }
      
      override protected function createView() : DisplayObjectProxy
      {
         return new SpriteProxy(_context);
      }
      
      public function setTabSelected(param1:Boolean) : void
      {
         this.tabSelected = param1;
         this.updateState();
      }
      
      private function onMouseDown(param1:MouseEvent) : void
      {
         this.buttonState = "Down";
         this.updateState();
      }
      
      private function onRollOver(param1:MouseEvent) : void
      {
         this.buttonState = "Over";
         this.updateState();
      }
      
      private function onTeamSelected(param1:ListEvent) : void
      {
         this.hideDropdown();
         var _loc2_:TeamInfo = param1.itemRenderer.data as TeamInfo;
         if(_loc2_)
         {
            this.teamSelected.dispatch(_loc2_);
         }
      }
      
      private function onMouseUp(param1:MouseEvent) : void
      {
         this.buttonState = "Up";
         this.updateState();
      }
      
      private function updateState() : void
      {
         var _loc1_:String = null;
         if(this.tabSelected)
         {
            _loc1_ = "selected" + this.buttonState;
         }
         else
         {
            _loc1_ = this.buttonState.toLowerCase();
         }
         this.tabStates.setCurrentState(_loc1_);
      }
      
      public function get view() : SpriteProxy
      {
         return _view as SpriteProxy;
      }
      
      private function onRollOut(param1:MouseEvent) : void
      {
         this.buttonState = "Up";
         this.updateState();
      }
      
      private function mouseOutsideHandler(param1:MouseEvent) : void
      {
         if(this.isDropdownShowing)
         {
            if(!hitTestPoint(param1.stageX,param1.stageY,true))
            {
               if(!this.dropdown.hitTestPoint(param1.stageX,param1.stageY,true))
               {
                  this.hideDropdown();
               }
            }
         }
      }
      
      public function hideDropdown() : void
      {
         this.isDropdownShowing = false;
         PopUpManager.removePopUp(this.dropdown);
         stage.removeEventListener(MouseEvent.MOUSE_DOWN,this.mouseOutsideHandler);
      }
      
      public function showDropdown(param1:Array) : void
      {
         var _loc2_:DisplayObject = null;
         var _loc3_:Point = null;
         this.isDropdownShowing = true;
         this.dropdown.dataProvider = param1;
         this.dropdown.width = this.view.getAsset().width;
         this.dropdown.setActualSize(this.view.getAsset().width,this.dropdown.getExplicitOrMeasuredHeight());
         this.dropdown.rowCount = Math.min(param1.length,8);
         PopUpManager.addPopUp(this.dropdown,this);
         if(this.dropdownPosition.getAsset())
         {
            _loc2_ = this.dropdownPosition.getAsset();
            _loc3_ = this.localToGlobal(new Point(_loc2_.x,_loc2_.y));
            this.dropdown.x = _loc3_.x;
            this.dropdown.y = _loc3_.y;
         }
         stage.addEventListener(MouseEvent.MOUSE_DOWN,this.mouseOutsideHandler);
      }
   }
}

