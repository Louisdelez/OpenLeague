package com.riotgames.pvpnet.CLS.views.helpers
{
   import blix.assets.proxy.SpriteProxy;
   import blix.assets.proxy.TextFieldProxy;
   import blix.components.button.ButtonX;
   import blix.components.timeline.StatefulView;
   import blix.components.tooltip.assignToolTip;
   import blix.context.IContext;
   import blix.frame.getEnterFrame;
   import blix.layout.data.CanvasLayoutData;
   import blix.signals.Signal;
   import com.greensock.TweenLite;
   import com.greensock.easing.Linear;
   import com.riotgames.pvpnet.CLS.localeHelper.ILocaleHelper;
   import com.riotgames.pvpnet.CLS.models.EmblemModel;
   import com.riotgames.pvpnet.CLS.views.tooltip.EmblemsToolTipHandler;
   import com.riotgames.pvpnet.CLS.views.tooltip.SingleLineToolTip;
   import com.riotgames.pvpnet.system.config.UserPreferencesManager;
   import com.riotgames.pvpnet.system.leagues.LeagueRank;
   import com.riotgames.pvpnet.system.leagues.LeagueSortOrder;
   import com.riotgames.rust.components.text.AutoSizeTextFieldProxy;
   import com.riotgames.rust.popup.PopUpManager;
   import flash.events.Event;
   import flash.events.MouseEvent;
   import flash.geom.Point;
   
   public class DivisionSelector extends SpriteProxy
   {
      
      private static const INNER_TEXT_STATE:String = "custom";
      
      private static const DIVISION_SIZE:Number = 25;
      
      private static const DIVISION_PADDING:Number = 5;
      
      private var _divisionOrder:Array = LeagueRank.values(LeagueSortOrder.DESCENDING);
      
      private var _clickElementSignal:Signal;
      
      private var _counterToClose:int = 0;
      
      private var _openedList:Boolean;
      
      private var _contentView:StatefulView;
      
      private var _upButton:ButtonX;
      
      private var _downButton:ButtonX;
      
      private var _subButtons:Vector.<MenuSelectorButton>;
      
      private var _innerButtons:Vector.<StatefulView>;
      
      private var _current_index:uint = 0;
      
      private var _userIndex:uint = 4294967295;
      
      private var _startPositionInnerY:Number = 0;
      
      public var _currentPositionInnerY:Number = 0;
      
      private var _list:MenuSelectorPopUpList;
      
      private var _innerList:SpriteProxy;
      
      private var _innerListContainer:SpriteProxy;
      
      private var _innerListContentMask:SpriteProxy;
      
      private var _mainButton:ButtonX;
      
      private var _lockRoundRobin:Boolean;
      
      private var _localeHelper:ILocaleHelper;
      
      private var _buttonBackground:SpriteProxy;
      
      public function DivisionSelector(param1:IContext, param2:int = 0)
      {
         this._current_index = param2;
         super(param1);
         this._clickElementSignal = new Signal();
         this._lockRoundRobin = false;
      }
      
      override protected function createChildren() : void
      {
         super.createChildren();
         this._localeHelper = getDependency(ILocaleHelper);
         this.linkTimelineAssets();
         this.loadDataElements();
      }
      
      override protected function addedToStageHandler(param1:Event) : void
      {
         super.addedToStageHandler(param1);
         this.setActiveItem(this._current_index,true,false);
      }
      
      override protected function removedFromStageHandler(param1:Event) : void
      {
         super.removedFromStageHandler(param1);
         if(this._openedList)
         {
            this.hideList();
         }
      }
      
      private function linkTimelineAssets() : void
      {
         this._upButton = new ButtonX(this);
         setTimelineChildByName("upButton",this._upButton);
         this._upButton.setData(int(-1));
         this._upButton.addEventListener(MouseEvent.CLICK,this.onDirectionButtonClicked);
         this._downButton = new ButtonX(this);
         setTimelineChildByName("downButton",this._downButton);
         this._downButton.setData(int(1));
         this._downButton.addEventListener(MouseEvent.CLICK,this.onDirectionButtonClicked);
         this._contentView = new StatefulView(this);
         setTimelineChildByName("content",this._contentView);
         this._mainButton = new ButtonX(this);
         setTimelineChildByName("mainButton",this._mainButton);
         this._mainButton.addEventListener(MouseEvent.CLICK,this.onMainButClicked);
         this._subButtons = new Vector.<MenuSelectorButton>();
         this._innerButtons = new Vector.<StatefulView>();
         this._contentView.setMouseEnabled(true);
         var _loc1_:SpriteProxy = new SpriteProxy(this);
         this._mainButton.setTimelineChildByName("content",_loc1_);
         this._buttonBackground = new SpriteProxy(this);
         this._mainButton.setTimelineChildByName("selectorMenuBackground",this._buttonBackground);
         this._innerList = new SpriteProxy(this);
         _loc1_.setTimelineChildByName("list",this._innerList);
         this._innerListContainer = new SpriteProxy(this);
         this._innerList.setTimelineChildByName("listContainer",this._innerListContainer);
         var _loc2_:SpriteProxy = new SpriteProxy(this);
         this._mainButton.setTimelineChildByName("rankTextMc",_loc2_);
         var _loc3_:TextFieldProxy = new TextFieldProxy(this);
         _loc3_.setMultiline(false);
         _loc2_.setTimelineChildByName("text",_loc3_);
         this._innerListContentMask = new SpriteProxy(this);
         _loc1_.setTimelineChildByName("contentMask",this._innerListContentMask);
         var _loc4_:SpriteProxy = new SpriteProxy(this);
         this._innerList.setTimelineChildByName("background",_loc4_);
         _loc4_.setVisible(false);
         this._innerList.setMask(this._innerListContentMask);
         var _loc5_:SingleLineToolTip = new SingleLineToolTip(this);
         var _loc6_:EmblemsToolTipHandler = new EmblemsToolTipHandler(_loc5_,1,0);
         assignToolTip(this._mainButton,new EmblemModel(this._localeHelper.localeLookup("ttMousingOverDivision"),""),_loc6_);
      }
      
      private function loadDataElements() : void
      {
         var _loc1_:AutoSizeTextFieldProxy = null;
         var _loc2_:Number = -5;
         var _loc3_:uint = 0;
         while(_loc3_ < this._divisionOrder.length)
         {
            _loc1_ = new AutoSizeTextFieldProxy(this);
            _loc1_ = new AutoSizeTextFieldProxy(this);
            _loc1_.setText(this._divisionOrder[_loc3_].value());
            this._innerButtons[_loc3_] = new StatefulView(this);
            this._innerButtons[_loc3_].setLinkage("elementButton");
            this._innerButtons[_loc3_].setTimelineChildByName("text",_loc1_);
            this._innerButtons[_loc3_].setCurrentState(INNER_TEXT_STATE);
            this._innerButtons[_loc3_].setY(_loc2_);
            _loc2_ += DIVISION_SIZE;
            this._innerListContainer.addChild(this._innerButtons[_loc3_]);
            _loc3_++;
         }
         invalidateLayout();
      }
      
      private function createNewList() : MenuSelectorPopUpList
      {
         var _loc2_:TextFieldProxy = null;
         var _loc4_:uint = 0;
         var _loc1_:MenuSelectorPopUpList = new MenuSelectorPopUpList(this);
         var _loc3_:uint = 0;
         while(_loc3_ < this._divisionOrder.length)
         {
            this._subButtons[_loc3_] = new MenuSelectorButton(this);
            this._subButtons[_loc3_].setLinkage("elementButton");
            this._subButtons[_loc3_].addEventListener(MouseEvent.CLICK,this.onElementClick);
            _loc4_ = _loc3_;
            this._subButtons[_loc3_].setData(_loc4_);
            _loc2_ = new TextFieldProxy(this);
            this._subButtons[_loc3_].setTimelineChildByName("text",_loc2_);
            _loc2_.setText(this._divisionOrder[_loc3_].value());
            _loc1_.addChildToList(this._subButtons[_loc3_]);
            _loc3_++;
         }
         _loc1_.setItemSelected(this._userIndex);
         return _loc1_;
      }
      
      private function onMainButClicked(param1:MouseEvent) : void
      {
         param1.stopPropagation();
         param1.stopImmediatePropagation();
         this.showList();
      }
      
      private function animateList() : void
      {
         if(this._lockRoundRobin)
         {
            this._upButton.setEnabled(this._current_index != 0);
            this._downButton.setEnabled(this._current_index != this._divisionOrder.length - 1);
         }
         var _loc1_:Boolean = Boolean(UserPreferencesManager.globalPrefs.enableAnimations);
         var _loc2_:Number = -DIVISION_SIZE * this._current_index + DIVISION_PADDING;
         this._startPositionInnerY = this._currentPositionInnerY = this._innerList.getY();
         TweenLite.to(this._innerList.getSetterProxy(),_loc1_ ? 0.3 : 0,{
            "y":_loc2_,
            "ease":Linear.easeIn
         });
      }
      
      private function onDirectionButtonClicked(param1:MouseEvent) : void
      {
         var _loc2_:ButtonX = param1.target as ButtonX;
         var _loc3_:int = _loc2_.getData() as int;
         var _loc4_:uint = (this._current_index + _loc3_) % this._divisionOrder.length;
         this._current_index = Math.min(this._divisionOrder.length - 1,_loc4_);
         this.animateList();
         this._clickElementSignal.dispatch(this._divisionOrder[this._current_index]);
      }
      
      private function onElementClick(param1:MouseEvent) : void
      {
         var _loc2_:int = this._subButtons.indexOf(param1.currentTarget);
         this._current_index = _loc2_;
         this.hideList();
         this._clickElementSignal.dispatch(this._divisionOrder[_loc2_]);
         param1.stopPropagation();
         param1.stopImmediatePropagation();
         this.animateList();
      }
      
      private function showList() : void
      {
         this._openedList = true;
         this.setOuterButtonsEnabled(false);
         var _loc1_:CanvasLayoutData = new CanvasLayoutData();
         var _loc2_:Point = this._contentView.localToGlobal(new Point(0,-1 * (DIVISION_SIZE + DIVISION_PADDING) * this._current_index));
         this._list = this.createNewList();
         var _loc3_:Number = this._innerList.getY() * this._list.getHeight() / this._innerList.getHeight();
         _loc1_.setX(_loc2_.x + this._innerList.getX());
         _loc1_.setY(_loc2_.y);
         PopUpManager.addPopUp(this._list,_loc1_,false);
         this._innerListContentMask.setVisible(false);
         getStage().addEventListener(MouseEvent.CLICK,this.onMouseStageClick,true);
         invalidateLayout();
      }
      
      private function hideList() : void
      {
         this._openedList = false;
         getEnterFrame().remove(this.onCountToClose);
         getStage().removeEventListener(MouseEvent.CLICK,this.onMouseStageClick,true);
         this.setOuterButtonsEnabled(true);
         PopUpManager.removePopUp(this._list);
         this._list = null;
         this._innerListContentMask.setVisible(true);
         invalidateLayout();
      }
      
      private function setOuterButtonsEnabled(param1:Boolean) : void
      {
         this._upButton.setMouseEnabled(param1);
         this._downButton.setMouseEnabled(param1);
         this._mainButton.setMouseEnabled(param1);
      }
      
      private function onMouseStageClick(param1:MouseEvent) : void
      {
         this._counterToClose = 0;
         getEnterFrame().add(this.onCountToClose);
      }
      
      private function onCountToClose() : void
      {
         ++this._counterToClose;
         if(this._counterToClose > 3)
         {
            this.hideList();
         }
      }
      
      public function setActiveItemByDivision(param1:LeagueRank, param2:Boolean = false, param3:Boolean = true) : void
      {
         var _loc4_:int = this.getIndexFromDivision(param1);
         this.setActiveItem(_loc4_,param2,param3);
      }
      
      public function setActiveItem(param1:int, param2:Boolean = false, param3:Boolean = true) : void
      {
         if(param3 && this._current_index == param1)
         {
            return;
         }
         this.animateList();
      }
      
      public function get clickSignal() : Signal
      {
         return this._clickElementSignal;
      }
      
      public function set lockRoundRobin(param1:Boolean) : void
      {
         this._lockRoundRobin = param1;
      }
      
      public function setUserSelectedDivision(param1:LeagueRank) : void
      {
         var _loc2_:int = this.getIndexFromDivision(param1);
         this._userIndex = this._current_index = _loc2_;
         this.animateList();
      }
      
      public function get startPositionInnerY() : Number
      {
         return this._startPositionInnerY;
      }
      
      public function set startPositionInnerY(param1:Number) : void
      {
         this._startPositionInnerY = param1;
      }
      
      private function getIndexFromDivision(param1:LeagueRank) : int
      {
         var _loc2_:int = 0;
         while(_loc2_ < this._divisionOrder.length)
         {
            if(this._divisionOrder[_loc2_] == param1)
            {
               return _loc2_;
            }
            _loc2_++;
         }
         return 0;
      }
   }
}

